//
//  MasterViewController.swift
//  Demo2
//
//  Created by Richard de los Santos on 4/14/17.
//  Copyright © 2017 Richard de los Santos. All rights reserved.
//

import UIKit

//http://stackoverflow.com/questions/29912852/how-to-show-activity-indicator-while-tableview-loads
fileprivate var ActivityIndicatorViewAssociativeKey = "ActivityIndicatorViewAssociativeKey"
public extension UIView {
    var activityIndicatorView: UIActivityIndicatorView {
        get {
            if let activityIndicatorView = getAssociatedObject(&ActivityIndicatorViewAssociativeKey) as? UIActivityIndicatorView {
                return activityIndicatorView
            } else {
                let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                activityIndicatorView.activityIndicatorViewStyle = .gray
                activityIndicatorView.color = .gray
                activityIndicatorView.center = center
                activityIndicatorView.hidesWhenStopped = true
                addSubview(activityIndicatorView)
                
                setAssociatedObject(activityIndicatorView, associativeKey: &ActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activityIndicatorView
            }
        }
        
        set {
            addSubview(newValue)
            setAssociatedObject(newValue, associativeKey:&ActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension NSObject {
    func setAssociatedObject(_ value: AnyObject?, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        if let valueAsAnyObject = value {
            objc_setAssociatedObject(self, associativeKey, valueAsAnyObject, policy)
        }
    }
    
    func getAssociatedObject(_ associativeKey: UnsafeRawPointer) -> Any? {
        guard let valueAsType = objc_getAssociatedObject(self, associativeKey) else {
            return nil
        }
        return valueAsType
    }
}

open class Organization: NSObject {

    var name  = String()

    var location  = String()
    var url = String()
    
    var email = String()
    var phone = String()
    var time_stamp = Date()
    
}

class MasterViewController: UITableViewController, NSURLConnectionDelegate, UISearchBarDelegate {

    var detailViewController = DetailViewController()
    var objects = [Organization]()
    var sort_type = 0   // 0 - A-Z, 1 - Newest

    var sortButtonAZ     = UIBarButtonItem()
    var sortButtonNewest = UIBarButtonItem()
    var searchButton = UIBarButtonItem()
    
    var server_data = [Organization]()
    
    var searchbar = UISearchBar()
    var menu_toolbar = UIToolbar()
    
    var menu_toolbar_state = CGFloat(1.0)
    
    func toggleSearch() {
        
        let offset = CGFloat(44.0)
        self.menu_toolbar_state *= CGFloat(-1.0)
        
        UIView.animate(withDuration: 0.25) {
            self.menu_toolbar.center.y = self.menu_toolbar.center.y + offset*self.menu_toolbar_state
        }
        
        if(self.menu_toolbar_state == -1.0) {
            self.searchbar.becomeFirstResponder()
            
            self.searchButton.setTitleTextAttributes(
                [
                    NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 18)!
                ],
                for: .normal)
        }
        else {
            
            self.searchButton.setTitleTextAttributes(
                [
                    NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 18)!
                ],
                for: .normal)
            
            self.searchbar.resignFirstResponder()
            
            self.searchbar.text = ""
            
            objects = self.server_data
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func filterOrganizations(searchText: String) {
        
        objects = self.server_data.filter{ (($0 as! Organization).name.lowercased().contains(searchText.lowercased())) }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            self.filterOrganizations(searchText: searchText)
        }
        else {
            objects = self.server_data
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.toggleSearch()
        
        objects = self.server_data
        
        self.sortList()
        
        self.tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = tableHeader()

        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = UIColor.darkGray
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.darkGray

        self.getServerData()

    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = true
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sortList() {
        
        if sort_type == 0 {
            objects = objects.sorted(by: { $0.name < $1.name })
        }
        if sort_type == 1 {
            objects = objects.sorted(by: { $0.time_stamp > $1.time_stamp })
        }
        
        self.tableView.reloadData()

    }
    
    func insertNewObject(_ sender: Any) {
        
        let new_org = Organization()
        
        new_org.name = "Loveway"
        new_org.email = "info@lovewayinc.org"
        new_org.url = "lovewayinc.org"
        new_org.location = "54151 CR 33, Middlebury, IN 46540"
        new_org.phone = "5748255666"
        new_org.time_stamp = Date()
        
        objects.insert(new_org, at: 0)
        server_data.insert(new_org, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        self.sortList()
        
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

    func setSortAZ(){
        
        sort_type = 0
        
        self.sortList()

        // http://stackoverflow.com/questions/8849913/how-can-i-change-font-of-uibarbuttonitem
        self.sortButtonAZ.setTitleTextAttributes(
            [
                NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 18)!
            ],
            for: .normal)
        
        // http://stackoverflow.com/questions/8849913/how-can-i-change-font-of-uibarbuttonitem
        self.sortButtonNewest.setTitleTextAttributes(
            [
                NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 18)!
            ],
            for: .normal)
        
    }

    func setSortNewest(){
        
        sort_type = 1
        
        self.sortList()

        // http://stackoverflow.com/questions/8849913/how-can-i-change-font-of-uibarbuttonitem
        self.sortButtonAZ.setTitleTextAttributes(
            [
                NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 18)!
            ],
            for: .normal)
        
        // http://stackoverflow.com/questions/8849913/how-can-i-change-font-of-uibarbuttonitem
        self.sortButtonNewest.setTitleTextAttributes(
            [
                NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 18)!
            ],
            for: .normal)

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
        
        self.searchbar = UISearchBar(frame: CGRect(x:0.0, y: view.frame.size.height-44, width: self.view.frame.width, height:44))
        self.searchbar.delegate = self
        self.searchbar.showsCancelButton = true
        
        view.addSubview(searchbar)
        
        self.menu_toolbar = UIToolbar(frame: CGRect(x: 0.0, y: view.frame.size.height-44.0, width:self.view.frame.size.width, height: 44.0))
        
        self.sortButtonAZ = UIBarButtonItem(title: "A-Z", style: UIBarButtonItemStyle.done, target: self, action: #selector(MasterViewController.setSortAZ))
        
        // http://stackoverflow.com/questions/8849913/how-can-i-change-font-of-uibarbuttonitem
        self.sortButtonAZ.setTitleTextAttributes(
            [
                NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 18)!
            ],
            for: .normal)
        
        self.sortButtonNewest = UIBarButtonItem(title: "NEWEST", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MasterViewController.setSortNewest))
        self.searchButton = UIBarButtonItem(title: "SEARCH", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MasterViewController.toggleSearch))
        
        self.sortButtonAZ.tintColor = UIColor.gray
        sortButtonNewest.tintColor  = UIColor.gray
        self.searchButton.tintColor           = UIColor.gray
        
        // https://www.hackingwithswift.com/example-code/uikit/how-to-add-a-flexible-space-to-a-uibarbuttonitem
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        menu_toolbar.items = [spacer,self.sortButtonAZ,spacer,self.sortButtonNewest,spacer,self.self.searchButton,spacer]
        
        view.addSubview(menu_toolbar)
        
        return view
        
    }

    // http://stackoverflow.com/questions/24065536/downloading-and-parsing-json-in-swift
    func getServerData(){
        
        self.tableView.activityIndicatorView.startAnimating()
        
        // http://stackoverflow.com/a/35586622
        // Asynchronous Http call to your api url, using NSURLSession:
        URLSession.shared.dataTask(with: NSURL(string: "https://gist.githubusercontent.com/radls/d02f30018ed3ba6ab955861469f66906/raw/c30f22d95cfcd43836b8f3c7daffe564f9c07dc1/Locations.json")! as URL, completionHandler: { (data, response, error) -> Void in
            // Check if data was received successfully
            print(data)
            print(error)
            
            if error == nil && data != nil {
                do {
                    // Convert NSData to Dictionary where keys are of type String, and values are of any type
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<NSDictionary>
                    
                    for organization in json {
                        
                        let new_org = Organization()
                        new_org.name = organization.value(forKey: "name") as! String
                        new_org.location = organization.value(forKey: "location") as! String
                        new_org.url = organization.value(forKey: "url") as! String
                        new_org.phone = organization.value(forKey: "phone") as! String
                        new_org.email = organization.value(forKey: "email") as! String
                        new_org.time_stamp = Date()
                        
                        self.objects.insert(new_org, at: 0)
                        
                    }
                    
                    self.server_data = self.objects
                    
                    self.sortList()
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        self.tableView.activityIndicatorView.stopAnimating()
                        self.tableView.reloadData()
                        
                    })
                    
                } catch {
                    print(error)
                }
            }
        }).resume()
        
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
            
            // http://stackoverflow.com/questions/28727845/find-an-object-in-array
            if let found = server_data.index(where: {$0 as! Organization == objects[indexPath.row] as! Organization}) {
                server_data.remove(at: found)
            }

            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

}

