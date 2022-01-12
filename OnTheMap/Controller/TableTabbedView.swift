//
//  TableTabbedView.swift
//  OnTheMap
//
//  Created by Mohamed Ezzat on 11/01/2022.
//

import Foundation
import UIKit

class TableTabbedView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    var locations = [Results]()
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(self.logoutbutton))
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .done, target: self, action: #selector(self.addStudent)), UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .done, target: self, action: #selector(self.getData))]
        
    }
    
    @objc func addStudent(){
        self.performSegue(withIdentifier: "add", sender: self)
    }
    
    @objc func getData(){
        OTMClient.getStudents { check, error, results in
            if check{
                self.locations = results!.results!
                DispatchQueue.main.async {
                    self.tbl.reloadData()
                }
                print("ELhamdulelah", self.locations)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = locations[indexPath.row].firstName + locations[indexPath.row].lastName
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.detailTextLabel?.text = locations[indexPath.row].mediaURL
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        app.openURL(URL(string: locations[indexPath.row].mediaURL)!)
                
        tableView.deselectRow(at: indexPath, animated: true)
        }
    
    @objc func logoutbutton(){
        OTMClient.logout { check, error in
            if check {
                print("Horrrrray")
            }
        }
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        print("?W?W?W")
        OTMClient.logout { check, error in
            if check {
                print("Horrrrray")
            }
        }
    }
}
