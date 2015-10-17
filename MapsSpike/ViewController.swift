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

// Add the location manager delegate to the class to conform to the CLLocationManager
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Create location manager
    var locationManager = CLLocationManager()

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

    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        println("Got location \(newLocation.coordinate.latitude) , \(newLocation.coordinate.longitude)")
    
    
    }


    
}

