//
//  ProfileViewController.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/28/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: User!

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var taglineLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var statusesCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        profileImageView.af_setImageWithURL(self.user.profileUrl!)
        nameLabel.text = self.user.name
        screenName.text = "@\(self.user.screenname!)"
        taglineLabel.text = "\(self.user.tagline!)"
        followersCountLabel.text = String(self.user.followersCount!)
        followingCountLabel.text = String(self.user.friendsCount!)
        statusesCountLabel.text = String(self.user.statusesCount!)
        
        loadUserTweets("initial")
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetTableViewCell
        cell.currentTweet = self.tweets[indexPath.row]
        return cell
    }
    
    func loadUserTweets(point: AnyObject) {
        TwitterClient.sharedInstance.userTimeline(user.idString!, screenName: user.screenname!, success: { (userTweets: [Tweet]) in
            
            //Save loaded tweets
            self.tweets = userTweets
            self.tableView.reloadData()
            
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
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
