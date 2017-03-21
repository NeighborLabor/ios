//
//  BaseViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/24/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
     }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
                print("You pressed OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    
    
    
}
