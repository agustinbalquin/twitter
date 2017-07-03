//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var default_profile_image: Bool
    var followers_count: Int?
    var name: String = ""
    var screenName: String = ""
    var description: String = ""
    var profileImageURL: URL?
    static var current: User?
    
    init(dictionary: [String: Any]) {
        name = dictionary["name"] as? String ?? ""
        screenName = dictionary["screen_name"] as? String ?? ""
        description = dictionary["description"] as? String ?? ""
        followers_count = dictionary["followers_count"] as? Int
        default_profile_image = dictionary["default_profile_image"] as! Bool
        if !default_profile_image {
            if let urlString = dictionary["profile_image_url_https"] as? String {
                profileImageURL = URL(string: urlString)
            }
        }
    }
    
}
