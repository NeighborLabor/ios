//
//  AuthInteractor.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/8/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import Parse


/* Protocols
 *
 *
 *
 */

typealias ErrorResultBlock = ((NSError?)  -> Void)

internal protocol SignUpInteractor{
    func signUpWith( email: String, password: String, name: String, phone: String, ppic: PFFile?, bio: String, completion:  @escaping ErrorResultBlock)
}

internal protocol LoginInteractor{
    func loginWith(email: String, password: String, completion: @escaping ErrorResultBlock)
}

internal protocol SignOutInteractor{
    func signOut(completion:  @escaping ErrorResultBlock)
}


/* Implementing the Protocols
 
 
 
 
    //MARK:REFACTOR Needed -- change (sucess, error?) to (error?)
 
 
 
 
 
 
 
 */
class AuthInteractor : SignUpInteractor, LoginInteractor, SignOutInteractor {
    
    
    //Common Interacter Method
    static func currentUser() -> PFUser? {
        return PFUser.current()
    }
    
    func signUpWith(email: String, password: String, name: String, phone: String, ppic: PFFile?, bio: String, completion: @escaping ErrorResultBlock) {
                let user = PFUser()
                user.email = email
                user["phone"] = phone
                user.username = email
                user.password = password
                user["bio"] = bio
                user["name"] = name
        //        user["profilePic"] = ppic
        
                user.signUpInBackground { (success, error) in
                     completion(error as NSError?)
                }

    }
    
//    
    func loginWith(email: String, password: String, completion: @escaping ErrorResultBlock) {
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            completion(error as NSError?)
        }
    }
    
    func signOut(completion: @escaping ErrorResultBlock) {
            PFUser.logOutInBackground(block: { (error) in
                completion(error as NSError?)
            })
      
    
    }
    
}

