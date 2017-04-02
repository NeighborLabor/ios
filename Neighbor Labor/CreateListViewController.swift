//
//  CreateListViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/15/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import  Eureka
import Parse


class CreateListViewController: FormViewController{
    
    
    
    
     @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    
//    func createAListing(title: String, desc: String, address: String, startTime: NSDate, duration: Int, photo: NSData?, compensation: Double, completion: @escaping ErrorResultBlock){
//        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        form
            +++ Section("basic information")
                <<< TextRow("title"){ row in
                     row.placeholder = "title"
                }
                <<< TextAreaRow("des"){
                    $0.placeholder = "description"
                }
                <<< TextRow("address"){
                    $0.placeholder = "555 huntington ave"
                }
            
            +++ Section("schedule")
                <<< DateTimeRow("startTime"){
                    $0.title = "start date"
                    $0.value = Date()
            }
                <<< PushRow<Int>("duration"){
                    $0.title = "duration (hr)"
                    $0.options = [0,1,2,3,4,5,6,7,8]
                }
            +++ Section("compensation")
                <<< DecimalRow("compensation"){
                    $0.title = "$"
                }
            +++ ButtonRow(){
                    $0.title = "Submit"
                }.onCellSelection({ (cell, row) in
                    
                    let title = self.form.rowBy(tag: "title")?.baseValue as! String
                    let desc = self.form.rowBy(tag: "des")?.baseValue as! String
                    let address = self.form.rowBy(tag: "address")?.baseValue as! String
                    let startTime = self.form.rowBy(tag: "startTime")?.baseValue as! Date as NSDate
                    let duration  = self.form.rowBy(tag: "duration")?.baseValue as! Int
                    let compensation = self.form.rowBy(tag: "compensation")?.baseValue as! Double
                    
                    let listingManager = ListingManager()
                   listingManager.createAListing(
                    title: title,
                    desc: desc,
                    address: address,
                    startTime: startTime,
                    duration: duration,
                    photo: nil,
                    compensation: compensation
                    ,completion: { (error) in
                        guard let err = error else{
                           //No Error
                            print("Created Listing")
                            self.dismiss(animated: true, completion: nil)
                            return
                        }
                        print("Error")
                        self.showAlert(title: "Error", message: err.localizedDescription)
                        
                   })
                    
                    //self.dismiss(animated: true, completion: nil)
                })
        

    
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Disabled
        // Enables smooth scrolling on navigation to off-screen ro  ws
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
    }
    
    
    
        
}
        


    
    
