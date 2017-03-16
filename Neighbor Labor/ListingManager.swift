//
//  JobInteractor.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/26/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import Parse






internal protocol ListingInteractor {
 
    func createAListing(title: String, desc: String, address: String, startTime: NSDate, duration: Int, photo: NSData?, compensation: Double, completion: @escaping ErrorResultBlock)
    
}



class ListingManager : ListingInteractor{
    
    func createAListing(title: String, desc: String, address: String, startTime: NSDate, duration: Int, photo: NSData?, compensation: Double, completion: @escaping ErrorResultBlock){
        
        guard let user = AuthManager.currentUser() else {
            // Handle Error
            let error = NLError.noAuthError
            completion(error as NSError?)
            //Break out
            return
        }
        
        let listing = Listing()
        listing.createdBy = user
        listing.title = title
        listing.descr = desc
        listing.address = address
        listing.startTime = startTime
        listing.duration = duration
        listing.compensation = compensation
        listing.active = false
     //   listing.worker = nil
        
        
        // MARK: TODO ADDRESS STRING TO PFGEOPOINT
         LocationManager.requestCurrentLocation(adress: address, completion: { (point, error) in
            guard let err = error else{
            // no Error
                listing.geopoint = point!
                listing.saveInBackground { (sucess, error) in
                        completion(error as NSError?)
                }
                return
            }
            // if Error
            completion(err as NSError?)
        })
        
    }
    
    deinit {
    print("listingManager : deinits")
    }

    
}
