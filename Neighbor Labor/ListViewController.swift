//
//  ViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/24/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import Parse


class ListViewController: AuthViewController{

    
    let listingManager = ListingManager()
    var listings = [Listing]()
    
    @IBOutlet weak var tableView: UITableView!
    
    // temporary
    @IBAction func menuToggleAction(_ sender: Any) {
        AuthManager().signOut { (err) in
            
        }
    }

    @IBAction func createListAction(_ sender: Any) {
        
        guard let _ = AuthManager.currentUser() else {
            
            self.performSegue(withIdentifier: "authSegue", sender: self)
            print("User not loaded in")
            return
        }
        self.performSegue(withIdentifier: "listSegue", sender: self)
    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
        Listing.query()?.findObjectsInBackground(block: { (results, error) in
            guard let error = error else{
                
                self.listings = results as! [Listing]
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                return
            }
            print("Problem occurred : \(error.localizedDescription)")

            
        })
        
    }
    
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "listcell")!
        let listing = self.listings[indexPath.row]
        
        cell.textLabel?.text = listing.title
        cell.detailTextLabel?.text = listing.descr
        
         cell.imageView?.image = UIImage(named: "placeholder")
        
        print(listing.title)
    
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
}










