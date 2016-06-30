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
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadTweetData("initial")
        
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
        
    }
    

    
    func loadTweetData(point: AnyObject) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
            
        }) { (error: NSError) in
            print(error.localizedDescription)
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
    
    @IBAction func onComposeTweet(sender: AnyObject) {
        self.performSegueWithIdentifier("toTweetConfiguration", sender: nil)
    }

    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logOut()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailView", let detailVC = segue.destinationViewController as? DetailViewController {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            detailVC.tweet = self.tweets[(indexPath?.row)!]
        } else if segue.identifier == "toProfileView", let profileVC = segue.destinationViewController as? ProfileViewController {
            let currentTweet = self.tweets[sender!.tag]
            profileVC.user = currentTweet.creationUser!
        }
    }
    

}
