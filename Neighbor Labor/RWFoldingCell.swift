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


class FoldedView: RotatedView{
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        
        let compensation = "20";
        let date =  "Sep 10"
        let time = "05:20"
        
        let leftSegmentView = UIView()
        self.addSubview(leftSegmentView)
        leftSegmentView.backgroundColor = .white
             leftSegmentView <- [
                             Left(8),
                             Top(0),
                             Width(*0.25).like(self),
                             Bottom(0)
                            ]
    
            let seperator = UIView()
                seperator.backgroundColor = UIColor.flatWhite
                leftSegmentView.addSubview(seperator)
        
                seperator <- [
                    Width(1),
                    Right(1),
                    Top(10),
                    Bottom(10)]
        
        
        let priceLabel = UILabel()
            priceLabel.text = "$\(compensation)"
            leftSegmentView.addSubview(priceLabel)
            priceLabel <-  [
               CenterX(0),
               Top(8),
               Height(*0.5).like(leftSegmentView)
            ]
        
        let dateLabel = UILabel()
        dateLabel.text = date.uppercased()
        dateLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        dateLabel.textColor = .flatGray
        let timeLabel = UILabel()
        timeLabel.text = "\(time) PM"
    
        let stackView = UIStackView(arrangedSubviews: [dateLabel, timeLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        leftSegmentView.addSubview(stackView)
            stackView.alignment = .fill
        stackView <- [
            CenterX(0),
            Top(8).to(priceLabel),
            Bottom(10)
        ]
        
        
    
        let rightSegmentView = UIView()
        rightSegmentView.backgroundColor = .white
        self.addSubview(rightSegmentView)
             rightSegmentView <- [
                Left(0).to(leftSegmentView),
                Top(0),
                Right(0),
                Bottom(0)]
        
    }
    
}

class ExpandedView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}





class RWFoldingCell: FoldingCell{
    
    static let KCloseHeight: CGFloat = 150

    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backViewColor = ComplementaryFlatColorOf(.flatWhite)
        
        self.contentView.backgroundColor = .flatWhite

        
        itemCount = 3

        containerView = createContainerView()
        foregroundView = createForegroundView()
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
        let foregroundView = FoldedView(frame:.zero)
        foregroundView.backgroundColor = .purple
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
        let containerView = ExpandedView()
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
    
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")}
}










