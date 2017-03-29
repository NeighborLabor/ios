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
import Font_Awesome_Swift
import Parse

class RWFoldingCell: UITableViewCell{
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var applicantLabel: UILabel!
    


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Over reuse identifier")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
 
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        let iconSize : CGFloat = 15
        self.dateLabel.setFAIcon(icon: .FACalendar, iconSize: iconSize)
        self.appLabel.setFAIcon(icon: .FAUsers, iconSize: iconSize)
        self.clockLabel.setFAIcon(icon: .FAHourglassHalf
            , iconSize: iconSize)
        self.distanceLabel.setFAIcon(icon: .FARoad, iconSize: iconSize)
    }
    
    func update(list: Listing){
        let compensation = "$\(Int(list.compensation))"
        let location = list.address
        let title = list.title
        let applicants = list.applicants.count
        let time_required = list.duration
        let distance = CGFloat(list.geopoint.distanceInMiles(to: LocationManager.currentLocation))
        
        
        priceLabel.text = compensation
        timeLabel.text =  list.createdAt!.relativeTimeDescription()
        
        titleLabel.text = title
        locationLabel.text = location
        durationLabel.text = String(time_required) + " mins"
        applicantLabel.text = String(applicants)
        ownerLabel.text = distance.string1 + " miles"
        
    }
    
    
}
