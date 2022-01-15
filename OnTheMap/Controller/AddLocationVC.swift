//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 12/01/2022.
//

import Foundation
import UIKit

class AddLocationVC: UIViewController{
    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var addressTFf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openMapBtn(_ sender: Any) {
        if linkTF.text != "" && addressTFf.text != ""{
            UserDefaults.standard.set(linkTF.text, forKey: "medialink")
            UserDefaults.standard.set(addressTFf.text, forKey: "address")
            self.performSegue(withIdentifier: "openmap", sender: self)
        }else{
             let alertController = UIAlertController(title: "Alert!", message: "Please fill the required fields", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                 UIAlertAction in
                 NSLog("OK Pressed")
             }
             
             alertController.addAction(okAction)

             self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}
