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





class FoldedView: RotatedView{
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    class func instanceFromNib() -> RotatedView {
        return UINib(nibName: "FoldedView.xib", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RotatedView
    }
    
}

class ExpandedView: UIView{
    
    
    
}









class RWFoldingCell: FoldingCell{
    
    static let KCloseHeight: CGFloat = 150

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        itemCount = 3

        containerView = createContainerView()
        foregroundView = createForegroundView()
        // super class method configure views
        commonInit()

    }
    
    
    override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
        // durations count equal it itemCount
        let durations = [0.2, 0.15, 0.15] // timing animation for each view
        return durations[itemIndex]
    }

    
    func createForegroundView() -> RotatedView {
        let FV = FoldedView.instanceFromNib
        let foregroundView = FV()
        foregroundView.backgroundColor = UIColor.orange
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
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = UIColor.green
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        print(itemCount)
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
    
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
}










