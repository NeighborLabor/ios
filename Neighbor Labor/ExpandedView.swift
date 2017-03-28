//
//  ExpandedCell.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/17/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import UIKit
import MapKit

class ExpandedView: UIView{
    
    
 
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
    
    
    class func instanceFromNib() -> ExpandedView {
        let cell = UINib(nibName: "ExpandedView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! ExpandedView
        cell.backgroundColor = .white
        return cell
    }
}




extension ExpandedView {
    
    
    
    
}

