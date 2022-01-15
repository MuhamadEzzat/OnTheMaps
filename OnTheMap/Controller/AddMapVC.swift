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
    }
    
    func fillMapview(){
        getCoordinate(addressString: studentAddress ?? "") { coordinates, error in
            
            self.latitudeMap = coordinates.latitude
            self.longitudeMap = coordinates.longitude
        }
        var annotations = [MKPointAnnotation]()
        
        let lat = CLLocationDegrees(self.latitudeMap)
        let long = CLLocationDegrees(self.longitudeMap)
        
        self.body = StudentLocationRequest(uniqueKey: uniqueKey, firstName: firstname, lastName: secondname, mapString: studentAddress, mediaURL: studentLink, latitude: lat, longitude: long)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = self.firstname
        let last = self.secondname
        let mediaURL = self.studentLink
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        annotations.append(annotation)
        
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
                    self.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: self.mapView.region.span), animated: true)
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

}
