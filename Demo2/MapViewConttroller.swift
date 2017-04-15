
//
//  Map.swift
//  Demo2
//
//  Created by Richard de los Santos on 4/15/17.
//  Copyright © 2017 Richard de los Santos. All rights reserved.
//

import Foundation
import UIKit
import MapKit


// https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

class MapLocation: NSObject, MKAnnotation, MKMapViewDelegate {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(name: String, url: String, address: String, phone: String, email: String, location: CLLocationCoordinate2D) {
      
        self.coordinate = location
        self.title = name
     //   self.subtitle = url
        
    }

}

class MapViewController: UIViewController, MKMapViewDelegate  {

    let geocoder = CLGeocoder()
    
    @IBOutlet weak var MapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapView.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
    }
    
    var detailItem: Organization? {
        didSet {
            // Update the view.
            self.reverseLookup()
            
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.MapView.setRegion(coordinateRegion, animated: true)
    }
    
    // https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/LocationAwarenessPG/UsingGeocoders/UsingGeocoders.html#//apple_ref/doc/uid/TP40009497-CH4-SW8
    // reverse look up from address
    
    
    func reverseLookup() -> CLLocationCoordinate2D {
        
        var location = CLLocationCoordinate2D()
        
        let address = detailItem?.location
        
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            
            // process location(s)
            
            // in this case there is one
            for placemark in placemarks!  {
                
                // Process the placemark.
           
                let annotation = MapLocation.init(name: (self.detailItem?.name)!, url: (self.detailItem?.url)!, address: (self.detailItem?.location)!, phone: (self.detailItem?.phone)!, email: (self.detailItem?.email)!, location: (placemark.location?.coordinate)!)
                
                self.MapView.addAnnotation(annotation)
                
                self.centerMapOnLocation(location: (placemark.location)!)
            }
            
        })

        return location
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MapLocation {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: 0, y: -5)
                view.image = UIImage(named: "pinCustom1")
              //  view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view
        }
        return nil
    }
        
}

