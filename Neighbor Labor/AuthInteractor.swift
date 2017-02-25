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
internal protocol SignUpInteractor{
    func signUpWith( email: String, password: String, name: String, phone: String, ppic: PFFile?, skillset: [String], bio: String, completion:  @escaping PFBooleanResultBlock)
}

internal protocol LoginInteractor{
    func loginWith(email: String, password: String, completion: @escaping PFBooleanResultBlock)
}

internal protocol SignOutInteractor{
    func signOut(completion:  @escaping PFBooleanResultBlock)
}


/* Implementing the Protocols
 
 
 
 
    //MARK:REFACTOR Needed -- change (sucess, error?) to (error?)
 
 
 
 
 
 
 
 */
class AuthInteractor : SignUpInteractor, LoginInteractor, SignOutInteractor {
    
    
    //Common Interacter Method
    static func currentUser() -> PFUser? {
        return PFUser.current()
    }
    
    
    func signUpWith(email: String, password: String, name: String, phone: String, ppic: PFFile?, skillset: [String] ,  bio: String, completion: @escaping (Bool, Error?) -> Void) {
        let user = PFUser()
        user.email = email
        user["phone"] = phone
        user.username = email
        user.password = password
        user["bio"] = bio
        user["name"] = name
        //MARK: TODO
//        user["listings"] = [Listing]()
//        user["review"] = [Review]()
//        user["skillset"] = [String]()
//        user["profilePic"] = ppic
        
        user.signUpInBackground { (success, error) in
            completion(success, error)
        }
    }
    
    func loginWith(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            completion(user != nil, error)
        }
    }
    
    func signOut(completion: @escaping (Bool, Error?) -> Void) {
            PFUser.logOutInBackground(block: { (error) in
                if let _ = AuthInteractor.currentUser(){
                        completion(false, error)
                }else{
                    completion(true, error)
                }
            })
      
    
    }
    
}

