//
//  AuthViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/24/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import SwiftIconFont

class AuthViewController: BaseViewController{
    let authInteractor = AuthManager()  // Might cause memory retain cycle
    
}


class LoginViewController: AuthViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var xButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xButton.icon(from: .Octicon, code: "x", ofSize: 32)
        
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


class RegisterController : AuthViewController{
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmTF: UITextField!
    @IBOutlet weak var bioTF: UITextView!
    @IBOutlet weak var termsLabelAction: UILabel!

    
    @IBAction func registerAction(_ sender: Any) {
        
        authInteractor.signUpWith(email:emailTF.text!,
              password: passwordTF.text!, name: nameTF.text!, phone: "4139778327", ppic: nil, bio: bioTF.text!)
                { (error) in
                guard let err = error else{
                    print("registerAction: No Error")
                    return
                }
                self.showAlert(title: "Unable to Log out", message: err.localizedDescription)
        }
        
        
    }
    
}
