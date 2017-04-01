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
import RainbowSwift








class DetailListingViewController: BaseTableViewController {
    
    
    //REQURE: This needs to be set prior to load DetailVIewContoller, use prepareforsegue()
    var listing: Listing!
    
    
    //NEED THIS: When listing's owner is self
    var applicants = [PFUser]()
    var isOwner : Bool = false

    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
 
    @IBOutlet weak var iconStreetLabel: UILabel!
    @IBOutlet weak var iconDateLabel: UILabel!
    @IBOutlet weak var iconMoneyLabel: UILabel!
    
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var innerTable: UITableView!
    
    @IBOutlet weak var applyDeleteButton: UIButton!
    
    @IBAction func applyDeleteAction(_ sender: Any) {
        
        if isOwner {
            print("Delete")
            
            self.showConfirmAlert(title: "Confirm", message: "Are you sure you want to delete this listing?", completion: { 
                print("Confirm ")
            })
            
        
            
        }else{
            print("Apply")
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = String(CGFloat(listing.geopoint.distanceInMiles(to: LocationManager.currentLocation)).string1) + " Miles"
        
        configureMap()
        basicInfo()
        dynamcTable()
     }
    
    
    func configureMap(){
        let annotation = MKPointAnnotation()
        let geopoint  = listing.geopoint
        let location = CLLocationCoordinate2D(latitude:geopoint.latitude,longitude: geopoint.longitude)
        
        // 3)
        let span = MKCoordinateSpanMake(0.005, 0.01)
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
        
    }
    
    
    func dynamcTable(){
        
        self.innerTable.emptyDataSetSource = self
        self.innerTable.emptyDataSetDelegate = self
        self.desText = "0 applicants"
        
        
        let user = AuthManager.currentUser()!
         if user.objectId! == listing.createdBy.objectId! {
                    let query = PFUser.query()
                    query?.whereKey(listing.objectId!, containedIn: listing.applicants)
                    query?.findObjectsInBackground(block: { (results, error) in
                         guard let err = error else {
                            let users = results as! [PFUser]
                            self.isOwner = true
                            self.applicants = users
                            self.applyDeleteButton.setTitle("DELETE", for: .normal)
                            self.applyDeleteButton.backgroundColor = .flatWatermelon
                            self.innerTable.delegate = self
                            self.innerTable.dataSource = self
                            return
                        }
                        self.showAlert(title: "Errror", message: err.localizedDescription)
                    })
            
            
        }else{
            self.isOwner = false
            self.applicants.append(user)
            self.innerTable.delegate = self
            self.innerTable.dataSource = self
        }
   
    }
}


//Dynamic prototype cells can behave like static ones if you just return the cell without
//adding any content in cellForRowAtIndexPath, so you can have both "static like" cells and
//dynamic ones (where the number of rows and the content are variable) by using dynamic prototypes.
// http://stackoverflow.com/questions/17607240/mixing-static-and-dynamic-sections-in-a-grouped-table-view


// There are 5 required static cells in section 1 and in addition, section 2 contains 2 cells
// TotalCell = 7 when the owner is the user himself

class InnerTableCell : UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
}

extension DetailListingViewController{

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.innerTable == tableView {
            let innercell = tableView.dequeueReusableCell(withIdentifier: "innercell") as! InnerTableCell
            let user = self.applicants[indexPath.row]
            innercell.iconLabel.text = (user["name"] as! String).initial.uppercased()
            innercell.titleLabel.text = (user["name"] as! String)
            innercell.detailLabel.text = "ssdsd"
            innercell.iconLabel.layer.cornerRadius = innercell.iconLabel.frame.height * 0.5
            innercell.iconLabel.layer.masksToBounds = true
          //  innercell.iconLabel.text
            return innercell
        }
        
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.innerTable == tableView {
            if isOwner {
                return self.applicants.count
            }else{
                return 1
            }
        }
        return super.numberOfSections(in: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.innerTable == tableView {
           return applicants.count
            
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.innerTable == tableView {
           return 100
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.innerTable == tableView {
            if isOwner {
                return "Applicants"
            }else{
                return "Employer"
            }
            
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

}












 
