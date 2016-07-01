//
//  DetailViewController.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/28/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoritesCount: UILabel!
    
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = tweet.creationUser?.profileUrl {
            profileImageView.af_setImageWithURL(url)
        }
        
        nameLabel.text = tweet.creationUser?.name
        screenNameLabel.text = "@\(tweet.creationUser!.screenname!)"
        contentLabel.text = tweet.text
        timestampLabel.text = String(TimeAid.getReadableDateFromFormat(tweet.timestampString!))
        retweetCount.text = String(tweet.retweetCount)
        favoritesCount.text = String(tweet.favoritesCount)
    }

    
    @IBAction func onShare(sender: AnyObject) {
        print("Tapped share in detail view")
        self.performSegueWithIdentifier("toReply", sender: nil)
        
    }
    
    
    @IBAction func onRetweet(sender: AnyObject) {
        print("retweet in detail clicked")
        //Change the image
        retweetImageView.image = UIImage(named: "retweet-action-on")
        let newCount = Int(retweetCount.text!)! + 1
        retweetCount.text = String(newCount)
        
        TwitterClient.sharedInstance.retweet(self.tweet.idString, success: { (returnTweet: Tweet) in
            //Do something with return tweet
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        print("favorite in detail clicked")
        //Change the image
        favoriteImageView.image = UIImage(named: "like-action-on")
        let newCount = Int(favoritesCount.text!)! + 1
        favoritesCount.text = String(newCount)
        
        TwitterClient.sharedInstance.favorite(self.tweet.idString, success: { (returnTweet: Tweet) in
            //Do something with return tweet
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Start to segue to the Reply View Controller")
        if segue.identifier == "toReply" {
            let replyVC = segue.destinationViewController as! ReplyViewController
            replyVC.tweet = self.tweet
        }
        
        
        
        
     }
    
    
}
