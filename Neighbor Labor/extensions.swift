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
}

 
