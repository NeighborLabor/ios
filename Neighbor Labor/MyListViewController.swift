 //  MyListViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/21/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
 import DZNEmptyDataSet
import Font_Awesome_Swift
 import SideMenu
import Eureka
import TDBadgedCell
 
 
 
 class MyTableCell : TDBadgedCell {
    
    @IBOutlet weak var dateIcon: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
 }
 
 
 
 
 class MyListViewController: BaseTableViewController{

    var myListings = [Listing]()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        overrideEmptySet()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startFetchingData()
    }

    
    func startFetchingData() {
        //
        //WARNING
        let user = AuthManager.currentUser()!
        FetchManager.getListingOfUser(user: user) { (listings, error) in
            guard let err = error else {
                self.myListings = listings as! [Listing]
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                return
            }
            //handle error
            print(err.localizedDescription)
            self.showAlert(title: "Error", message: err.localizedDescription)
        }
    }
    
    
    func overrideEmptySet() {
        
        self.desText = "You don't have any job listing"
        self.buttonText = "Create A Listing"
        self.segueId = "listSegue"
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let listing = myListings[indexPath.row]
 
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"BadgedCell") as! MyTableCell
        cell.badgeColor = .flatGray


        listing.applicants.query().countObjectsInBackground { (count, error) in
            guard let err = error else {
                cell.badgeString = String(count)
                return
            }
            self.showAlert(title: "Error", message: err.localizedDescription)
        }
        
        
        cell.titleLabel?.text = listing.title
        cell.subTitleLabel?.text = listing.descr
        cell.dateIcon.text = (listing.startTime as Date).relativeTimeDescription()
        return cell
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myListings.count
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if let segue = self.segueId {
             self.navigationController?.viewControllers[0].performSegue(withIdentifier: segue, sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let list = myListings[indexPath.row]
        self.navigationController?.viewControllers[0].performSegue(withIdentifier: "to_detail", sender: list)
    }
    
}
 
 
 
 
 
