//
//  MapTabbedView.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 11/01/2022.
//

import Foundation
import UIKit
import MapKit

class MapTabbedView: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
    var locations = [Results]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(self.logoutbutton))
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .done, target: self, action: #selector(self.addStudent)), UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .done, target: self, action: #selector(self.getData))]
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func fillMapview(){
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.
        
        for dictionary in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    @objc func addStudent(){
        self.performSegue(withIdentifier: "add", sender: self)
    }
    
    @objc func getData(){
        OTMClient.getStudents { check, error, results in
            if check{
                self.locations = results!.results!
                print(self.locations.count, "PPPP")
                DispatchQueue.main.async {
                    self.fillMapview()
                }
            }
        }
    }
    
    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    
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

    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
//    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//
//        if control == annotationView.rightCalloutAccessoryView {
//            let app = UIApplication.sharedApplication()
//            app.openURL(NSURL(string: annotationView.annotation.subtitle))
//        }
//    }
    
    @objc func logoutbutton(){
        OTMClient.logout { check, error in
            if check {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                    self.view.window?.rootViewController = viewController
                }
            }
        }
    }
    
}
