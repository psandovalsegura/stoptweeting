//
//  MentionsViewController.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 7/1/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //Refresh control setup
        refreshControl.addTarget(self, action: #selector(loadTweetData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(TimeAid.getTimestamp())", attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadTweetData("initial")
    }

    func loadTweetData(point: AnyObject) {
        TwitterClient.sharedInstance.mentionsTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            print("Attained \(self.tweets.count) mentions")
            self.tableView.reloadData()
            
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
        
        self.refreshControl.endRefreshing()
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
        cell.currentTweet = self.tweets[indexPath.row]
        cell.profileButton.tag = indexPath.row
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
