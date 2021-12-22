//
//  RegistrationTableViewController.swift
//  Practical
//
//  Created by Dipak Panchasara on 21/06/21.
//

import UIKit
import SkyFloatingLabelTextField
import FAPanels

class RegistrationTableViewController: UITableViewController {

    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet var txtEmailAddress: SkyFloatingLabelTextField!
    @IBOutlet var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet var txtPhoneNumber: SkyFloatingLabelTextField!
    
    var currentProfileImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.txtEmailAddress.addTarget(self, action: #selector(self.emailtextChange(textfield:)), for: UIControl.Event.editingChanged)
        self.txtPhoneNumber.addTarget(self, action: #selector(self.phoneNumberCheck(textfield:)), for: UIControl.Event.editingChanged)
        self.txtFirstName.addTarget(self, action: #selector(self.firstLastNameChange(textfield:)), for: UIControl.Event.editingChanged)
        self.txtLastName.addTarget(self, action: #selector(self.firstLastNameChange(textfield:)), for: UIControl.Event.editingChanged)
        self.txtPassword.addTarget(self, action: #selector(self.firstLastNameChange(textfield:)), for: UIControl.Event.editingChanged)
    }
    @objc func firstLastNameChange(textfield: SkyFloatingLabelTextField){
        if let text = textfield.text {
            if(text.utf16.count > 1 || !text.isBlank) {
              textfield.errorMessage = ""
            }
        }
    }
    
    @objc func emailtextChange(textfield: SkyFloatingLabelTextField){
        if let text = textfield.text {
            if(text.utf16.count < 3 || !text.isEmail) {
                textfield.errorMessage = "Invalid email"
            }
            else {
                // The error message will only disappear when we reset it to nil or empty string
                textfield.errorMessage = ""
            }
        }
    }
    
    @objc func phoneNumberCheck(textfield: SkyFloatingLabelTextField){
        if let text = textfield.text {
            if(text.utf16.count < 6 || !text.isValidPhone) {
                textfield.errorMessage = "Invalid Phone"
            }
            else {
                // The error message will only disappear when we reset it to nil or empty string
                textfield.errorMessage = ""
            }
        }
    }
    
    @IBAction func profileImageSelectTapAction(_ sender: UITapGestureRecognizer) {
        
        var isShowRemove = false
        if currentProfileImage != nil {
            isShowRemove = true
        }
        
        ImagePicker.shared.getImagePickerActionSheetAndImage(vc: self, isRemove: isShowRemove) { img in
            getMainQueue {
                self.currentProfileImage = img
                self.profileImage.image = img
            }
            
        }
    }
    
    @IBAction func btnSubmitTapAction(_ sender: UIButton) {
        if let firstName = self.txtFirstName.text,firstName.isBlank == true {
            txtFirstName.errorMessage = "Enter your first name"
            txtFirstName.becomeFirstResponder()
            return
        }
        if let lastName = self.txtLastName.text,lastName.isBlank == true {
            txtLastName.errorMessage = "Enter your last name"
            txtLastName.becomeFirstResponder()
            return
        }
        if let emailAddress = self.txtEmailAddress.text,emailAddress.isBlank == true {
            txtEmailAddress.errorMessage = "Enter your email address"
            txtEmailAddress.becomeFirstResponder()
            return
        }
        if let phoneNumber = self.txtPhoneNumber.text,phoneNumber.isBlank == true {
            txtPhoneNumber.errorMessage = "Enter your phone number"
            txtPhoneNumber.becomeFirstResponder()
            return
        }
        if let password = self.txtPassword.text {
            if password.isBlank == true {
                txtPassword.errorMessage = "Enter password"
                txtPassword.becomeFirstResponder()
            }else if !password.isValidPassword {
                txtPassword.errorMessage = "Enter valid password"
                txtPassword.becomeFirstResponder()
            }
          
            return
        }
    }
    @IBAction func btnMenuOpenTapAction(_ sender: UIButton) {
        self.panel?.openLeft(animated: true)
    }
}
