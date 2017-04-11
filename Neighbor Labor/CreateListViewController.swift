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
import DatePickerDialog
import  AddressBookUI
import IQKeyboardManagerSwift

import AFDateHelper

class CreateListViewController: UIViewController{
    
    let timePicker = CustomPickerController()
    let currentLocation = LocationManager.currentLocation!
    let validator = Validator()
    @IBOutlet weak var errSubmitLabel: UILabel!
    
    
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

    // when a date is selected
    // it will store ins selectedDate
    var selectedDate: Date!
    
    @IBOutlet weak var selectedTimeLabel: UILabel!
    // This will only be seen when open
    // it will store ins selectedDate
 
    @IBOutlet weak var errDateLabel: UILabel!
    @IBOutlet weak var hiddenDateContraint: NSLayoutConstraint!
    var hiddenDateHeight = 0.0
     @IBOutlet weak var dateButton: UIButton!
    @IBAction func dateAction(_ sender: Any) {
        DatePickerDialog().show(title: "DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            guard let d = date else{
                print("No Date: Cancel action")
                return
            }
            self.selectedTimeLabel.text = d.toStringWithRelativeTime()
    
            // store in selectedDate
            self.selectedDate = d
             UIView.animate(withDuration: 0.3, animations: {
                self.dateButton.backgroundColor = UIColor.flatSkyBlue
                self.hiddenDateContraint.constant = CGFloat(self.hiddenDateHeight)
            })

        }
    }
    
    
    @IBOutlet weak var errTimeLabel: UILabel!
    @IBOutlet weak var hiddenTimeConstraint: NSLayoutConstraint!
    var hiddenTimeHeight = 0.0

    @IBOutlet weak var timeButton: UIButton!
    
    @IBAction func timeAction(_ sender: Any) {
        presentTimePicker()
    }
    

    @IBOutlet weak var startTIme: UILabel!
    @IBOutlet weak var endTime: UILabel!
    var sTime: Date!
    var eTime: Date!
    
    
    
    @IBAction func submitAction(_ sender: Any) {
        validator.validate(self)
    }

    
//    
//    func createAListing(title: String, desc: String, address: String, startTime: NSDate, duration: Int, photo: NSData?, compensation: Double, completion: @escaping ErrorResultBlock){
//        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create a listing"
        // store the storyboard heights
        self.hiddenDateHeight = Double(self.hiddenDateContraint.constant)
        self.hiddenTimeHeight = Double(self.hiddenTimeConstraint.constant)
        self.hideKeyboard()
        IQKeyboardManager.sharedManager().enable = true

        
        // set layout height = 0 or hidden
        self.hiddenTimeConstraint.constant = 0
        self.hiddenDateContraint.constant = 0
        
        self.outletsSetUp()
        self.registerForm()
        
        
        
    }
    
    func outletsSetUp() {
        self.closeButton.setFAIcon(icon: .FAClose, iconSize: 30)
        self.timePicker.delegate = self
    }


}
extension CreateListViewController: LFTimePickerDelegate {
    
    
    func presentTimePicker() {
        self.navigationController?.present(timePicker , animated: true, completion: {})
    }
    
    func didPickTime(_ start: String, end: String) {
        sTime = Date(fromString: start, format: .custom("HH:mm"))!.adjust(.hour, offset: 24)
        eTime = Date(fromString: end, format: .custom("HH:mm"))!.adjust(.hour, offset: 24)
    
        
        
        self.startTIme.text = sTime.format_AM_PM
        self.endTime.text = eTime.format_AM_PM
        let duration =  eTime.since(sTime, in: .minute)
        
        if (duration <= 0){
            self.timePicker.button.setFAIcon(icon: .FAClose, forState: .normal)
            self.timePicker.button.backgroundColor = UIColor.flatWatermelon
             self.timePicker.button <- Width(100)
            UIView.animate(withDuration: 0.3, animations: {
                self.hiddenTimeConstraint.constant = CGFloat(self.hiddenTimeHeight)
                self.timePicker.button <- Width(50)
             })

    
            return
        }else{
            UIView.animate(withDuration: 0.3, animations: { 
                self.timePicker.button.setFAIcon(icon: .FACheck, forState: .normal)
                self.timePicker.button.backgroundColor = UIColor.flatGreen
                self.timePicker.button.alpha = 0.6
            }, completion: { (_) in
            
            
                self.timePicker.dismiss(animated: true, completion: {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.hiddenTimeConstraint.constant = CGFloat(self.hiddenTimeHeight)
                        self.timeButton.backgroundColor = .flatSkyBlue
                    })
                    
                    
                })
            })
        }
        
    }
    
}



