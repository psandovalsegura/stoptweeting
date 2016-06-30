//
//  MeViewController.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/29/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var sementControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var userTweets: [Tweet]!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        profileImageView.af_setImageWithURL((User.currentUser!.profileUrl)!)
        nameLabel.text = User.currentUser!.name!
        screenNameLabel.text = "@\(User.currentUser!.screenname!)"
        followingCount.text = String(User.currentUser!.friendsCount!)
        followersCount.text = String(User.currentUser!.followersCount!)
        taglineLabel.text = User.currentUser!.tagline!
        print("Displaying tagline: \(User.currentUser!.tagline)")
        
        // Do any additional setup after loading the view.
        //Refresh control setup
        refreshControl.addTarget(self, action: #selector(loadUserTweetData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(TimeAid.getTimestamp())", attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadUserTweetData("initial")
    }
    

    func loadUserTweetData(point: AnyObject) {
        let currentUserScreenName = User._currentUser!.screenname!
        TwitterClient.sharedInstance.userTimeline(User.currentUser!.idString!, screenName: currentUserScreenName, success:{ (responseTweets: [Tweet]) in
            self.userTweets = responseTweets
            print("User tweets have loaded!")
            for tweet in self.userTweets {
                print("\(tweet.creationUser!.screenname!)'s tweet loaded for user")
            }
            
            self.tableView.reloadData()
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        
        self.refreshControl.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.userTweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetTableViewCell
        cell.currentTweet = self.userTweets[indexPath.row]
        
        return cell
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
