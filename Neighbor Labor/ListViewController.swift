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
import ESPullToRefresh
import Presentr

class ListViewController: BaseViewController{
    var image = UIImage.init(icon: FAType.FAAnchor, size: CGSize(width: 150, height: 150), textColor: UIColor.flatGrayDark, backgroundColor: .clear)
    var titleText = ""
    var desText = ""
    var buttonText = ""

    // information for folding cells
    
    var isUser = false
//
    let presenter = Presentr(presentationType: .bottomHalf)

    // cell data
    let listingManager = ListingManager()
    var listings = [Listing]()
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addListingButton: UIBarButtonItem!
    
    
    // Toolbar 

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    
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
            LocationManager.startLocationUpdate { [weak self] (err) in
 
                guard let error = err else {
                    // no error
                     return
                }
                // No Permission Error
                print(error.localizedDescription)
                self?.showAlert(title: "Location Require", message: "Please allow location access in Setting")
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
    
        addRefresh()
        self.tableView.es_startPullToRefresh()
     }
    
    func addRefresh() {
        self.tableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            let query = Listing.query()
            
            query?.findObjectsInBackground(block: { [weak self] (results, error) in
                guard let error = error else{
                    
                    self?.listings = results as! [Listing]
                    self?.tableView.reloadData()
                    return
                }
                self?.showAlert(title: "Error", message: error.localizedDescription)
            })
            self?.tableView.es_stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
    }
    
    

}





// MARK: Table
extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    
    
 
    
    
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

extension ListViewController{
    
    
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
         self.searchBar.delegate = self
        let tf = self.searchBar.value(forKey: "searchField") as? UITextField
        tf?.attributedPlaceholder = NSAttributedString(string: "Search", attributes:[NSForegroundColorAttributeName: UIColor.flatWhiteDark])
        tf?.textColor = UIColor.flatWhite
        self.searchButton.setFAIcon(icon: .FASliders, iconSize: 25)
        
     }
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        if self.searchBar.isFirstResponder {
            self.searchBar.resignFirstResponder()
            return
        }
        
        if let controller = storyboard!.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController {
            print("controller exists")
            customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
        }

    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        let listManager = ListingManager()
       
        listManager.searchWords(text: searchText!) { (listings, error) in
            self.searchBar.resignFirstResponder()
            guard let err = error else {
                // Search Success
                self.listings = listings as! [Listing]
                self.tableView.reloadData()

                return
            }
            
            self.showAlert(title: "Error", message: err.localizedDescription)
        }
     }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
       // self.searchBar.setShowsCancelButton(true, animated: false)
        
        UIView.animate(withDuration: 0.2) { 
            self.searchButton.setFAIcon(icon: .FAClose, iconSize: 25)
        }
    
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      //  self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchButton.setFAIcon(icon: .FASliders, iconSize: 25)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()

    }

}









