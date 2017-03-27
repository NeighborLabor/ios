//
//  ExpandedCell.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/17/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit


class ExpandedView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        
    }
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        
        
        
    }
    
    
    class func instanceFromNib() -> ExpandedView {
        let cell = UINib(nibName: "ExpandedView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! ExpandedView
        cell.backgroundColor = .white
        return cell
    }
}

