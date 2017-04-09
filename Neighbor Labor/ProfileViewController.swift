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
import Font_Awesome_Swift
class ProfileViewController: BaseTableViewController {
 
    var user: PFUser?
     @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var emailLabel: TopAlignedLabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var reviews = [Review]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image = UIImage.init(icon: FAType.FAAnchor, size: CGSize(width: 150, height: 150), textColor: .clear, backgroundColor: .clear)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2.0
        self.profileImage.layer.masksToBounds = true
        self.desText = "No review yet"
        if self.user == nil {
            self.user = AuthManager.currentUser()
        }
        
        let user = self.user!
        self.nameLabel.text = user["name"] as? String
        self.profileImage.setFAIconWithName(icon: .FAUser, textColor: .flatWatermelon)
        self.emailLabel.text = user.email
        self.bioLabel.text = user["bio"] as? String
    
        
        let query = Review.query()
        query?.whereKey("user", equalTo: user)
        query?.findObjectsInBackground(block: { (reviews, error) in
            guard let err = error else {
                
                self.reviews = reviews as! [Review]
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                return
            }
            self.showAlert(title: "Error", message: err.localizedDescription)
        })
        
    }
    
    
    
}

extension ProfileViewController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewcell")! as! ReivewCell
        let review = self.reviews[indexPath.row]
        cell.reviewText.text = review.descr
        cell.ratingView.rating = Double(review.rating)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
    
 
}







class ReivewCell: UITableViewCell {
    
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var ratingView: CosmosView!
}
