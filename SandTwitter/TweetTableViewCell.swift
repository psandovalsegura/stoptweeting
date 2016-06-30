//
//  TweetTableViewCell.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/27/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareImageView: UIImageView!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    
    
    var currentTweet: Tweet! {
        didSet {
            tweetTextLabel.text = currentTweet.text!
            profileImageView.af_setImageWithURL((currentTweet.creationUser?.profileUrl)!)
            nameLabel.text = currentTweet.creationUser?.name
            screenNameLabel.text = "@\(currentTweet.creationUser!.screenname!)"
            timestampLabel.text = TimeAid.getTimeDifferenceForTwitterCell(currentTweet.timestampString)
            retweetCountLabel.text = String(currentTweet.retweetCount)
            favoritesCountLabel.text = String(currentTweet.favoritesCount)
            
            //Manage whether the tweet has already been favorited or retweeted
            if currentTweet.favorited {
                favoriteImageView.image = UIImage(named: "like-action-on")
            }
            if currentTweet.retweeted {
                retweetImageView.image = UIImage(named: "retweet-action-on")
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onShare(sender: AnyObject) {
        print("tapped share")
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if !currentTweet.retweeted {
            
            //Change the image - begin retweet display and action
            retweetImageView.image = UIImage(named: "retweet-action-on")
            let newCount = Int(retweetCountLabel.text!)! + 1
            retweetCountLabel.text = String(newCount)
            
            TwitterClient.sharedInstance.retweet(currentTweet.idString, success: { (returnTweet: Tweet) in
                self.currentTweet.retweeted = true //does not change the object's server property, just manages to disallow another retweet in the table view
                //Do something with return tweet
            }) { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            }
            
        } else {
            //Change the image back - begin unretweet display and action
            retweetImageView.image = UIImage(named: "retweet-action")
            let newCount = Int(retweetCountLabel.text!)! - 1
            retweetCountLabel.text = String(newCount)
            
            TwitterClient.sharedInstance.unretweet(currentTweet.idString, success: { (returnTweet: Tweet) in
                self.currentTweet.retweeted = false
            }, failure: { (error: NSError) in
                    print("Error: \(error.localizedDescription)")
            })
            
        }
        
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        if !currentTweet.favorited {
            //Change the image
            favoriteImageView.image = UIImage(named: "like-action-on")
            let newCount = Int(favoritesCountLabel.text!)! + 1
            favoritesCountLabel.text = String(newCount)
            
            TwitterClient.sharedInstance.favorite(currentTweet.idString, success: { (returnTweet: Tweet) in
                self.currentTweet.favorited = true
                //Do something with return tweet
            }) { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            }
        } else {
            //Change the image back
            favoriteImageView.image = UIImage(named: "like-action")
            let newCount = Int(favoritesCountLabel.text!)! - 1
            favoritesCountLabel.text = String(newCount)
            
            TwitterClient.sharedInstance.unfavorite(currentTweet.idString, success: { (Tweet) in
                self.currentTweet.favorited = false
            }, failure: { (error: NSError) in
                    print("Error: \(error.localizedDescription)")
            })
        }
        
    }
    
}