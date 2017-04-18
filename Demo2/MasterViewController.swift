//
//  MasterViewController.swift
//  Demo2
//
//  Created by Richard de los Santos on 4/14/17.
//  Copyright © 2017 Richard de los Santos. All rights reserved.
//

import UIKit

open class Organization: NSObject {

    var name  = String()

    var location  = String()
    var url = String()
    
    var email = String()
    var phone = String()
    
}

class MasterViewController: UITableViewController {

    var detailViewController = DetailViewController()
    var objects = [Organization]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = tableHeader()

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray

    }

    override func viewWillAppear(_ animated: Bool) {
      //  clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        
        let new_org = Organization()
        
        new_org.name = "Loveway"
        new_org.email = "info@lovewayinc.org"
        new_org.url = "lovewayinc.org"
        new_org.location = "54151 CR 33, Middlebury, IN 46540"
        new_org.phone = "5748255666"
        
        objects.insert(new_org, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] 
                let controller = segue.destination as! DetailViewController //(segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.title = object.name
                //controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    func tableHeader() -> UIView? {
        
        let view = UIView()
        
        view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height:200)
        
        let webView = UIWebView()
        
        webView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height:200)
        
        webView.isUserInteractionEnabled = false
        webView.backgroundColor = UIColor.white
        
        let embeddedHTML = "<html><head></head><body><center><div style='font-family:helvetica;font-weight:bold;font-size:40px;'>GET INVOLVED</div></center><center><div style='color:grey;font-family:helvetica;font-size:10px;line-height: 175%;'>Lorem ipsum dolor sit amet, ligula suspendisse nulla pretium, rhoncus tempor fermentum, enim integer ad vestibulum volutpat. Nisl rhoncus turpis est, vel elit, congue wisi enim nunc ultricies sit, magna tincidunt. Maecenas aliquam maecenas ligula nostra, accumsan taciti. Sociis mauris in integer, a dolor netus non dui aliquet, sagittis felis sodales, dolor sociis mauris, vel eu libero cras. </div></center> </body></html>";
        
        webView.loadHTMLString(embeddedHTML, baseURL: nil)
        
        view.addSubview(webView)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: view.frame.size.height-44.0, width:self.view.frame.size.width, height: 44.0))
        
        let button1 = UIBarButtonItem(title: "A-Z", style: UIBarButtonItemStyle.done, target: self, action: nil)
        
        // http://stackoverflow.com/questions/8849913/how-can-i-change-font-of-uibarbuttonitem
        button1.setTitleTextAttributes(
            [
                NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 18)!
            ],
            for: .normal)
        
        let button2 = UIBarButtonItem(title: "NEWEST", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        let button3 = UIBarButtonItem(title: "SEARCH", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
        button1.tintColor = UIColor.gray
        button2.tintColor = UIColor.gray
        button3.tintColor = UIColor.gray
        
        // https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-flexible-space-to-a-uibarbuttonitem
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [spacer,button1,spacer,button2,spacer,button3,spacer]
        
        view.addSubview(toolbar)
        
        return view
        
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] 
        cell.textLabel!.text = object.name.uppercased()
        cell.detailTextLabel!.text = object.url
        return cell
    }
    
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

