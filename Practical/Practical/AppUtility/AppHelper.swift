//
//  AppHelper.swift
//  Practical
//
//  Created by Dipak Panchasara on 21/06/21.
//

import Foundation
import UIKit

class AppHelper {
    static let share = AppHelper()
    
    let appName = "Practical"
    
    //App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Get Storyboard 
    func getStoryboard(eStoryboardName:eStoryboardName,bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: eStoryboardName.rawValue, bundle: bundle)
    }
    
    private init(){
        
    }
    
}


//All SDK API keys 
struct APIKeys {
    static let googleServiceAPIKey = ""
}

//MARK: - GCD
func getMainQueue(completion: @escaping (() -> Void)) {
    DispatchQueue.main.async {
        completion()
    }
}
func getDelayMainQueue(delay: Double, completion: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        completion()
    }
}
func getBackgroundQueue(qos: DispatchQoS.QoSClass = DispatchQoS.QoSClass.background, completion: @escaping (() -> Void)){
    DispatchQueue.global(qos: qos).async {
        completion()
    }
}
