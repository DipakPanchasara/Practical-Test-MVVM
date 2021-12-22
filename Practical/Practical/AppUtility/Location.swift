//
//  Location.swift
//  Practical
//
//  Created by Dipak Panchasara on 21/06/21.
//

import Foundation
import CoreLocation
import UIKit

var locationAuthorizationStatus: ((CLAuthorizationStatus) -> Void)?
class Location: NSObject {
    
    var locationManager: CLLocationManager!
    var myCurrentLocation: CLLocation!
    var locationUpdated: ((CLLocation?,Error?) -> Void)?
    var myCurrentPlace: ((CLPlacemark?,Error?) -> Void)?
  
    class var shared : Location {
        struct Static {
            static let instance : Location = Location()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        self.initLocationManager()
        
    }
    func status() -> CLAuthorizationStatus{
        if #available(iOS 14.0, *) {
            return CLLocationManager().authorizationStatus
        }else {
            return CLLocationManager.authorizationStatus()
        }
       
        
    }
    func initLocationManager() {
        if CLLocationManager.locationServicesEnabled()  {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.myCurrentLocation = CLLocation(latitude: 0, longitude: 0)
            
            if #available(iOS 14.0, *) {
                if self.locationManager.authorizationStatus == .notDetermined {
                    getMainQueue {
                        self.locationManager.requestWhenInUseAuthorization()
                    }
                    
                }else {
                    locationAuthorizationStatus?(self.locationManager.authorizationStatus)
                }
            } else {
                // Fallback on earlier versions
                if CLLocationManager.authorizationStatus() == .notDetermined {
                    getMainQueue {
                        self.locationManager.requestWhenInUseAuthorization()
                    }
                }else {
                    locationAuthorizationStatus?(CLLocationManager.authorizationStatus())
                }
            }
        }else {
            
        }
    }
    
    func startUpdatingLoation(_ handalCallback: ((CLLocation?,Error?) -> Void)? ) -> Bool {
        
        locationManager.startUpdatingLocation()
        self.locationUpdated = handalCallback
        return true
    }
    
    func stopUpdatingLoation() {
        locationManager.stopUpdatingLocation()
    }
    
    func getNearestPlaces(_ handalCallback: @escaping ((CLPlacemark?,Error?) -> Void)) {
        
        self.myCurrentPlace = handalCallback
        CLGeocoder().reverseGeocodeLocation(myCurrentLocation!, preferredLocale: Locale(identifier: "en-US"), completionHandler: { (arrayPlaceMark, error) in
            if let err = error {
                self.myCurrentPlace?(nil,err)
            } else if let finalArrayofPlaces = arrayPlaceMark, finalArrayofPlaces.count > 0 {
                self.myCurrentPlace?(finalArrayofPlaces.first,nil)
            }
        })
    }
}

extension Location: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let finalLocations = locations.sorted(by: { $0.horizontalAccuracy < $1.horizontalAccuracy })
        if let firstObj = finalLocations.first {
            self.myCurrentLocation = firstObj
            self.locationUpdated?(self.myCurrentLocation, nil)
            self.stopUpdatingLoation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.stopUpdatingLoation()
        self.locationUpdated?(nil, error)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        @unknown default:
            break
        }
        locationAuthorizationStatus?(status)
        
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestAlwaysAuthorization()
                break
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
                break
            case .authorizedAlways:
                manager.startUpdatingLocation()
                break
            case .restricted:
                // restricted by e.g. parental controls. User can't enable Location Services
                break
            case .denied:
                // user denied your app access to Location Services, but can grant access from Settings.app
                break
            @unknown default:
                break
            }
            locationAuthorizationStatus?(manager.authorizationStatus)
        } else {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .notDetermined:
                manager.requestAlwaysAuthorization()
                break
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
                break
            case .authorizedAlways:
                manager.startUpdatingLocation()
                break
            case .restricted:
                // restricted by e.g. parental controls. User can't enable Location Services
                self.showAlertForDeniedPermission()
                break
            case .denied:
                self.showAlertForDeniedPermission()
                // user denied your app access to Location Services, but can grant access from Settings.app
                break
            @unknown default:
                break
            }
            locationAuthorizationStatus?(status)
        }
    }
    //MARK:- ShowAlertForDeniedPermission
    private func showAlertForDeniedPermission() {
        
        guard let topVC = UIApplication.getTopViewController() else {
            return
        }
        
        var message: String = "\(AppHelper.share.appName) does not have access to your location. To enable access, tap settings and turn on Location."
       
        
        
        let alert = UIAlertController(title: AppHelper.share.appName, message: message, preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        let settingButton = UIAlertAction(title: "Settings", style: .default) { (action) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (isOpened) in
                
            })
        }
        
        alert.addAction(cancelButton)
        alert.addAction(settingButton)
        
        topVC.present(alert, animated: true, completion: nil)
    }
}
