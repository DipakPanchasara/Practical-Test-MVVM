//
//  AppDelegate.swift
//  Practical
//
//  Created by Dipak Panchasara on 21/06/21.
//

import UIKit
import FAPanels
import IQKeyboardManagerSwift
import MapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.setupDefaultSettings()
        self.setupAPIKeys()
        self.setUpHome()
        
        return true
    }

    
    func setupDefaultSettings(){
        IQKeyboardManager.shared.enable = true
    }
    
    // Setup API keys
    func setupAPIKeys(){
        
    }
    
    
    // Setup Side Menu and Tabbar
    func setUpHome(){
        let homeStoryboard = AppHelper.share.getStoryboard(eStoryboardName: eStoryboardName.home)
        if let menuVC = homeStoryboard.instantiateViewController(withIdentifier: MenuTableViewController.getName()) as? MenuTableViewController,let center = homeStoryboard.instantiateViewController(withIdentifier: AppTabViewController.getName()) as? AppTabViewController  {
            let initialVC = FAPanelController()
            initialVC.center(center).left(menuVC)
            if let key = UIWindow.key{
                key.rootViewController = initialVC
                key.makeKeyAndVisible()
            }else {
                self.window?.rootViewController = initialVC
                self.window?.makeKeyAndVisible()
            }
        }
    }

}

