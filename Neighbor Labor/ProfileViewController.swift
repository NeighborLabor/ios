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
import SCLAlertView


class ProfileViewController: BaseTableViewController {
 
    var user: PFUser?
     @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var emailLabel: TopAlignedLabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var reviews = [Review]()
    var reviewable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOutlets()
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
    
    
    
    func setUpOutlets(){
        self.image = UIImage.init(icon: FAType.FAAnchor, size: CGSize(width: 150, height: 150), textColor: .clear, backgroundColor: .clear)
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2.0
        self.profileImage.layer.masksToBounds = true
        self.desText = "No reviews yet"
        if self.user == nil {
            // Seeing profile from currentUser
            self.user = AuthManager.currentUser()
        }else{
            // Seeing profile from stranger's perspective
            let barButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(sendMessage))
            barButton.setFAIcon(icon: .FAComment  , iconSize: 25)
            self.navigationItem.rightBarButtonItem = barButton
        }
    }
    
    
    func sendMessage() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Your Message")
        alert.addButton("Send") {
//            print("Text value: \(txt.text)")
            let mes = txt.text
            let currentUser = AuthManager.currentUser()!
            let sender = self.user!
            
        
            let query = Thread.query()!
          //  query.whereKey("participants", equalTo: currentUser)
            query.whereKey("participants", equalTo: currentUser)
            query.whereKey("participants", equalTo: sender)

            query.getFirstObjectInBackground(block: { (t, error) in
                var thread: Thread!
                if let ts = t {
                    thread = ts as! Thread
                    print("Already has Thread")
                }else{
                    thread = Thread()
                    thread.relation(forKey: "participants").add(sender)
                    thread.relation(forKey: "participants").add(currentUser)
                    print("No Thread yet")
                }
                
                            thread.saveInBackground(block: { (_, error) in
                                guard let err = error else{
                                    let message = Message()
                                    message.userId = currentUser.objectId!
                                    message.threadId = thread.objectId!
                                    message.body = mes!
                                    
                                    message.saveInBackground(block: { (success, error) in
                                        guard let err = error else {
                                            print("Sent")
                                            return
                                        }
                                        print(err.localizedDescription)
                                    })
                                
                                    return
                                }
                                print(err.localizedDescription)
                            })
            })
        }
        
        alert.showEdit("to: \(user!["name"]!)", subTitle: "")
    
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
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 13)!
        header.backgroundView?.backgroundColor = UIColor.white
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    

 
}







class ReivewCell: UITableViewCell {
    
    @IBOutlet weak var reviewText: UITextView!
    @IBOutlet weak var ratingView: CosmosView!
}
