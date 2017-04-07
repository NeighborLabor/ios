//
//  AuthInteractor.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/8/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import Parse


/* Interactor protocols
 *
 */

typealias ErrorResultBlock = ((NSError?)  -> Void)

/*
 *
 *  SignUpInteractor   */
internal protocol SignUpInteractor{
    func signUpWith( email: String, password: String, name: String, phone: String, ppic: NSData?, bio: String, completion:  @escaping ErrorResultBlock)
}
/*
 *
 *  SignUpInteractor   */
internal protocol LoginInteractor{
    func loginWith(email: String, password: String, completion: @escaping ErrorResultBlock)
}
/*
 *
 *  SignOutInteractor   */
internal protocol SignOutInteractor{
    func signOut(completion:  @escaping ErrorResultBlock)
}


/* 
 
 AuthInteractor implements all of the above
 */
class AuthManager : SignUpInteractor, LoginInteractor, SignOutInteractor {
    

    
    //Common Interacter
    static func currentUser() -> PFUser? {
        return PFUser.current()
    }
    
    /*
     *
     *  SignUpInteractor   */
    func signUpWith(email: String, password: String, name: String, phone: String, ppic: NSData?, bio: String, completion: @escaping ErrorResultBlock) {
        let user = PFUser()
        user.email = email
        user["phone"] = phone
        user.username = email
        user.password = password
        user["bio"] = bio
        user["name"] = name
        //  user["profilePic"] = ppic
        user.signUpInBackground { (success, error) in
                completion(error as NSError?)
        }

    }
    /*
     *
     *  LoginInteractor   */
    func loginWith(email: String, password: String, completion: @escaping ErrorResultBlock) {
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            completion(error as NSError?)
        }
    }
    
    /*
     *
     *  SignOutInteractor   */
    func signOut(completion: @escaping ErrorResultBlock) {
        PFUser.logOutInBackground(block: { (error) in
            completion(error as NSError?)
        })
    }
    /*
     *
     *  Retain Cycle   */
    deinit {
        print("AuthInteractor to be released soon")
    }
    
}

