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
    
    var id: Int!
    
    
    
    
    init(dictionary: NSDictionary) {
//        if let reply = (dictionary["sandTwitterReplyTo"] as? String){
//            text = "@\(reply) \(dictionary["text"] as! String)"
//        } else {
//            text = dictionary["text"] as? String
//        }
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        
        //Check if the tweet was created by the SandTwitter client -- this can be checked if the tweet dictionary has a SandTwitter key
        if let key = dictionary["sandTwitter"] {
            self.timestampString = dictionary["created_at"] as? String
        } else {
            //Extract Twitter timestamp format
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
            
            //Set up an id string - not a property that can be created by the SandTwitter client
            let postIdentification = dictionary["id"] as! Int
            id = postIdentification
            idString = String(postIdentification)
        }
        
        let userDictionary = dictionary["user"] as! NSDictionary
        creationUser = User(dictionary: userDictionary)
        
        favorited = dictionary["favorited"] as! Bool
        retweeted = dictionary["retweeted"] as! Bool
        
        
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
