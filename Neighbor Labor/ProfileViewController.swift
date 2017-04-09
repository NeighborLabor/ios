//
//  ProfileViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/21/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import  DZNEmptyDataSet
import Parse
import Cosmos

class ProfileViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageVIew: UIImageView!
    var currentUser: PFUser!
    
    @IBOutlet weak var cosmosView: CosmosView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"

        currentUser = AuthManager.currentUser()!
        
        nameLabel.text = (currentUser["name"] as? String)
        
 
        
     }

}

extension ProfileViewController{
    
 
    
    
}
