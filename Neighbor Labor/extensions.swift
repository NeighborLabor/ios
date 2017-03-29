//
//  extensions.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/16/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import AFDateHelper




extension Date{

    func date_time_tup() -> (String, String){
        let date = self.compare(.isToday) ? "Today" : self.toString(style: .shortMonth).appending(self.toString(format: .custom(" h")))
        let time = self.toString(format: .custom("h:mm a"))
        return (date, time )
    }
    
    func relativeTimeDescription() -> String{
         if self.compare(.isToday){
            return self.toString(format: .custom("h:mm a"))
         }else{
            return self.toString(style: .shortMonth).appending(self.toString(format: .custom(" h")))
        }
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
