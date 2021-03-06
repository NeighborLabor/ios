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
        
        let user = AuthManager.currentUser()!
        
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



extension ListingManager {


    func searchWords(text: String, completion: @escaping ( ([PFObject]?, Error?) -> Void)) {
        
        
        
        let titleQ = Listing.query()?.whereKey("title", matchesRegex: text, modifiers: "i")
        let descQ = Listing.query()?.whereKey("descr", matchesRegex: text, modifiers: "i")
        let addrQ = Listing.query()?.whereKey("address",matchesRegex: text, modifiers: "i")
        let orQ = PFQuery.orQuery(withSubqueries: [titleQ!, descQ!, addrQ!])
        
        orQ.findObjectsInBackground { (objs, error) in
            completion(objs, error)
        }
    }
    
    
    func searchListRequest(query: PFQuery<PFObject>?, completion: @escaping ( ([PFObject]?, (Error?)) -> Void)){

        var listQuery = Listing.query()
        if query != nil {
            print("Filter Query recieved")
            listQuery = query
        }
        
        listQuery?.findObjectsInBackground(block: { (results, error) in
            completion(results, error)
        })
    }
    
    
}









