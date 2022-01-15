//
//  AddMapVC.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 12/01/2022.
//

import UIKit
import MapKit

class AddMapVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    let studentAddress = UserDefaults.standard.string(forKey: "address")
    let studentLink    = UserDefaults.standard.string(forKey: "medialink")
    let firstname      = UserDefaults.standard.string(forKey: "firstname")
    let secondname     = UserDefaults.standard.string(forKey: "secondname")
    let uniqueKey      = UserDefaults.standard.string(forKey: "uniqueKey")
    var latitudeMap  = 0.0
    var longitudeMap = 0.0
    var body : StudentLocationRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        fillMapview()
        

        // Do any additional setup after loading the view.
    }
    
    func fillMapview(){
        getCoordinate(addressString: studentAddress ?? "") { coordinates, error in
            print(coordinates.longitude, "popopwe", coordinates.latitude)
            
            self.latitudeMap = coordinates.latitude
            self.longitudeMap = coordinates.longitude
        }
        var annotations = [MKPointAnnotation]()
        
        let lat = CLLocationDegrees(self.latitudeMap)
        let long = CLLocationDegrees(self.longitudeMap)
        
        body = StudentLocationRequest(uniqueKey: uniqueKey, firstName: firstname, lastName: secondname, mapString: studentAddress, mediaURL: studentLink, latitude: lat, longitude: long)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = self.firstname
        let last = self.secondname
        let mediaURL = self.studentLink
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
        
    }
    
    
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        loader.startAnimating()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
            
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
            self.loader.stopAnimating()
        }
    }

    @IBAction func finishBtn(_ sender: Any) {
        OTMClient.postNewMapAnnotation(studentbody: self.body!) { check, error in
            if check == true{
                print("horraaay")
            }
        }
    }
    /*
    // MARK: - Navigation
     @IBAction func finishBtn(_ sender: Any) {
     }
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
