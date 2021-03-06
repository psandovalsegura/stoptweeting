//
//  TwitterClient.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/27/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "piNt1WszKkPZzpeld91M8g7zt", consumerSecret: "5EWSWkzVIKw4sCI7lCPtdGiXahMYITdMWMocbiNpTAhezLQpmU")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        
        let client  = TwitterClient.sharedInstance
        client.deauthorize()
        
        client.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("Token Attained")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            
            
        }) { (error: NSError!) in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }

    }
    
    func logOut() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)    }
    
    func handleUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            
        }) { (error: NSError!) in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func homeTimeline(maxID: String!, success: ([Tweet]) -> (), failure: (NSError) -> Void) {
        let requestString: String!
        if maxID == nil {
            requestString = "1.1/statuses/home_timeline.json"
            print("chose \(requestString)")
        } else {
            requestString = "1.1/statuses/home_timeline.json?max_id=\(maxID)"
        }
        
        GET(requestString, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsFromArray(dictionaries)
            success(tweets)
            
        }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
            failure(error)
            
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }
    
    
    func retweet(id: String, success: (Tweet) -> Void, failure: (NSError) -> Void) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            
            success(tweet)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func unretweet(id: String, success: (Tweet) -> Void, failure: (NSError) -> Void) {
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            
            success(tweet)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }

    
    func favorite(id: String, success:(Tweet) -> Void, failure: (NSError) -> Void) {
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            
            success(tweet)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    func unfavorite(id: String, success:(Tweet) -> Void, failure: (NSError) -> Void) {
        POST("1.1/favorites/destroy.json?id=\(id)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            
            success(tweet)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }

    
    func userTimeline(idString: String, screenName: String, success: ([Tweet]) -> Void, failure: (NSError) -> Void) {
        print("@\(screenName) requesting to load user tweets...\n The endpoint looks like this: 1.1/statuses/user_timeline.json?user_id=\(idString)&screen_name=\(screenName)")
        GET("1.1/statuses/user_timeline.json?user_id=\(idString)&screen_name=\(screenName)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsFromArray(dictionaries)
            success(tweets)
            
            }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                failure(error)
                
        })
    }
    
    func mentionsTimeline(success: ([Tweet]) -> (), failure: (NSError) -> Void) {
        
        GET("1.1/statuses/mentions_timeline.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsFromArray(dictionaries)
            success(tweets)
            
            }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                failure(error)
                
        })
    }

    
    
    func postTweet(status: String, success:() -> Void, failure: (NSError) -> Void) {
        let params = ["status" : status]
        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            print("Post tweeted!")
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    
    func replyToTweet(status: String, inReplyToUsername: String, inReplyToID: String, success:() -> Void, failure: (NSError) -> Void) {
        let params = ["status" : status, "in_reply_to_status_id" : inReplyToID] //"@\(inReplyToUsername) \(status)"
        
        POST("1.1/statuses/update.json", parameters: params, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            print("Reply tweeted!")
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }

    
    func getTweet(idString: String, success:(Tweet) -> Void, failure: (NSError) -> Void) {
        
        GET("1.1/statuses/show.json?id=\(idString)", parameters: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweetReturned = Tweet(dictionary: tweetDictionary)
            
            success(tweetReturned)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        }
    }
    
    
    
    

}













