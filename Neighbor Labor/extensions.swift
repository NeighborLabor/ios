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
 

