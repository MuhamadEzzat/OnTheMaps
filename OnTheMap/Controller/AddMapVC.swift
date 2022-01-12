//
//  AddMapVC.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 12/01/2022.
//

import UIKit
import MapKit

class AddMapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let studentAddress = UserDefaults.standard.string(forKey: "address")
    let studentLink    = UserDefaults.standard.string(forKey: "medialink")
    let firstname      = UserDefaults.standard.string(forKey: "firstname")
    let secondname     = UserDefaults.standard.string(forKey: "secondname")
    let uniqueKey      = UserDefaults.standard.string(forKey: "uniqueKey")
    var latitudeMap  = 0.0
    var longitudeMap = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }

    @IBAction func finishBtn(_ sender: Any) {
        OTMClient.postNewMapAnnotation(uniqueKey: uniqueKey ?? "", firstName: firstname ?? "", lastName: secondname ?? "", mapString: studentAddress ?? "", mediaURL: studentLink ?? "", latitude: latitudeMap ?? 0.0, longitude: longitudeMap ?? 0.0) { check, error in
            if check {
                print("Yupeeee")
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
