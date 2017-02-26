//
//  PFUser.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/17/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import Parse


class Listing: PFObject, PFSubclassing{
    
    @NSManaged var createdBy: PFUser
    @NSManaged var title: String
    @NSManaged var descr: String
    @NSManaged var geopoint: PFGeoPoint?
    @NSManaged var address: String
    @NSManaged var startTime: NSDate?
    @NSManaged var duration: Int
    @NSManaged var photos : [PFFile]
    @NSManaged var applicants : [PFUser]
    @NSManaged var active: Bool
    @NSManaged var compensation: Double
    @NSManaged var worker: PFUser?
    
    static func parseClassName() -> String {
        return "Listing"
    }
    
}

class Review: PFObject, PFSubclassing{
    @NSManaged var createdBy: PFUser
    @NSManaged var rating: Int
    @NSManaged var descr: String
    @NSManaged var reviewer: PFUser
    @NSManaged var listing: [Listing]
    
    static func parseClassName() -> String {
        return "Review"
    }
}


