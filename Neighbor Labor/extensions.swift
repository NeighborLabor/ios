//
//  extensions.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/16/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import AFDateHelper
import Parse



extension Date{

    func date_time_tup() -> (String, String){
        let date = format_month
        let time = format_AM_PM
        return (date, time )
    }
    
    
    var format_AM_PM : String {
         return self.toString(format: .custom("h:mm a"))
    }
    var format_month : String {
        return self.toString(style: .shortMonth).appending(self.toString(format: .custom(" d")))
    }
    
    
    func relativeTimeDescription() -> String{
         if self.compare(.isToday){
            return self.toString(format: .custom("h:mm a"))
         }else{
            return self.toString(style: .shortMonth).appending(self.toString(format: .custom(" d")))
        }
    }
    
    func addMins(m : Int) -> Date{
        return self.adjust(.minute, offset: m)
    }
}


extension CGFloat {
    var string1: String {
        return String(format: "%.1f", self)
    }
    var string2: String {
        return String(format: "%.2f", self)
    }
}


extension String {
    
    var initial: String {
        var str = "R"
        if self.characters.count > 1 {
            str = self[str.startIndex].description
        }
        return str
    }
    
    func toSeconds() -> Date?{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.date(from: self)
        return time
    }
}


extension PFGeoPoint {
    
    var cclocation: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
 
@IBDesignable class TopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            
            
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width, height:  CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSFontAttributeName: font],
                                                                    context: nil).size
            
            super.drawText(in: CGRect(x: 0, y: 0, width: self.frame.width, height: ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}
