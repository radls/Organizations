//
//  DetailViewController.swift
//  Demo2
//
//  Created by Richard de los Santos on 4/14/17.
//  Copyright © 2017 Richard de los Santos. All rights reserved.
//

import UIKit
import WebKit

// http://stackoverflow.com/questions/14974331/string-to-phone-number-format-in-iphone-sdk
extension String {
    public func toPhoneNumber() -> String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
}

class DetailViewController: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.tableHeaderView = tableHeader()
        tableView.tableFooterView = tableFooter()
        
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


    func tableHeader() -> UIView? {
        
        let view = UIView()
        
        view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height:200)
        
        let webView = UIWebView()
        
        webView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height:200)
        
        webView.isUserInteractionEnabled = false
        webView.backgroundColor = UIColor.white
        
        // http://jsfiddle.net/hashem/u78bQ/
        
        let embeddedHTML = "<html><head></head><body style='margin: 0;background-color:black;font-family:helvetica;font-weight:bold'><center><div style='background-color:black'> <div style='font-family:helvetica;font-weight:bold;font-size:40px;color:white;'>\(detailItem!.name.description.uppercased())</div></center><center><div style='padding:5px;padding-bottom:20px;color:lightgrey;font-family:helvetica;font-size:10px;background-color:black;line-height: 175%;height:100px;'>Lorem ipsum dolor sit amet, ligula suspendisse nulla pretium, rhoncus tempor fermentum, enim integer ad vestibulum volutpat. Nisl rhoncus turpis est, vel elit, congue wisi enim nunc ultricies sit, magna tincidunt. Maecenas aliquam maecenas ligula nostra, accumsan taciti. </div></center> </div>  <center> <div style='height:100px;padding:0px;background-color:white;'><div style='color:white;width: 50px;height: 25px;background-color: black;border-bottom-left-radius: 50px;border-bottom-right-radius: 50px;border: 0px solid gray;border-top: 0;margin-top:0px;'>&or;</div> </div></center>  </body></html>";
        
        webView.loadHTMLString(embeddedHTML, baseURL: nil)
        
        view.addSubview(webView)
        
        return view
        
    }
    
    func tableFooter() -> UIView {
        
        let view = UIView()
        
        view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height:100)
        
        let registerButton = UIButton(type: UIButtonType.roundedRect)
        registerButton.frame = CGRect(x:10, y:25, width:200, height:50);
        registerButton.setTitle("Register", for: UIControlState.normal)
        registerButton.backgroundColor = UIColor.yellow
        registerButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        registerButton.center = view.center
        
        view.addSubview(registerButton)
        
        return view
        
    }
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var row_height = 75.0
        
        if indexPath.row == 2 {
            row_height = 130
        }

        return CGFloat(row_height)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath) as? URLCell
            
            cell?.url.text = detailItem?.url.uppercased()
            
            cell?.url_icon.image = UIImage(named: "website")

            return cell!

        }
        else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath) as? LocationCell
            
            cell?.location.text = detailItem?.location.uppercased()
            
            cell?.location_icon.image = UIImage(named: "location")

            return cell!
            
        }
        else  {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as? ContactCell
            
            cell?.phone.text = detailItem?.phone.toPhoneNumber()
            cell?.email.text = detailItem?.email.uppercased()
            
            cell?.phone_icon.image = UIImage(named: "phone")
            cell?.email_icon.image = UIImage(named: "email")

            
            return cell!
            
        }
        

        
    }
    
    /* not used due to data detectors 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    */
    
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

