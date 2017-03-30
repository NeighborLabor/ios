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
    
    
    @IBOutlet weak var cosmosView: CosmosView!
    weak var currentUser : PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.navigationBar.tintColor = .white
        
        
        // this shou
        currentUser = AuthManager.currentUser()

        mapDatatoComponents()
    
        
        
     }

}

extension ProfileViewController{
    
    func mapDatatoComponents(){
        
        guard let user = currentUser else {
            print("ProfileViewController: ----> user == nil")
            return
        }
//        // user exists
//        print(user)
//        
//        // profile name label
//        nameLabel.text = user.object(forKey: "name") as? String
//        
//        // fetch profile image from parse
//        FetchManager.getProfileImage(user: user, completion: { (image) in
//            self.profileImageVIew.image = image
//        })
//        
//        // fetch rating
        
        
        
    }
    
    
}
