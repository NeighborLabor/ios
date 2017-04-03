//
//  CreateListViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/15/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import  EasyPeasy
import Parse
import Font_Awesome_Swift
import LFTimePicker
import ChameleonFramework
import CoreLocation
import SwiftValidator



class CreateListViewController: UIViewController{
    
    let timePicker = CustomPickerController()
    let currentLocation = LocationManager.currentLocation!
    var cellHeight = 0.0
    let validator = Validator()
    
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descrLabel: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var compensationLabel: UITextField!
    
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorDescLabel: UILabel!
    @IBOutlet weak var errorAddressLabel: UILabel!
    @IBOutlet weak var errorCompensationLabel: UILabel!

    
    @IBOutlet weak var cellHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var errDateLabel: UILabel!
    @IBAction func dateAction(_ sender: Any) {
        
    }
    
    
    @IBOutlet weak var errTimeLabel: UILabel!
    @IBAction func timeAction(_ sender: Any) {
        presentTimePicker()
    }
    
    
    
    @IBOutlet weak var startTIme: UILabel!
    @IBOutlet weak var endTime: UILabel!

    @IBAction func submitAction(_ sender: Any) {
        validator.validate(self)
    }
    
    
    
    
    
//    
//    func createAListing(title: String, desc: String, address: String, startTime: NSDate, duration: Int, photo: NSData?, compensation: Double, completion: @escaping ErrorResultBlock){
//        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.outletsSetUp()
        self.registerForm()
        
    }
    
    func outletsSetUp() {
        self.closeButton.setFAIcon(icon: .FAClose, iconSize: 30)
        self.cellHeight = Double(self.cellHeightConstraint.constant)
        self.cellHeightConstraint.constant = 0
        
        self.timePicker.delegate = self
        CLGeocoder().reverseGeocodeLocation(self.currentLocation.cclocation) { (placemarks, err) -> Void in
            if let p = placemarks {
                let address = p[0].addressDictionary!
                print(address)
            } else {
                self.dismiss(animated: true, completion: {
                })
            }
        }

    }
    


}
extension CreateListViewController: LFTimePickerDelegate {
    
    func presentTimePicker() {
        self.navigationController?.present(timePicker , animated: true, completion: {})
    }
    
    func didPickTime(_ start: String, end: String) {
        
        if (start == "00:00" && end == "00:00"){
            self.timePicker.button.setFAIcon(icon: .FAClose, forState: .normal)
            self.timePicker.button.backgroundColor = UIColor.flatWatermelon
        }else{
            UIView.animate(withDuration: 0.3, animations: { 
                self.timePicker.button.setFAIcon(icon: .FACheck, forState: .normal)
                self.timePicker.button.backgroundColor = UIColor.flatGreen
                self.timePicker.button <- Width(100)
                self.timePicker.button.alpha = 0.6
            }, completion: { (_) in
                
                self.startTIme.text = start
                self.endTime.text = end
            
                self.timePicker.dismiss(animated: true, completion: {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.cellHeightConstraint.constant = CGFloat(self.cellHeight)
                    })
                    
                    
                })
            })
        }
        
    }
    
}



class CustomPickerController: LFTimePickerController{
    
    let button =  UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override func viewDidLoad() {
        self.view.backgroundColor = .flatSkyBlue
        super.viewDidLoad()
        createCloseButton()
    }
    
    
    func createCloseButton(){
        button.setFAIcon(icon: .FASquare, forState: .normal)
        button.backgroundColor = UIColor.flatBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        self.view.addSubview(button)
        button <- [
            CenterX(),
            Bottom(8),
            Height(50),
            Width(50)
        ]
        button.addTarget(self, action: #selector(click), for: UIControlEvents.touchUpInside)
        
    }
    
    // Selector
    func click(sender: Any?) {
        self.delegate?.didPickTime(self.lastSelectedLeft, end: self.lastSelectedRight)
    }
    
}



extension CreateListViewController: ValidationDelegate {
    
    func registerForm() {
        // validator for title table
        self.validator.registerField(titleLabel, errorLabel: errorTitleLabel, rules: [RequiredRule(), MinLengthRule(length: 10)])
        
        // validator for Descript table
        self.validator.registerField(descrLabel, errorLabel: errorDescLabel, rules: [RequiredRule(), MinLengthRule(length: 10)])
        
        // validator for Address table
        self.validator.registerField(addressLabel, errorLabel: errorAddressLabel, rules: [RequiredRule(), MinLengthRule(length: 10)])
        
        // validator for compensation table
        self.validator.registerField(compensationLabel, errorLabel: errorCompensationLabel, rules: [RequiredRule(),FloatRule()])
        
        
    }

    func validationSuccessful() {
        
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
    
