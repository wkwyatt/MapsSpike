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
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Create location manager
    var locationManager = CLLocationManager()
    
    // Save the location of the user in variable instead of constantly updating the location and using unnecessary memory
    var myPosition = CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122)
    
    // Destination variable for directions
    var destination:MKMapItem = MKMapItem()

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
        
        // Create a drop pin
        let annotation = MKPointAnnotation()
        
        // Give the annotation coordinates and a title
        annotation.coordinate = myPosition
        annotation.title = "Venue"
        annotation.subtitle = "Address of the venue"
        
        // Set the drop pin in the mapView
        mapView.addAnnotation(annotation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Action button
    @IBAction func addPin(sender: UILongPressGestureRecognizer) {
        
        // Where the user is clicking in the map view
        let location = sender.locationInView(self.mapView)
        
        // Convert the location the user pressed on into a coordinate on the map
        let localCoord = self.mapView.convertPoint(location, toCoordinateFromView: self.mapView)
        
        // Create drop pin
        let pressedAnnotation = MKPointAnnotation()
        
        ///////////////////////////
        // For the directions method
        
        // Create a place mark and a map item
        let placeMark = MKPlacemark(coordinate: localCoord, addressDictionary: nil)
        
        // Set the destination for when we get directions
        destination = MKMapItem(placemark: placeMark)
        
        //////////////////////////////
        
        
        // Set drop pin attributes and coordinates
        pressedAnnotation.coordinate = localCoord
        pressedAnnotation.title = "My Location"
        pressedAnnotation.subtitle = "An address or description"
        
        // Remove current drop pins
        self.mapView.removeAnnotations(mapView.annotations)
        
        // Add new drop pin where the user pressed
        self.mapView.addAnnotation(pressedAnnotation)
    }
    
    @IBAction func showDirections(sender: UIButton) {
        
        // Create a MKDirection Request
        let request = MKDirectionsRequest()
        
        // Set the location of the beginning of the route
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        
        // Set the location of the destination
        request.setDestination(destination)
        
        // Set it to only give one route
        request.requestsAlternateRoutes = false
        
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
            
            if error != nil {
                println("Error")
            } else {
                
                // Remove the current routes that might be displayed
                var overlays = self.mapView.overlays
                self.mapView.removeOverlays(overlays)
                
                // Get the route from the response
                for route in response.routes as! [MKRoute] {
                    
                    // Display the directions on the map
                    self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
                    
                    // Show the steps for the directions
                    for next in route.steps {
                        println(next.instructions)
                    }
                }
            }
        })
    }
    
    @IBAction func startGPS(sender: UIButton) {
        
        locationManager.startUpdatingLocation()
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        // Draw the line used for drawing the directions
        let draw = MKPolylineRenderer(overlay: overlay)
        draw.strokeColor = UIColor.greenColor()
        draw.lineWidth = 3.0
        return draw
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

