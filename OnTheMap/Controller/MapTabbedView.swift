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
        
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locations {
            
            
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
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

    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
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
