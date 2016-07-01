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

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    public static var LAST_LOADED_TWEETS: [Tweet]! //For access by other classes - set in viewWillDisappear
    var tweets: [Tweet]! // Not a necessary version - tweets that user posts cannot be immediately favorited or retweeted because they do not have a unique ID
    
    var refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var maxID: String! //Keeps track of the oldest tweet in the home feed to be able to request the next batch of tweets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //If the tweets have been loaded before, there may have been an upload from the user
        if TweetsViewController.LAST_LOADED_TWEETS != nil {
            tableView.reloadData()
        } else {
            loadTweetData("initial")
        }
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        placeInfiniteActivityScroll()
        
        //Refresh control setup
        refreshControl.addTarget(self, action: #selector(loadTweetData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(TimeAid.getTimestamp())", attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        tableView.insertSubview(refreshControl, atIndex: 0)
        
    }
    
    func placeInfiniteActivityScroll() {
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //Load more results ...
                loadMoreTweetData()
            }
            
        }
    }
    
    func loadTweetData(point: AnyObject) {
        TwitterClient.sharedInstance.homeTimeline(nil, success: { (tweets: [Tweet]) in
            
            TweetsViewController.LAST_LOADED_TWEETS = tweets
            self.tableView.reloadData()
            
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        
        self.refreshControl.endRefreshing()
    }
    
    func loadMoreTweetData() {
        
        //Update Max Tweet ID
        self.updateMaxID()
        
        TwitterClient.sharedInstance.homeTimeline(maxID, success: { (tweets: [Tweet]) in
            self.loadingMoreView!.stopAnimating()
            TweetsViewController.LAST_LOADED_TWEETS.appendContentsOf(tweets)
            
            self.tableView.reloadData()
            
            // Update flag
            self.isMoreDataLoading = false
            
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }

    func updateMaxID() {
        //To be called after the set of the tweets variable
        maxID = TweetsViewController.LAST_LOADED_TWEETS.last?.idString
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = TweetsViewController.LAST_LOADED_TWEETS {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetTableViewCell
        cell.currentTweet = TweetsViewController.LAST_LOADED_TWEETS[indexPath.row]
        cell.profileButton.tag = indexPath.row
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
//        if TweetsViewController.LAST_LOADED_TWEETS != nil {
//            print("View will appear called")
//            print("The first tweet should be \(TweetsViewController.LAST_LOADED_TWEETS[0].text)")
//            tableView.dataSource = self
//            tableView.delegate = self
//            tableView.reloadData()
//        }
        
        
        if let path = tableView.indexPathForSelectedRow {
            
            tableView.deselectRowAtIndexPath(path, animated: true)
        }
        
        self.tableView.reloadData()
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
            detailVC.tweet = TweetsViewController.LAST_LOADED_TWEETS[(indexPath?.row)!]
        } else if segue.identifier == "toProfileView", let profileVC = segue.destinationViewController as? ProfileViewController {
            let currentTweet = TweetsViewController.LAST_LOADED_TWEETS[sender!.tag]
            profileVC.user = currentTweet.creationUser!
        }
    }
    

}
