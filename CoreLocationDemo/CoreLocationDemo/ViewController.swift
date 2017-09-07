//
//  ViewController.swift
//  CoreLocationDemo
//
//  Created by Luo, Yuyang on 7/9/17.
//  Copyright © 2017 Luo, Yuyang. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    private let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()

    }

    /// Updates user points and queries for nearby pois if needed.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        /// Updates user point
        guard let userLocation = locations.last else {
            return
        }
        
        print(String(format: "%f, %f",
                     userLocation.coordinate.latitude,
                     userLocation.coordinate.longitude))
    }
}

