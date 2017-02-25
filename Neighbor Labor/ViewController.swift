//
//  ViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/24/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit

class ViewController: BaseViewController{
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func logoutAction(_ sender: Any) {
        authInteractor.signOut { (success, error) in
            if success{
                self.viewDidAppear(true)
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = AuthInteractor.currentUser(){
            self.label.text = "User: \(user["name"]!)"
            }else{
            self.performSegue(withIdentifier: "authSegue", sender: nil)
        }
    }

}
