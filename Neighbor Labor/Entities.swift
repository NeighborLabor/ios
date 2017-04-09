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
    @NSManaged var geopoint: PFGeoPoint
    @NSManaged var address: String
    @NSManaged var startTime: NSDate
    @NSManaged var duration: Int
     @NSManaged var applicants : PFRelation<PFUser>
    @NSManaged var active: Bool
    @NSManaged var compensation: Double
    @NSManaged var worker: PFUser
    
    static func parseClassName() -> String {
        return "Listing"
    }
    
    var applied = false
    
}

class Review: PFObject, PFSubclassing{
    @NSManaged var user: PFRelation<PFUser>
    @NSManaged var rating: Int
    @NSManaged var descr: String

    static func parseClassName() -> String {
        return "Review"
    }
}


class Thread : PFObject, PFSubclassing {
    @NSManaged var participants: PFRelation<PFUser>
    static func parseClassName() -> String {
        return "Thread"
    }
}


class Message: PFObject, PFSubclassing {
    @NSManaged var threadId: String
    @NSManaged var body: String
    @NSManaged var userId: String
    static func parseClassName() -> String {
        return "Message"
    }
}
