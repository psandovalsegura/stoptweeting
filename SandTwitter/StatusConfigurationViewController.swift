//
//  StatusConfigurationViewController.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/29/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class StatusConfigurationViewController: UIViewController {

    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var charactersAllowed = 140
    var currentCharacters = 0
    
    var uploadedTweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        profileImageView.setImageWithURL((User.currentUser?.profileUrl)!)
        characterCountLabel.text = String(charactersAllowed)
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
        //Construct a Tweet object to be sent to the home view - simulating a rapid upload, UPGRADE -- does not have ID!
        //Prepare timestamp
        let time = String(NSDate())
        var currentDate2String = time
        for _ in 1...6 {
            currentDate2String.removeAtIndex(currentDate2String.endIndex.predecessor())
        }
        //The tweet is marked as created by the client through the 'sandTwitter' key
        let tweetDictionary: NSDictionary = ["text": textField.text!, "retweet_count": 0, "favorite_count" : 0, "created_at": TimeAid.getFormattedDate(), "user": (User.currentUser?.dictionary)!, "favorited": false, "retweeted": false, "sandTwitter": true]
        
        uploadedTweet = Tweet(dictionary: tweetDictionary)
        
        TwitterClient.sharedInstance.postTweet(textField.text!, success: {
            
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
        
        //Segue home
        self.performSegueWithIdentifier("onTweetSend", sender: nil)
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Load the new tweet into the home view without reloading data
        if segue.identifier == "onTweetSend", let tabVC = segue.destinationViewController as? UITabBarController {
            let navigationVC = tabVC.viewControllers![0] as! UINavigationController
            let homeVC = navigationVC.viewControllers[0] as! TweetsViewController
            print("Tweet is being inserted into the feed")
            TweetsViewController.LAST_LOADED_TWEETS.insert(uploadedTweet, atIndex: 0) //Insert the new tweet
            //homeVC.tableView.reloadData()
            print("The first tweet should be \(TweetsViewController.LAST_LOADED_TWEETS[0].text) by \(TweetsViewController.LAST_LOADED_TWEETS[0].creationUser!.name)")
            print("Home view controller is reloading data...")
        }
    }
 
    
    // MARK: - Lifecycle
    
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

}
