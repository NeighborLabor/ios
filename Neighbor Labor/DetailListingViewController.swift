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
    var currentUser : PFUser!
    
    
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
                print("Warning")
                
                self.listing.deleteInBackground(block: { (sucess, error) in
                    if sucess{
                       let _ = self.navigationController?.popViewController(animated: true)
                    }else{
                        self.showAlert(title: "Error", message: error!.localizedDescription)
                    }
                })
                
            })
            
        }else{
            
            if let user =  AuthManager.currentUser() {
                let relation = self.listing.relation(forKey: "applicants")
                relation.add(user)
                
                listing.saveInBackground(block: { (sucess, error) in
                    
                    guard let err = error else {
                        self.applyDeleteButton.setTitle("APPLIED", for: .normal)
                        self.setButton(state: .SUCCEEDED)
                    
                        return
                    }
                    self.showAlert(title: "Error", message: err.localizedDescription)
                    
                })
                
                
            }else{
                self.showAlert(title: "Error", message: "Errr")
            }
            
        }
        
    }
    
    enum State {
        case LOCK,OWNER,VERIFIELD, SUCCEEDED, PENDING
    }
    
    func setButton(state: State) {
        
        UIView.animate(withDuration: 0.2) { 
            switch state {
            case .LOCK:
                self.applyOverLay()
                
            case .VERIFIELD:
                self.applyDeleteButton.setTitle("APPLY", for: .normal)
                self.applyDeleteButton.backgroundColor = UIColor.flatSkyBlue
                self.applyDeleteButton.isEnabled = true
            case .OWNER:
                self.applyDeleteButton.setTitle("DELETE", for: .normal)
                self.applyDeleteButton.backgroundColor = .flatWatermelon
                self.applyDeleteButton.isEnabled = true
             case .SUCCEEDED:
                self.applyDeleteButton.setTitle("SUCCEEDED", for: .normal)
                self.applyDeleteButton.backgroundColor = UIColor.flatGreen
                self.applyDeleteButton.isEnabled = false
            case .PENDING:
                self.applyDeleteButton.setTitle("PENDING", for: .normal)
                self.applyDeleteButton.backgroundColor = UIColor.flatWatermelon
                self.applyDeleteButton.isEnabled = false
            }

        }
    }
    
    
    func applyOverLay() {
        self.applyDeleteButton.isEnabled = false
        self.applyDeleteButton.backgroundColor = UIColor.flatGray
        self.applyDeleteButton.setFAText(prefixText: "APPLY  ", icon: FAType.FALock, postfixText: "", size: 20, forState: .disabled)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = String(CGFloat(listing.geopoint.distanceInMiles(to: LocationManager.currentLocation)).string1) + " Miles"
        
        verifyUser()
        configureMap()
        basicInfo()
        dynamcTable()
     }
    
    
    
    
    func verifyUser() {
        
        if let user = AuthManager.currentUser() {
            self.currentUser = user
            self.setButton(state: .VERIFIELD)
            return
        }else{
            self.setButton(state: .LOCK)
        }
        
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
    
    
    func attrStringWithIcon(icon: FAType, text: String) -> NSAttributedString{
        let image  =  UIImage.init(icon:icon, size: CGSize(width: 16, height: 16))
        
        let attributedString = NSAttributedString.composed(of: [
            image.styled(with: .baselineOffset(-4)), // shift vertically if needed
            Tab.headIndent(10), // horizontal space between image and text
            text, // raw or attributed string
            ])
        
        
        
        return attributedString
        
    }
    
    func basicInfo() {
        
        
    
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
    
        if listing.applied == true {
            self.setButton(state: .PENDING)
    
        }
    
    }
    
    
    func dynamcTable(){
        
        self.innerTable.emptyDataSetSource = self
        self.innerTable.emptyDataSetDelegate = self
        self.innerTable.register( UINib(nibName: "InnerTableCell", bundle: Bundle.main), forCellReuseIdentifier: "innercell")

        self.desText = "0 applicants"
        
        guard let user = AuthManager.currentUser() else {
            
            self.setButton(state: .LOCK)
            
            return
        }
        
        if user.objectId! == listing.createdBy.objectId! {
            self.setButton(state: .OWNER)
            
            let query = listing.applicants.query()
            query.findObjectsInBackground(block: { (results, error) in
                guard let err = error else {
                    self.isOwner = true
                    self.applicants = results!
                    self.innerTable.delegate = self
                    self.innerTable.dataSource = self
                    return
                }
                self.showAlert(title: "Error", message: err.localizedDescription)
            })
            
            
        }else {
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

extension DetailListingViewController{

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.innerTable == tableView {
            let innercell = tableView.dequeueReusableCell(withIdentifier: "innercell") as! InnerTableCell
            let user = self.applicants[indexPath.row]
            innercell.iconLabel.text = (user["name"] as! String).initial.uppercased()
            innercell.titleLabel.text = (user["name"] as! String)
            innercell.detailLabel.text = "detail"

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












 
