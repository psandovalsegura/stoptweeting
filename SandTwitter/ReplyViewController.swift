//
//  ReplyViewController.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 7/1/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {
    
    var tweet: Tweet!
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var charactersAllowed = 140
    var currentCharacters = 0
    
    var uploadedTweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.setImageWithURL((User.currentUser?.profileUrl)!)
        characterCountLabel.text = String(charactersAllowed)
        
        let replyToUser = self.tweet.creationUser!.screenname!
        self.textField.text = "@\(replyToUser) "
    }

    @IBAction func duringEditing(sender: AnyObject) {
        let characterChange = (textField.text?.characters.count)! - currentCharacters
        currentCharacters += characterChange
        
        if (currentCharacters >= 140) {
            self.view.endEditing(true)
        }
        
        characterCountLabel.text = String(charactersAllowed - currentCharacters)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        
    }
    
    @IBAction func onSendTweet(sender: AnyObject) {
        //Prepare timestamp
        let time = String(NSDate())
        var currentDate2String = time
        for _ in 1...6 {
            currentDate2String.removeAtIndex(currentDate2String.endIndex.predecessor())
        }
        //The tweet is marked as created by the client through the 'sandTwitter' key
        let tweetDictionary: NSDictionary = ["text": textField.text!, "retweet_count": 0, "favorite_count" : 0, "created_at": TimeAid.getFormattedDate(), "user": (User.currentUser?.dictionary)!, "favorited": false, "retweeted": false, "sandTwitter": true, "sandTwitterReplyTo": self.tweet.creationUser!.screenname!]
        
        print("--------------------------->\n \n \n Replying to: \(self.tweet.creationUser!.screenname!)")
        uploadedTweet = Tweet(dictionary: tweetDictionary)
        
        TwitterClient.sharedInstance.replyToTweet(textField.text!, inReplyToUsername: self.tweet.creationUser!.screenname!, inReplyToID: self.tweet.idString, success: {
            
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                
                self.bottomLayoutConstraint.constant += keyboardSize.height
                UIView.animateWithDuration(0.3, animations: {
                    self.view.setNeedsLayout()
                })
            }
        }
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        bottomLayoutConstraint.constant = 20.0
        view.setNeedsLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "onTweetReply", let tabVC = segue.destinationViewController as? UITabBarController {
            let navigationVC = tabVC.viewControllers![0] as! UINavigationController
            let homeVC = navigationVC.viewControllers[0] as! TweetsViewController
            print("Tweet REPLY is being inserted into the feed")
            TweetsViewController.LAST_LOADED_TWEETS.insert(uploadedTweet, atIndex: 0) //Insert the new tweet
            //homeVC.tableView.reloadData()
            print("The first tweet should be \(TweetsViewController.LAST_LOADED_TWEETS[0].text) by \(TweetsViewController.LAST_LOADED_TWEETS[0].creationUser!.name)")
            print("Home view controller is reloading data...")
        }
        
    }
    

}
