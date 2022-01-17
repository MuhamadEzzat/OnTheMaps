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
    var body : StudentLocationRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        fillMapview()
    }
    
    func fillMapview(){
        getCoordinate(addressString: studentAddress ?? "") { coordinates, error in
            
          
            var annotations = [MKPointAnnotation]()
            
            let lat = CLLocationDegrees(coordinates.latitude)
            let long = CLLocationDegrees(coordinates.longitude)
            
            self.body = StudentLocationRequest(uniqueKey: self.uniqueKey, firstName: self.firstname, lastName: self.secondname, mapString: self.studentAddress, mediaURL: self.studentLink, latitude: lat, longitude: long)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = self.firstname
            let last = self.secondname
            let mediaURL = self.studentLink
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first!) \(last!)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
            self.mapView.addAnnotations(annotations)
        }
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
            }else{
                let alertController = UIAlertController(title: "Alert!", message: "Location Place is not found!", preferredStyle: .alert)

               let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("OK Pressed")
                }
                
                alertController.addAction(okAction)

                self.present(alertController, animated: true, completion: nil)

            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
            self.loader.stopAnimating()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    @IBAction func finishBtn(_ sender: Any) {
        if currentReachabilityStatus == .notReachable{
            let alertController = UIAlertController(title: "Alert!", message: "No connectcion", preferredStyle: .alert)

           let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            }
            
            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)
        }else{
            OTMClient.postNewMapAnnotation(studentbody: self.body!) { check, error in
                if check == true{
                    print("horraaay")
                }
            }
        }
        
    }

}
