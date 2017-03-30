//
//  DetailListingViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/29/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import MapKit
import Font_Awesome_Swift
import BonMot
import Parse

class DetailListingViewController: BaseTableViewController {
    
    
    
    var listing: Listing!
    

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
 
    @IBOutlet weak var iconStreetLabel: UILabel!
    @IBOutlet weak var iconDateLabel: UILabel!
    @IBOutlet weak var iconMoneyLabel: UILabel!
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileCityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = String(listing.geopoint.distanceInMiles(to: LocationManager.currentLocation)) + " Miles"
        
        configureMap()
        basicInfo()
     }
    
    
    func configureMap(){
        let annotation = MKPointAnnotation()
        let geopoint  = listing.geopoint
        let location = CLLocationCoordinate2D(latitude:geopoint.latitude,longitude: geopoint.longitude)
        
        // 3)
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        // 4)
        annotation.coordinate = location
        annotation.title = listing.address
         mapView.addAnnotation(annotation)
    }
    
    func basicInfo() {
        
        func attrStringWithIcon(icon: FAType, text: String) -> NSAttributedString{
            let image  =  UIImage.init(icon:icon, size: CGSize(width: 16, height: 16))

            let attributedString = NSAttributedString.composed(of: [
                image.styled(with: .baselineOffset(-4)), // shift vertically if needed
                Tab.headIndent(10), // horizontal space between image and text
                text, // raw or attributed string
                ])

            return attributedString
        
        }
        
    
        let listTime = listing.startTime as Date
        let (d, t) = listTime.date_time_tup()
        let (_, adJustTime) = listTime.addMins(m: listing.duration).date_time_tup()
        let time = t + "  - " + adJustTime
        self.titleLabel.text =  listing.title
        self.descriptionLabel.text = listing.descr

        self.iconDateLabel.attributedText = attrStringWithIcon(icon: .FAClockO, text: d.uppercased())
        self.iconStreetLabel.attributedText = attrStringWithIcon(icon: .FAMapMarker, text: "LOCATION")
        self.iconMoneyLabel.attributedText = attrStringWithIcon(icon: .FAMoney, text: "COMPENSATION")
        
        self.timeLabel.text = time.uppercased()
        self.moneyLabel.text = "$" + CGFloat( listing.compensation).string2
        
        
        self.profileLabel.layer.cornerRadius = self.profileLabel.frame.height * 0.5
        self.profileLabel.layer.masksToBounds = true
        
          listing.createdBy.fetchInBackground(block: { (user, error) in
            guard let err = error else {
                
                if user != nil {
                    let u = user as! PFUser
                    if (u["name"] != nil){
                        let name =  (u["name"] as! String)
                        self.profileLabel.text = name.initial.uppercased()
                        self.profileNameLabel.text = name
                        self.profileCityLabel.text = "Boston, MA"
                        
                    }
                
                }
                
                return
            }
            
            self.showAlert(title: "Error", message: err.localizedDescription)
            
        })
        
    }
    


    
}






 