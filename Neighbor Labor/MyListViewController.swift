 //  MyListViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/21/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
 import DZNEmptyDataSet

class MyListViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.tableFooterView  = UIView()
      }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
    
        let image =  UIImage(named: "placeholder")
        return image!
        
    }
 
    
    
}
