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


class CreateListViewController: UIViewController{
    
    let timePicker = CustomPickerController()
    let currentLocation = LocationManager.currentLocation!
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descrLabel: UITextView!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var compensationLabel: UITextField!
    
    
    @IBOutlet weak var startTIme: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
//    
//    func createAListing(title: String, desc: String, address: String, startTime: NSDate, duration: Int, photo: NSData?, compensation: Double, completion: @escaping ErrorResultBlock){
//        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.outletsSetUp()
        
    }
    
    func outletsSetUp() {
        self.closeButton.setFAIcon(icon: .FAClose, iconSize: 30)
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
                self.timePicker.dismiss(animated: true, completion: nil)
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


    
    
