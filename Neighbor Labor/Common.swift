//
//  Common.swift
//  Neighbor Labor
//
//  Created by Rixing on 2/26/17.
//  Copyright © 2017 Rixing. All rights reserved.
//

import Foundation
import Parse


/**
    Error Types
 
 */
public enum NLError: Error{
    // No user present Error
    case noAuthError
}

extension NLError: LocalizedError{
    public var errorDescription: String? {
        switch self {
        case .noAuthError:
            return NSLocalizedString("Login Required", comment: "No Auth Data")
        }
    }
}



/**
    Common Interactor
 */

class LocationManager {

    
    static func requestCurrentLocation(adress: String?, completion: @escaping  (PFGeoPoint?, Error?) -> Void){
        
        PFGeoPoint.geoPointForCurrentLocation { (point, error) in
            completion(point, error as Error?)
        }
            
    }
}
