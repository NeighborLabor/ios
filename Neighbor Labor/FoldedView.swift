//
//  FoldedView.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/17/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import  UIKit
import FoldingCell


class FoldedView: RotatedView{
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var applicantLabel: UILabel!
    
    
    
    class func instanceFromNib() -> FoldedView {
        let cell = UINib(nibName: "FoldedView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! FoldedView
        
        cell.backgroundColor = .white
    
        return cell
    }
    
    
    func update(list: Listing){
        let compensation = "$\(Int(list.compensation))"
        let (date, time) = list.createdAt!.date_time_tup()
        let location = list.address
        let title = list.title
        let applicants = list.applicants.count
        let time_required = list.duration
        
        priceLabel.text = compensation
        dateLabel.text  = date
        timeLabel.text = time
        
        titleLabel.text = title
        locationLabel.text = location
        durationLabel.text = String(time_required)
        applicantLabel.text = String(applicants)
        ownerLabel.text = "Rixing"
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
