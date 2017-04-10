    //
//  MessageViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/21/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import ESPullToRefresh


class MessageViewController: BaseTableViewController {

    var threads = [Thread]()
    
    let currentUser = AuthManager.currentUser()!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEmptyTable()
        setUpPullToQuery()
     }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.es_startPullToRefresh()
    }

    func setUpEmptyTable() {
        self.image = UIImage.init(icon: .FAEnvelopeO, size: CGSize(width: 200, height: 200  ))
        self.desText = "No Messages"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagecell")
        let thread = self.threads[indexPath.row]
        cell?.textLabel?.text = "Thread"
        return cell!
    }
}





