//
//  ViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/24/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import Parse
import ChameleonFramework
import Font_Awesome_Swift


class ListViewController: BaseViewController{

    // information for folding cells
    
    var isUser = false
//    
    
    // cell data
    let listingManager = ListingManager()
    var listings = [Listing]()
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addListingButton: UIBarButtonItem!
    var currentLocation : PFGeoPoint? {
        return LocationManager.currentLocation
    }
    
    @IBAction func createListAction(_ sender: Any) {
        if (currentLocation != nil) {
            if isUser {
                self.performSegue(withIdentifier: "listSegue", sender: self)
            }else{
                self.performSegue(withIdentifier: "authSegue", sender: self)
                
            }
        }else{
            self.showAlert(title: "Error", message: "Location no found, try again later")
            getRequiredPermission()

        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeOutlets()
        getRequiredPermission()
        createSearchBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let icon_size : CGFloat = 25
        menuButton.setFAIcon(icon: .FABars, iconSize: icon_size)
        if let _ = AuthManager.currentUser() {
            addListingButton.setFAIcon(icon: .FAPencil, iconSize: icon_size)
            isUser = true
        }else{
            addListingButton.setFAIcon(icon: .FALock, iconSize: icon_size)
            isUser = false
        }
    
    }
    
    func getRequiredPermission(){
            LocationManager.startLocationUpdate { (err) in
                guard let error = err else {
                    // no error
                    self.populateTable()
                    return
                }
                // No Permission Error
                print(error.localizedDescription)
                self.showAlert(title: "Location Require", message: "Please allow location access in Setting")
             }
    
    }
   
    
    

}


// Customaization
extension ListViewController{
    
    // ICons
    func customizeOutlets() {
 
        
        self.tableView.register( UINib(nibName: "RWFoldingCell", bundle: Bundle.main), forCellReuseIdentifier: "RWFoldingCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
     }

}






// MARK: Table
extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func populateTable(){
         Listing.query()?.findObjectsInBackground(block: { (results, error) in
            guard let error = error else{
                
                self.listings = results as! [Listing]
 
                 self.tableView.reloadData()
                return
            }
            self.showAlert(title: "Error", message: error.localizedDescription)
        })
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = self.listings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RWFoldingCell") as! RWFoldingCell
    
         cell.update(list: listing)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listing = self.listings[indexPath.row]
        self.performSegue(withIdentifier: "to_detail", sender: listing)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
  
}



// Sgues


extension ListViewController {
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "to_detail" {
            let list = sender as! Listing
            let detailVC = segue.destination as! DetailListingViewController
            detailVC.listing = list
        }
    }
}



// Search
extension ListViewController : UISearchBarDelegate{
    
    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.delegate = self
     }

}









