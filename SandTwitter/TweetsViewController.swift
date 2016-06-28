//
//  TweetsViewController.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/27/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadTweetData()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    

    
    func loadTweetData() {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            
            for tweet in tweets {
                print(tweet.text)
            }
            
            self.tableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetTableViewCell

        let currentTweet = self.tweets[indexPath.row]
        cell.tweetTextLabel.text = currentTweet.text!
        cell.profileImageView.af_setImageWithURL((currentTweet.creationUser?.profileUrl)!)
        cell.nameLabel.text = currentTweet.creationUser?.name
        cell.screenNameLabel.text = currentTweet.creationUser?.screenname
        
        cell.timestampLabel.text = TimeAid.getTimeDifferenceForTwitterCell(currentTweet.timestampString)
        
        
        return cell
    }
    
    
    @IBAction func onShare(sender: AnyObject) {
        
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        
    }

    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logOut()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