extension CreateListViewController: ValidationDelegate {
    
    func registerForm() {
        // validator for title table
        self.validator.registerField(titleLabel, errorLabel: errorTitleLabel, rules: [RequiredRule(), MinLengthRule(length: 5)])
        
        // validator for Descript table
        self.validator.registerField(descrLabel, errorLabel: errorDescLabel, rules: [RequiredRule(), MinLengthRule(length: 5)])
        
        // validator for Address table
        self.validator.registerField(addressLabel, errorLabel: errorAddressLabel, rules: [RequiredRule(), MinLengthRule(length: 5)])
        
        // validator for compensation table
        self.validator.registerField(compensationLabel, errorLabel: errorCompensationLabel, rules: [RequiredRule(),FloatRule()])
        
        
    }

    func validationSuccessful() {

        if self.hiddenDateContraint.constant == 0 {
            self.dateButton.backgroundColor = .flatWatermelon
            self.errDateLabel.textColor = .flatWatermelon
            return
        }
        
        if self.hiddenTimeConstraint.constant == 0 {
            self.timeButton.backgroundColor = .flatWatermelon
            self.errTimeLabel.textColor = .flatWatermelon
            self.errSubmitLabel.text = "Check your input fields!"
            return
        }
        
        let selectDate = self.selectedDate.dateFor(.startOfDay)

         let beginDateTime = selectDate.adjust(.minute, offset: Int(self.sTime.since(self.sTime.dateFor(.startOfDay), in: .minute)))
        let endDateTime = selectDate.adjust(.minute, offset: Int(self.eTime.since(self.eTime.dateFor(.startOfDay), in: .minute)))
    
        print(" Start Time +  : \(beginDateTime)" )
        print(" End Time + : \(endDateTime)" )
        
        if beginDateTime.compare(.isInThePast) {
            self.errSubmitLabel.text = "The date or time your entered has expireds"
            self.errDateLabel.textColor = UIColor.flatWatermelon
            return
        }
        let duration = endDateTime.since(beginDateTime, in: .minute)
        print("Duration: \(duration)" )
        
        // All feield clear
        
        print(beginDateTime.format_month)

        ListingManager().createAListing(title: titleLabel.text!, desc: descrLabel.text!, address: addressLabel.text!, startTime: beginDateTime as NSDate, duration: Int(duration), photo: nil, compensation: Double(compensationLabel.text!)!) { (error) in
            guard let err = error else {
                print("No Error")
                self.navigationController?.dismiss(animated: true, completion: nil)
                return
            }
            self.showAlert(title: "Error", message: err.localizedDescription)
        }
//
//
        
    }
    

    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        var count = 0
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.flatWatermelon.cgColor
                field.layer.borderWidth = 1.0
                count = count+1
            }
            if count > 0 {
                self.errSubmitLabel.text = "Invlaid fields (\(count))"
                self.errSubmitLabel.textColor = UIColor.flatWatermelon
            }
            
            // works if you add labels
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
        }
    }
    
    
    
}
    



class CustomPickerController: LFTimePickerController{
    
    let button =  UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .flatSkyBlue
        self.view.alpha = 1
        self.view.backgroundColor = UIColor.flatSkyBlue
        button.backgroundColor = UIColor.flatSkyBlue
        self.button <- Width(50)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCloseButton()
    }
    
    
    func createCloseButton(){
        button.setFAIcon(icon: .FASquare, forState: .normal)
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


