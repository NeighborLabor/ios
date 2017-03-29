 //  MyListViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/21/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
 import DZNEmptyDataSet

class MyListViewController: BaseTableViewController{

    var myListings = [Listing]()
    
     override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = myListings[indexPath.row].title
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myListings.count
    }
    
    
}
