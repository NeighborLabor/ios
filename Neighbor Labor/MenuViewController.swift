//
//  MenuViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/17/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import  Eureka
import SideMenu
import  ChameleonFramework
import Font_Awesome_Swift

class HeaderView: UITableViewCell{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var icon: UILabel!
    
}

struct SegueInfo {
    var label: String?
    var destinationId: String
    var cellIdentifier : String
    var detail: String?
    var fa: FAType

}

class MenuViewController: BaseTableViewController {


    var segues = [SegueInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.configureMenu()
        populateTableView()
     }
    
    
    func handleNoUser(){
        self.desText = "No account found!"
        self.buttonText = "Sign In"
        self.segueId = "to_sign_in"
     }
    
    
    func configureMenu(){
         SideMenuManager.menuAnimationBackgroundColor = UIColor.flatWatermelon
         SideMenuManager.menuLeftNavigationController?.navigationBar.tintColor = .white
    }
    
 
    
}

// MARK: table view methods
extension MenuViewController {
    
   func populateTableView() {
    
        guard let user = AuthManager.currentUser() else{
            // not login
            print("not log in")
            handleNoUser()
            return
        }
    
    let name = (user["name"] as AnyObject).capitalized
    let email = user.email
    
    let toProfile = SegueInfo(label:name , destinationId: "to_profile", cellIdentifier: "menuheader", detail:email, fa: .FAIdCard)
    let toMyList = SegueInfo(label: "Jobs Listings", destinationId: "to_my_list", cellIdentifier: "menucell", detail: "Your listed jobs", fa: .FAPencil)
    let toActiveJobs = SegueInfo(label: "Job Applications", destinationId: "to_active_job", cellIdentifier: "menucell", detail: "Your list of pending jobs", fa: .FAHourglass)
    let toMessages = SegueInfo(label: "Message", destinationId: "to_messages", cellIdentifier: "menucell", detail: "Your conversations", fa: .FAComment)
    let toSetting = SegueInfo(label: "Setting", destinationId: "to_setting", cellIdentifier: "menucell", detail: "Application configuration", fa: .FAGear)
    segues = [toProfile, toMyList, toActiveJobs, toMessages, toSetting]
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let segue = segues[indexPath.row]

        let headercell = tableView.dequeueReusableCell(withIdentifier:  segue.cellIdentifier) as! HeaderView
        // set profile image here
        headercell.nameLabel.text = segue.label
        headercell.emailLabel.text = segue.detail
        headercell.icon.setFAIcon(icon: segue.fa, iconSize: 25)
        return headercell
        
     }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segue = segues[indexPath.row]
        SideMenuManager.menuLeftNavigationController?.performSegue(withIdentifier: segue.destinationId, sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segues.count
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
        if let segue = self.segueId {
            self.navigationController?.performSegue(withIdentifier: segue, sender: self)
        }
        
    }

}
