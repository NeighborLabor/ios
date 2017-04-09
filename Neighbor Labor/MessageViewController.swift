//
//  MessageViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/21/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
class MessageViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Messages"
        self.image = UIImage.init(icon: .FAEnvelopeO, size: CGSize(width: 200, height: 200  ))
        self.desText = "No Messages"
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetSource = self
     }
}



