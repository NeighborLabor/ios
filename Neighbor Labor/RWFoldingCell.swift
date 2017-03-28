//
//  RWFoldingTableView.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/28/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import UIKit
import FoldingCell
import EasyPeasy
import ChameleonFramework



class RWFoldingCell: FoldingCell{
    
    static let KCloseHeight: CGFloat = 150

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .flatWhite
        self.backViewColor = .flatGray
        self.itemCount = 3

        self.containerView = createContainerView()
        self.foregroundView = createForegroundView()
        // super class method configure views
        self.foregroundView.layer.cornerRadius = 5
        self.foregroundView.layer.masksToBounds = true
         commonInit()
    }
    
    
    override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
        // durations count equal it itemCount
        let durations = [0.2, 0.15, 0.2] // timing animation for each view
        return durations[itemIndex]
    }

    
    func createForegroundView() -> RotatedView {
         
        
        let foregroundView = FoldedView.instanceFromNib()
        foregroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(foregroundView)
        // add constraints
        foregroundView <- [
            Height(RWFoldingCell.KCloseHeight ),
            Left(8),
            Right(8),
        ]
        
        // add identifier
        let top = (foregroundView <- [Top(8)]).first
        top?.identifier = "ForegroundViewTop"
        self.foregroundViewTop = top
        foregroundView.layoutIfNeeded()
        return foregroundView
        
    }
    
    func createContainerView() -> UIView {
        let containerView = ExpandedView.instanceFromNib()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
         // add constraints
        containerView <- [
            Height(CGFloat(RWFoldingCell.KCloseHeight * CGFloat(itemCount))),
            Left(8),
            Right(8),
            
        ]
        
        // add identifier
        let top = (containerView <- [Top(8)]).first
        top?.identifier = "ContainerViewTop"
        self.containerViewTop = top
        containerView.layoutIfNeeded()

        return containerView
    }
    
    func update(list: Listing){
        (self.foregroundView as! FoldedView).update(list: list)
    }
    
    
 
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
}









