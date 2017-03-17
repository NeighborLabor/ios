//
//  ViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/24/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import Parse
import FoldingCell
import SwiftIconFont
class ListViewController: BaseViewController{

    
    let listingManager = ListingManager()
    var listings = [Listing]()
    @IBOutlet weak var tableView: UITableView!

    @IBAction func createListAction(_ sender: Any) {
        guard let _ = AuthManager.currentUser() else {
            self.performSegue(withIdentifier: "authSegue", sender: self)
            print("User not logged in")
            return
        }
        self.performSegue(withIdentifier: "listSegue", sender: self)
    
    }
    
    
    
    var itemCount = 3
    var closeHeight: CGFloat = RWFoldingCell.KCloseHeight + 8 //
    var openHeight: CGFloat!
    var itemHeight: [CGFloat]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.icon(from: .Octicon, code: "three-bars", ofSize: 40)
        
        openHeight  = RWFoldingCell.KCloseHeight * CGFloat(itemCount) + 8
        tableView.register(RWFoldingCell.self, forCellReuseIdentifier: "RWFoldingCell")
        Listing.query()?.findObjectsInBackground(block: { (results, error) in
            guard let error = error else{
                
                self.listings = results as! [Listing]
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.itemHeight =  [CGFloat](repeating: self.closeHeight, count: self.listings.count)
                self.tableView.reloadData()
                return
            }
            print("Problem occurred : \(error.localizedDescription)")
        })
    }
}


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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemHeight.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RWFoldingCell
//
//        
        var duration = 0.0
        if itemHeight[indexPath.row] == closeHeight { // open cell
            itemHeight[indexPath.row] = openHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            itemHeight[indexPath.row] = closeHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.5
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
}







