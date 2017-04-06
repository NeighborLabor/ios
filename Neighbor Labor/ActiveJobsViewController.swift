//
//  ActiveJobsViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/21/17.
//  Copyright © 2017 Rixing. All rights reserved.
//
import ChameleonFramework
import UIKit
 class ActiveJobsViewController: BaseTableViewController {

    
    var listings = [Listing]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Active Jobs"

        self.tableView.register( UINib(nibName: "InnerTableCell", bundle: nil), forCellReuseIdentifier: "innercell")
        emptySetUp()
        addRefresh()
        self.tableView.es_startPullToRefresh()
     }
    
    func emptySetUp() {
        self.desText = "You have not applied for any work!"
        self.buttonText = "Browse"
    }

    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        let _ =  self.navigationController?.popViewController(animated: true)
    }
    
}


// Table
extension ActiveJobsViewController {
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "innercell") as! InnerTableCell
        let list = listings[indexPath.row]
        let userName = (list.createdBy["name"] as? String)
        cell.iconLabel.text = userName?.initial.uppercased()
        cell.titleLabel.text = list.title
        cell.detailLabel.text = userName
        
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listings.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = listings[indexPath.row]
        list.applied = true
        self.navigationController?.viewControllers[0].performSegue(withIdentifier: "to_detail", sender: list)
    }
    
    func addRefresh() {
        self.tableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            let user = AuthManager.currentUser()!
            
            let query = Listing.query()!
            query.whereKey("applicants", equalTo: user)
            query.includeKey("createdBy")
            query.findObjectsInBackground { (list, error) in
                guard let err = error else {
                    
                    self?.listings = (list as! [Listing])
                    self?.tableView.delegate = self
                    self?.tableView.dataSource = self
                    self?.tableView.reloadData()
                    self?.tableView.es_stopPullToRefresh()
                    return
                }
                self?.showAlert(title: "Error", message: err.localizedDescription)
                
            self?.tableView.es_stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
        }
    
    }
    
    
}
