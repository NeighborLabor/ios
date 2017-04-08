//
//  FilterViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 4/5/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import DLRadioButton
import Parse
protocol FilterViewControllerDelegate {
    
    func didApplyFilter(query: PFQuery<PFObject>)
}


class FilterViewController: UIViewController {
 
    var delegate: FilterViewControllerDelegate?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
 
    
    var miles: Int  {
        let floorValue = floor(slider.value)
        let diff = slider.value - Float(floorValue)
        var displayValue = floorValue
        if (diff > 0.5) {
            displayValue += 1
        }
        slider.value = Float(displayValue)
        return Int(displayValue)
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        sliderValue.text = String(miles) + " miles"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.flatWhite
    }
   
    @IBOutlet weak var descendingOn: UISwitch!
    @IBOutlet weak var radioButtons: DLRadioButton!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View will Disappear")
        let query =  Listing.query()
         // if there is a distance filter
        if  miles > 1 {
            if let current = LocationManager.currentLocation {
                query?.whereKey("geopoint", nearGeoPoint: current, withinMiles: Double(miles))
             }
        }
        // if there is a sort filter
        if let selected =  radioButtons.selected(){
            let tag =  selected.tag
            
            // selection made
             let dic =  ["compensation","startTime"]
            let selection = dic[tag]
            if descendingOn.isOn == true {
                query?.addDescendingOrder(selection)
                print("Des: " + selection)
            }else{
                query?.addAscendingOrder(selection)
            }
        }
        
     delegate?.didApplyFilter(query: query!)
    }
    

    
    
    
        
}
    

