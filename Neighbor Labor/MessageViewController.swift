//
//  MessageViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 4/10/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

 

import UIKit
import Font_Awesome_Swift
import ESPullToRefresh


class MessageViewController: BaseTableViewController {
    
    var threads = [Thread]()
    
    let currentUser = AuthManager.currentUser()!
    var names  = [String]()
    var name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEmptyTable()
        setUpPullToQuery()
        self.tableView.es_startPullToRefresh()
        self.tableView.register( UINib(nibName: "InnerTableCell", bundle: nil), forCellReuseIdentifier: "innercell")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func setUpEmptyTable() {
        self.image = UIImage.init(icon: .FAEnvelopeO, size: CGSize(width: 200, height: 200  ))
        self.desText = "No Messages"
        self.navigationItem.title = "Messages"
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetSource = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func setUpPullToQuery() {
        self.tableView.es_addPullToRefresh {
            [weak self] in
            /// Do anything you want...
            /// ...
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            let query = Thread.query()
            // add constraints here
            query?.whereKey("participants", equalTo: self!.currentUser)
            query?.findObjectsInBackground(block: { (threads, error) in
                if let thds = threads {
                    self?.threads = thds as! [Thread]
                    self?.tableView.reloadData()
                    self?.names = Array(repeating: "", count: thds.count)
                    self?.tableView.es_stopPullToRefresh()
                }
            })
            print("Pull to Refresh")
            self?.tableView.es_stopPullToRefresh(ignoreDate: true)
            /// Set ignore footer or not
            self?.tableView.es_stopPullToRefresh(ignoreDate: true, ignoreFooter: false)
        }
        
    }
}



extension MessageViewController{
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "innercell") as! InnerTableCell
        let thread = self.threads[indexPath.row]
       
        
        thread.participants.query().findObjectsInBackground { (objects, error) in
            
            guard let users = objects else {
                return
            }
            
            var nameoff = ""
            for u in users {
                if u != self.currentUser {
                    let name = (u["name"] as? String)
                    nameoff = name!
                    cell.titleLabel.text = name
                    cell.detailLabel.text = u.updatedAt?.toStringWithRelativeTime()
                    cell.iconLabel.text = name?.initial
                }
                self.names[indexPath.row] = nameoff

            }
            
        }
        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.name = names[indexPath.row]
        self.performSegue(withIdentifier: "to_detailmessage", sender: threads[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}


// MARK: Segue

extension MessageViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: MessageDetailViewController.self) {
            
            let detailMessVC = segue.destination as! MessageDetailViewController
            detailMessVC.thread = sender as! Thread
            detailMessVC.navigationItem.title = self.name
        }
        
        
    }
}











