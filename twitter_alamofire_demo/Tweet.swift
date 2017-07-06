//
//  Tweet.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class Tweet {
    
    // MARK: Properties
    var id: Int64 // For favoriting, retweeting & replying
    var text: String // Text content of tweet
    var favoriteCount: Int? // Update favorite count label
    var favorited: Bool? // Configure favorite button
    var retweetCount: Int // Update favorite count label
    var retweeted: Bool // Configure retweet button
    var user: User // Contains name, screenname, etc. of tweet author
    var createdAtString: String // Display date
    
    // MARK: - Create initializer with dictionary
    init(dictionary: [String: Any]) {
        id = dictionary["id"] as! Int64
        text = dictionary["text"] as! String
        favoriteCount = dictionary["favorite_count"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweetCount = dictionary["retweet_count"] as! Int
        retweeted = dictionary["retweeted"] as! Bool
        
        let user = dictionary["user"] as! [String: Any]
        self.user = User(dictionary: user)
        
        let createdAtOriginalString = dictionary["created_at"] as! String
        let formatter = DateFormatter()
        // Configure the input format to parse the date string
        formatter.dateFormat = "E MMM d HH:mm:ss Z y"
        // Convert String to Date
        let date = formatter.date(from: createdAtOriginalString)!
        
        // Convert Date to String
        createdAtString = date.getElapsedInterval()
        
        
    }
    static func tweets(with array: [[String: Any]]) -> [Tweet] {
        return array.flatMap({ (dictionary) -> Tweet in
            Tweet(dictionary: dictionary)
        })
    }
}

// Date since
// =============
extension Date {
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.day, .hour, .minute], from: self, to: Date())
        
        let formatter = DateFormatter()
        // Configure output format
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        if let day = interval.day, day > 0 {
            return "\(day)d"
        } else if let hour = interval.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = interval.minute, minute > 0 {
            return "\(minute)m"
        } else if let second = interval.second, second > 0 {
            return "\(second)s"
        } else {
            return formatter.string(from: self)
        }
    }
}



