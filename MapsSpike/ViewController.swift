//
//  ViewController.swift
//  MapsSpike
//
//  Created by Will Wyatt on 10/14/15.
//  Copyright (c) 2015 Will Wyatt. All rights reserved.
//

import UIKit
// Make sure to import MapKit and CoreLocation frameworks
import CoreLocation
import MapKit

// Add the location manager delegate to the class to conform to the CLLocationManager
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Create location manager
    var locationManager = CLLocationManager()
    
    // Save the location of the user in variable instead of constantly updating the location and using unnecessary memory
    var myPosition = CLLocationCoordinate2D()

    // Outlets
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set the delegate to the view
        locationManager.delegate = self
        
        // Request authorization to use location services
        locationManager.requestWhenInUseAuthorization()
        
        // Start updating the location as soon as possible
        locationManager.startUpdatingLocation()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func startGPS(sender: UIButton) {
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        println("Got location \(newLocation.coordinate.latitude) , \(newLocation.coordinate.longitude)")
        
        // Set the current location to global variable
        myPosition = newLocation.coordinate
        
        // Stop updating the location to save memory and battery
        locationManager.stopUpdatingLocation()
    
        // Update label text with location
        lblLocation.text = "Got location \(newLocation.coordinate.latitude) , \(newLocation.coordinate.longitude)"
        
        // view level of the view on the map: the higher the number the more you zoom out. Takes floating numbers
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        // Create region that will show in the mapkit view
        let region = MKCoordinateRegion(center: myPosition, span: span)
        
        // Set the region in the actual view on the device
        mapView.setRegion(region, animated: true)
        
    }


    
}

