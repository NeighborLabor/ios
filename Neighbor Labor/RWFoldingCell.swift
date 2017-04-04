//
//  FoldedView.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/17/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import  UIKit
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
        let compensation = "\(Int(list.compensation))"
        let location = list.descr
        let title = list.title
        
        list.applicants.query().countObjectsInBackground { (count, error) in
            self.applicantLabel.text = String(count)
        }
        
        let time_required = list.duration
        let distance = CGFloat(list.geopoint.distanceInMiles(to: LocationManager.currentLocation))
        
        
        priceLabel.setFAText(prefixText: "", icon: FAType.FADollar, postfixText: "\(compensation)", size: nil)
        timeLabel.text =  (list.startTime as Date).format_month
        
        titleLabel.text = title
        locationLabel.text = location
        durationLabel.text = String(time_required) + " mins"
        
        ownerLabel.text = distance.string1 + " miles"
        
    }
    
    
}


class InnerTableCell : UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Over reuse identifier")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    override func draw(_ rect: CGRect) {
        self.iconLabel.layer.cornerRadius = iconLabel.frame.height * 0.5
        self.iconLabel.layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}




