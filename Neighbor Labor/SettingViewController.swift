//
//  SettingViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/21/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class SettingViewController: BaseViewController {

    @IBOutlet weak var bgImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Setting"

        self.bgImage.image = UIImage.init(icon: .FAAnchor, size: CGSize(width: 100, height: 100), textColor: .flatGrayDark, backgroundColor: .clear)
     }

    @IBAction func logoutAction(_ sender: Any) {
        AuthManager().signOut { (error) in
            guard let err = error else {
                let _ =  self.navigationController?.popViewController(animated: true)
                return
            }
            self.showAlert(title: "Error", message: err.localizedDescription)
        }
    }
 
}
