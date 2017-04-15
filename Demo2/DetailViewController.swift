//
//  DetailViewController.swift
//  Demo2
//
//  Created by Richard de los Santos on 4/14/17.
//  Copyright © 2017 Richard de los Santos. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Organization? {
        didSet {
            // Update the view.
        }
    }

    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var row_height = 60.0
        
        if indexPath.row == 2 {
            row_height = 40
        }

        if indexPath.row == 3 {
            row_height = 20
        }

        return CGFloat(row_height)
        
    }
    // override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    
    
    
    
    // }
    
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
            
            cell.accessoryView = UIImageView(image: UIImage(named: "website"))

            cell.detailTextLabel!.text = detailItem?.url
            return cell

        }
        else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
            
            cell.accessoryView = UIImageView(image: UIImage(named: "map"))

            cell.detailTextLabel!.text = detailItem?.location
            return cell
            
        }
        else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "phone", for: indexPath)
            
            cell.accessoryView = UIImageView(image: UIImage(named: "phone"))

            cell.detailTextLabel!.text = detailItem?.phone
            return cell
            
        }
        else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "email", for: indexPath)
            
            cell.accessoryView = UIImageView(image: UIImage(named: "email"))

            cell.textLabel!.text = detailItem?.email
            return cell
            
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "register", for: indexPath)
            
            return cell

        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
                        
            if let url = URL(string:detailItem?.url as! String), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else {
                print("cannot open")
            }
            
        }

        if indexPath.row == 1 {
            
           // handled by segue
            
            
        }
   
        if indexPath.row == 2 {
            
            if let url = URL(string:"\(String(describing: detailItem?.phone))"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else {
                print("cannot open")
            }
        }

        if indexPath.row == 3 {
            
            if let url = URL(string:detailItem?.email as! String), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else {
                print("cannot open")
            }
        
        }
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowMap" {
            
            if self.tableView.indexPathForSelectedRow?.row == 1 {
                                
                let controller = (segue.destination as! UINavigationController).topViewController as! MapViewController
                controller.detailItem = detailItem
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
            
        }
        
    }

}

