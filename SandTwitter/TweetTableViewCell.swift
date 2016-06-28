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
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var currentTweet: Tweet! {
        didSet {
            tweetTextLabel.text = currentTweet.text!
            profileImageView.af_setImageWithURL((currentTweet.creationUser?.profileUrl)!)
            nameLabel.text = currentTweet.creationUser?.name
            screenNameLabel.text = currentTweet.creationUser?.screenname
            timestampLabel.text = TimeAid.getTimeDifferenceForTwitterCell(currentTweet.timestampString)
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
        print("Retweet action detected at cell \(sender.tag)")
        TwitterClient.sharedInstance.retweet(currentTweet.idString, success: { (returnTweet: Tweet) in
            //Do something with return tweet
            print("\(self.currentTweet.creationUser?.screenname) 's tweet retweeted!")
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        print("tapped favorite")
    }
    
}