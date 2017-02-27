//
//  ViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/24/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit

class ListViewController: AuthViewController{

    
    let listingManager = ListingManager()
    
    @IBAction func createListingAction(_ sender: Any) {
        

    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = AuthManager.currentUser(){
            listingManager.createAListing(title: "Dog Walker", desc: "I need someone to walk my dog", address: "555 hiuntington Ave, Boston MA", startTime: NSDate().addingTimeInterval(10000.0), duration: 60, photo: nil, compensation: 20) { (error) in
                
                guard let error = error else{
                    print("Listing uploaded")
                    return
                }
                
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            
        }else{
            self.performSegue(withIdentifier: "authSegue", sender: nil)
        }
        
    }
    
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
}










