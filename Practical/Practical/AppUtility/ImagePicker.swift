//
//  ImagePicker.swift
//  Practical
//
//  Created by Dipak Panchasara on 21/06/21.
//

import Foundation
import UIKit
import Photos



struct ImageInfo {
    var img: UIImage
    var imgName: String
    var type: String
    var data: Data
}
class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let shared = ImagePicker()
    let imagePicker = UIImagePickerController()
    var completionPickedImage:((UIImage?) -> Void)?
    
    override init() {
        super.init()
        
        imagePicker.allowsEditing = true 
        imagePicker.delegate = self
    }
    
    //MARK: ImagePickerActionSheet
    func getImagePickerActionSheetAndImage(vc: UIViewController,isRemove: Bool = false ,completion: @escaping ((UIImage?) -> Void)) {
        
        getMainQueue {
          
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            self.completionPickedImage = completion
            if isRemove == true {
                let removeAcrion = UIAlertAction(title: "Remove", style: .default) { (action) in
                    completion(nil)
                }
                actionSheet.addAction(removeAcrion)
            }
            
            
            let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
                self.getPickedImage(sourceType: .camera)
            }
            
            let photoButton = UIAlertAction(title: "Photo Gallery", style: .default) { (action) in
                self.getPickedImage(sourceType: .photoLibrary)
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                
            }
            
            actionSheet.addAction(cameraButton)
            actionSheet.addAction(photoButton)
            actionSheet.addAction(cancelButton)
            
            vc.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    //MARK:- GetPickedImage
    private func getPickedImage(sourceType: UIImagePickerController.SourceType) {
        
        checkPermission(sourceType: sourceType) { (isAllowed) in
            if isAllowed {
                getMainQueue {
                    self.imagePicker.sourceType = sourceType
                    if sourceType == .camera {
                        self.imagePicker.cameraCaptureMode = .photo
                        self.imagePicker.showsCameraControls = true
                    }
                    self.showPickerController()
                }
            }
        }
    }
    
    //MARK:- CheckPermission
    private func checkPermission(sourceType: UIImagePickerController.SourceType, completion: @escaping ((Bool) -> Void)) {
        
        if sourceType == .camera {
            
            let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch authStatus {
                
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (isAllowed) in
                    if isAllowed {
                        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                            completion(true)
                        }
                    }
                }
                
                break
                
            case .authorized:
                if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                    completion(true)
                }
                break
                
            case .denied, .restricted:
                showAlertForDeniedPermission(sourceType: sourceType)
                break
                
            @unknown default:
                break
            }
            
        } else if sourceType == .photoLibrary {
            
            let authStatus = PHPhotoLibrary.authorizationStatus()
            
            switch authStatus {
                
            case .authorized:
                completion(true)
                break
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized {
                        completion(true)
                    }
                }
                break
                
            case .denied, .restricted:
                showAlertForDeniedPermission(sourceType: sourceType)
                break
                
            case .limited:
                break
            @unknown default:
                break
            }
        }
    }
    
    //MARK:- ShowAlertForDeniedPermission
    private func showAlertForDeniedPermission(sourceType: UIImagePickerController.SourceType) {
        
        guard let topVC = UIApplication.getTopViewController() else {
            return
        }
        
        var message: String = "\(AppHelper.share.appName) does not have access to your photo library. To enable access, tap settings and turn on Photos."
        if sourceType == .camera {
            message = "\(AppHelper.share.appName) does not have access to your camera. To enable access, tap settings and turn on Camera."
        }
        
        
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
    
    //MARK:- showPickerController
    private func showPickerController() {
        
        getMainQueue {
            guard let tabBar = UIApplication.getTopViewController() else { return }
            tabBar.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK:- UIImagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
        var pickedImage: UIImage? = nil
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            pickedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickedImage = image
        }
                
        picker.dismiss(animated: true) {
            self.completionPickedImage?(pickedImage)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIWindow.key?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return getTopViewController(base: nav.visibleViewController)
    } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
      return getTopViewController(base: selected)
    } else if let presented = base?.presentedViewController {
      return getTopViewController(base: presented)
    }
    return base
  }
}
