//
//  FetchManager.swift
//  Neighbor Labor
//
//  Created by Rixing on 3/25/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import Parse

class FetchManager : NSObject {
    
 


}
//
//    private func getListingWith(_ predicate: NSPredicate?, completion: @escaping ([PFObject]?, Error?) -> Void ){
//        let query = Listing.query(with: predicate)
//        query?.findObjectsInBackground(block: { (objects, error) in
//            completion(objects, error)
//        })
//    }



//MARK: Fetch for User
extension FetchManager{
 
    
    // get the listings of a user
    class func getListingOfUser(user: PFUser, completion: @escaping ([PFObject]?, Error?) -> Void){
        let query = Listing.query()?.whereKey("createdBy", equalTo: user)
        query?.findObjectsInBackground(block: { (objs, error) in
            completion(objs, error)
        })
    }
    
    // get image of user
    class func getProfileImage(user: PFUser, completion: @escaping (UIImage) -> Void){
        let image = UIImage(named: "placeholder")!
        let imageData =  user.object(forKey: "profilePic")
    
        if imageData == nil {
            completion(image)
        }else{
            completion(image)
        }
    }
}







//MARK: Fetch for Review
extension FetchManager{
    
 
}





