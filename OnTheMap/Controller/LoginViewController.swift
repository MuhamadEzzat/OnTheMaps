//
//  ViewController.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 11/01/2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.text = "moh.ezzat93@gmail.com"
        passTF.text  = "MyNewLoveAmmar<3"
        // Do any additional setup after loading the view.
    }

    @IBAction func signupBtn(_ sender: Any) {
        let str = "https://www.udacity.com/account/auth#!/signup"
        if let url = URL(string: str){
            UIApplication.shared.openURL(url)
        }
        
    }
    @IBAction func loginBtn(_ sender: Any) {
        OTMClient.login(username: emailTF.text ?? "", password: passTF.text ?? "") { check, error in
            if check == true {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "opentab", sender: self)
                }
                
            }else{
                // Create the alert controller
                 let alertController = UIAlertController(title: "Alert!", message: "Maybe Wrong cradentials or network faliure", preferredStyle: .alert)

                 // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                     UIAlertAction in
                     NSLog("OK Pressed")
                 }
                 

                 // Add the actions
                 alertController.addAction(okAction)

                 // Present the controller
                 self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
}

