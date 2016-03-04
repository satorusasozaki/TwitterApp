//
//  User.swift
//  TwitterApp
//
//  Created by Satoru Sasozaki on 3/4/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

// How to create a model class to deserialize
// 1. Create variables as containers for each component
// 2. Break the big object like dictionary into the containers

class User: NSObject {
    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var tagline: NSString?
    
    init(dictionary: NSDictionary) {
        // Deserialization
        // It breaks something like dictionary into each component
        name = dictionary["name"] as? String
        screenname = dictionary["name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        // If there is profileUrlString (not nil)
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
}
