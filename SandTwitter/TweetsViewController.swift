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
    
    var tweets: [Tweet]!
    
    var refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var maxID: String! //Keeps track of the oldest tweet in the home feed to be able to request the next batch of tweets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadTweetData("initial")
        
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
            
            self.tweets = tweets
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
            self.tweets.appendContentsOf(tweets)
            
            self.tableView.reloadData()
            
            // Update flag
            self.isMoreDataLoading = false
            
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }

    func updateMaxID() {
        //To be called after the set of the tweets variable
        maxID = self.tweets.last?.idString
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let path = tableView.indexPathForSelectedRow {
            
            tableView.deselectRowAtIndexPath(path, animated: true)
        }
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
