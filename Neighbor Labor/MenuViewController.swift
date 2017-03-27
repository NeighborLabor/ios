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

class HeaderView: UITableViewCell{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imView: UIImageView!

    
}

struct SegueInfo {
    var label: String
    var destinationId: String
    var cellIdentifier : String
}

class MenuViewController: UITableViewController {


    var segues = [SegueInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toProfile = SegueInfo(label:"Rixing", destinationId: "to_profile", cellIdentifier: "menuheader")
        let toMyList = SegueInfo(label: "My List", destinationId: "to_my_list", cellIdentifier: "menucell")
        let toActiveJobs = SegueInfo(label: "Active Jobs", destinationId: "to_active_job", cellIdentifier: "menucell")
        let toMessages = SegueInfo(label: "Message", destinationId: "to_messages", cellIdentifier: "menucell")
        let toSetting = SegueInfo(label: "Setting", destinationId: "to_setting", cellIdentifier: "menucell")

        segues = [toProfile, toMyList, toActiveJobs, toMessages, toSetting]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
     }
    
    
  
    
}

// MARK: table view methods
extension MenuViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let segue = segues[indexPath.row]
        print("cellforrow")
        print(segue)

         if indexPath.row == 0{
            let headercell = tableView.dequeueReusableCell(withIdentifier:  segue.cellIdentifier) as! HeaderView
            // set profile image here
            headercell.nameLabel.text = segue.label
            return headercell
         }else{
            let cell = tableView.dequeueReusableCell(withIdentifier:segue.cellIdentifier)
            cell?.textLabel?.text = segue.label
            return cell!
        }
        
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = super.tableView(tableView, heightForRowAt: indexPath)
        if indexPath.row == 0{
            return height
        }else{
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segue = segues[indexPath.row]
        SideMenuManager.menuLeftNavigationController?.performSegue(withIdentifier: segue.destinationId, sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segues.count
    }
}
