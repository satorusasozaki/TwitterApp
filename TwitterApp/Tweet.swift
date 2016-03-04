//
//  Tweet.swift
//  TwitterApp
//
//  Created by Satoru Sasozaki on 3/4/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

// How to create a model class to deserialize
// 1. Create variables as containers for each component
// 2. Break the big object like dictionary into the containers

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        // If dictionary["retweet_count"] exists, assign it to retweetCount
        // Otherwise, assign 0 to retweetCount
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        
        // Make NSMutableArray
        // NOTE: tweets = [] will create NSArray not mutable
        var tweets = [Tweet]()
        
        // Iterate through array of dictionary which contains many dictionaries of tweet
        for dictionary in dictionaries {
            // Deserialize a tweet given from the array into tweet variable
            let tweet = Tweet(dictionary: dictionary)
            // Append a tweet to array of tweet
            tweets.append(tweet)
        }
        // Return array of deserialized tweets
        return tweets
    }
}
