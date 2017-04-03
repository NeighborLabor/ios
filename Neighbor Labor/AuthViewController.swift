//
//  AuthViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/24/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import SwiftValidator


class AuthViewController: BaseViewController{
    let authInteractor = AuthManager()  // Might cause memory retain cycle
    
}


class LoginViewController: AuthViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
  
    @IBOutlet weak var xButton: UIBarButtonItem!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        xButton.setFAIcon(icon: .FAClose, iconSize: 27)
        self.hideKeyboard()
        
    }
    
    @IBAction func loginAction(_ sender: Any) {
        // Need to check string
        authInteractor.loginWith(email: emailTF.text!, password: passwordTF.text!) { (error) in
            guard let err = error else{
                print("loginAction: No Error")
                self.dismiss(animated: true, completion: nil)
                return
            }
            self.showAlert(title: "Unable to LogIn", message: err.localizedDescription)
            
        }
    }

}


class RegisterController : AuthViewController, ValidationDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!

    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var bioTextView: UITextView!

    @IBOutlet weak var scrollView: UIScrollView!
  
    @IBOutlet weak var errNameTF: UILabel!
    @IBOutlet weak var errEmailTF: UILabel!
    @IBOutlet weak var errPasswordTF: UILabel!
    @IBOutlet weak var errConfirmTF: UILabel!
    @IBOutlet weak var errPhoneTF: UILabel!
     @IBOutlet weak var errZipCodeTF: UILabel!
    
    
    
    // ViewController.swift
    let validator = Validator()
    
    @IBAction func signupAction(_ sender: Any) {
        validator.validate(self)
    }
    
    
    func validateForm() {
        
        nameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmTF.delegate = self
        phoneTF.delegate = self
        zipCodeTF.delegate = self
        
        // Validation Rules are evaluated from left to right.
         validator.registerField(nameTF, errorLabel: errNameTF, rules: [RequiredRule(), FullNameRule()])
        // Password Validation
        validator.registerField(emailTF, errorLabel: errEmailTF , rules: [RequiredRule(), EmailRule()])
        // Password Validation
        validator.registerField(passwordTF, errorLabel: errPasswordTF, rules: [RequiredRule(), PasswordRule()])
        validator.registerField(confirmTF, errorLabel: errPasswordTF, rules: [RequiredRule(), PasswordRule()])
        validator.registerField(confirmTF, errorLabel: errPasswordTF , rules: [RequiredRule(), ConfirmationRule(confirmField: passwordTF)])
        // Phone Validation
        validator.registerField(phoneTF , errorLabel: errPhoneTF , rules: [RequiredRule(), PhoneNumberRule()])
    
        // Zip Code Validation
        validator.registerField(zipCodeTF , errorLabel: errZipCodeTF , rules: [RequiredRule(), ZipCodeRule()])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.validateForm()
    
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validator.validateField(textField){ error in
            var label : UILabel?
            var next: UITextField?
            
            
            if (textField == nameTF) {
                label = errNameTF
                next = emailTF
            } else if (textField == emailTF){
                label = errEmailTF
                next = passwordTF
            } else if (textField == passwordTF){
                label = errPasswordTF
                next = confirmTF
            } else if (textField == confirmTF){
                label = errConfirmTF
                next = phoneTF
            } else if (textField == phoneTF){
                label = errPhoneTF
                next = zipCodeTF
            }else if (textField == zipCodeTF){
                label = errZipCodeTF
                self.resignFirstResponder()
            }

            
            if error == nil{
                label?.text = ""
                next?.becomeFirstResponder()
                
            }else{
                label?.text = error?.errorMessage
            }
            
            
        }
        return true
    }
    
    func validationSuccessful() {
        
        authInteractor.signUpWith(email: emailTF.text!, password: passwordTF.text!, name: nameTF.text!, phone: phoneTF.text!, ppic: nil, bio: bioTextView.text) { (error) in
            
            guard let err = error else {
                self.navigationController?.dismiss(animated: true, completion: nil)
                return
            }
            self.showAlert(title: "Error", message: err.localizedDescription)
        }
        
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.flatWatermelon.cgColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    

}
