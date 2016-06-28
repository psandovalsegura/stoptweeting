//
//  Tweet.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/27/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    var creationUser: User?
    var favorited: Bool = false
    var retweeted: Bool = false
    var timestampString: String!
    var idString: String!
    
    
    
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        //Prepare timestamp for use in TimeAid class
        let time = String(timestamp!)
        var currentDate2String = time
        for _ in 1...6 {
            currentDate2String.removeAtIndex(currentDate2String.endIndex.predecessor())
        }
        self.timestampString = currentDate2String
        
        let userDictionary = dictionary["user"] as! NSDictionary
        creationUser = User(dictionary: userDictionary)
        
        favorited = dictionary["favorited"] as! Bool
        retweeted = dictionary["retweeted"] as! Bool
        
        //Set up an id string
        let postIdentification = dictionary["id"] as! Int
        idString = String(postIdentification)
        
    }
    
    class func tweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
