//
//  MapViewController.swift
//  Practical
//
//  Created by Dipak Panchasara on 22/06/21.
//


import UIKit
import FAPanels
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapview: MKMapView! {
        didSet {
            self.mapview.showsUserLocation = true
            self.mapview.showsCompass = true 
        }
    }
    @IBOutlet var btnMenu: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMap()
    }
    func setupMap(){
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        self.view.bringSubviewToFront(self.btnMenu)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let location = Location.shared
        let currentStatus = location.status()
        if currentStatus == .authorizedAlways || currentStatus == .authorizedWhenInUse {
            self.getCurrentLocation()
        }
        locationAuthorizationStatus = { status in 
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                self.getCurrentLocation()
            }
        }
    }
    
    func getCurrentLocation(){
        let location = Location.shared
        _ = location.startUpdatingLoation { clLocation, error in
          location.stopUpdatingLoation()
              if let latLong = clLocation {
                  getMainQueue {
                      

                      let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                      let region =  MKCoordinateRegion(center: latLong.coordinate, span: span)
                      self.mapview.setRegion(region, animated: true)
                  }
              }
          }

    }
    
    @IBAction func btnOpenMenuTapAction(_ sender: UIButton) {
        self.panel?.openLeft(animated: true)
    }
}
