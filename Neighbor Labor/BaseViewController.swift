//
//  BaseViewController.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/24/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Font_Awesome_Swift
import ChameleonFramework
import BonMot
import SideMenu

class BaseViewController: UIViewController {}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showConfirmAlert(title: String, message: String, completion: (() -> Void)? ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
         if completion == nil {
            let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let defaultAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { alert in
            completion!()
        }
        alertController.addAction(defaultAction)
        alertController.addAction(deleteAction)
       
        self.present(alertController, animated: true, completion: nil)
    }
}



class BaseTableViewController: UITableViewController {
    var image = UIImage.init(icon: FAType.FAAnchor, size: CGSize(width: 150, height: 150), textColor: UIColor.flatGrayDark, backgroundColor: .clear)
    var titleText = ""
    var desText = ""
    var buttonText = ""
     var color = UIColor.flatSkyBlue
    var segueId : String?
    
}

extension BaseTableViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = .flatWhite
     }
    
    
    
    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.flatWhite
    }
    
    
    public func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return self.image
    }
    
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
    
        return NSAttributedString(string: titleText)
    }
    
    public func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let style = StringStyle(
            .font(UIFont(name: "AmericanTypewriter", size: 17)!)
        )
        
        let attributedString = desText.styled(with: style)
        return attributedString
    }
    
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let colorState = (state == .normal) ? self.color : self.color.darken(byPercentage: 80.0)
        
        let style = StringStyle(
            .font(UIFont(name: "Helvetica Neue", size: 20)!),
            .lineHeightMultiple(1.2),
            .color(colorState!)
        )
        return buttonText.styled(with: style)
    }
    

    

}


