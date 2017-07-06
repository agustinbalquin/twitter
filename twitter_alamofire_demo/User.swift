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
    var dictionary: [String: Any]?
    private static var _current: User? 
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
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
