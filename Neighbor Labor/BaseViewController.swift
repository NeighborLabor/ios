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
        {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}



class BaseTableViewController: UITableViewController {}

extension UITableViewController: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {

    var image : UIImage {
        get {
            return UIImage.init(icon: FAType.FAAnchor, size: CGSize(width: 150, height: 150), textColor: UIColor.flatGrayDark, backgroundColor: .clear)
        }set (newValue){
            self.image = newValue
        }
    }
    
    var titleText: String {
        get {
            return ""
        }set (newValue){
            self.titleText = newValue
        }
    }
    
    var desText : String {
        get {
            return ""
        }set (newValue){
            self.desText = newValue
        }
    }
    var buttonText: String {
        get {
            return ""
        }set (newValue){
            self.buttonText = newValue
        }
    }
    
    var segueId : String? {
        get {
            return nil
        }set (newValue){
            self.segueId = newValue
        }
    }
    
    var color : UIColor {
        get {
            return UIColor.flatSkyBlue
        }set (newValue){
            self.color = newValue
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.tableFooterView = UIView()
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
    

    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if let seuge = self.segueId {
            SideMenuManager.menuLeftNavigationController?.performSegue(withIdentifier: seuge, sender: nil)
        }
    }
    
}




extension ListViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    
    var image : UIImage {
        return UIImage.init(icon: FAType.FAAnchor, size: CGSize(width: 150, height: 150), textColor: UIColor.flatGrayDark, backgroundColor: .clear)
    }
    
    var titleText: String {
        get {
            return ""
        }set (newValue){
            self.titleText = newValue
        }
    }
    
    var desText : String {
        get {
            return ""
        }set (newValue){
            self.desText = newValue
        }
    }
    var buttonText: String {
        get {
            return ""
        }set (newValue){
            self.buttonText = newValue
        }
    }
    
    var segueId : String? {
        get {
            return nil
        }set (newValue){
            self.segueId = newValue
        }
    }
    
    var color : UIColor {
        get {
            return UIColor.flatSkyBlue
        }set (newValue){
            self.color = newValue
        }
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
            .font(UIFont(name: "AmericanTypewriter", size: 17)!),
            .color(.flatWhite)
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
    
    
    public func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if let seuge = self.segueId {
            SideMenuManager.menuLeftNavigationController?.performSegue(withIdentifier: seuge, sender: nil)
        }
    }
    
    
    
}
