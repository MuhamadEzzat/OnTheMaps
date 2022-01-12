//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

class OTMClient {
    
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case createSessionId
        case logout
        
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
                
            case .createSessionId:
                return Endpoints.base + "/authentication/session/new"
            case .logout:
                return Endpoints.base + "/authentication/session"
            
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
        
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UserData.self, from: data)  as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
   
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
            
            let decoder = JSONDecoder()
            do{
                let model = try decoder.decode(UserData.self, from: newData!)
                if model.account != nil{
                    UserDefaults.standard.set(model.session?.id, forKey: "sessionID")
                    UserDefaults.standard.set("Test", forKey: "firstname")
                    UserDefaults.standard.set("Student", forKey: "secondname")
                    UserDefaults.standard.set(model.account?.key, forKey: "uniqueKey")
                    completion(true, nil)
                }else{
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                   
                }
                
                
            }catch{
                completion(false, nil)
                print(error.localizedDescription, "HEEEEH2")
            }
            
          
            
        }
        task.resume()
    }
    
//    class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
//        let body = PostSession(requestToken: Auth.requestToken)
//        taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) { response, error in
//            if let response = response {
//                Auth.sessionId = response.sessionId
//                completion(true, nil)
//            } else {
//                completion(false, nil)
//            }
//        }
//    }
//
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        let sessionid = String(describing: UserDefaults.standard.string(forKey: "sessionID")!)
        print(sessionid)
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"sessionId\": \"3590070931S797c7123a718e7e278c4fad1f8c81271\"}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
            
            let decoder = JSONDecoder()
            do{
                let model = try decoder.decode(SessionData.self, from: newData!)
                    completion(true, nil)
                
            }catch{
                completion(false, nil)
                print(error.localizedDescription, "HEEEEH2")
            }
            
          
            
        }
        task.resume()
    }
    
    class func getStudents(completion: @escaping (Bool, Error?, StudentsResults?) -> Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error...
              return
          }
          print(String(data: data!, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do{
                let model = try decoder.decode(StudentsResults.self, from: data!)
                completion(true, nil, model)
                
            }catch{
                completion(false, nil, nil)
                print(error.localizedDescription, "HEEEEH2")
            }
        }
        task.resume()
    }
   
    class func postNewMapAnnotation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, completion: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody =
        "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\", \"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\", \"latitude\": \"\(latitude)\", \"longitude\": \"\(longitude)\"}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
            print(response, "ooo")
            completion(true, nil)
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
}
