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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profileImageView.setImageWithURL((User.currentUser?.profileUrl)!)
    }

    
    
    @IBAction func onCancel(sender: AnyObject) {
        
    }
    
    @IBAction func onSendTweet(sender: AnyObject) {
        TwitterClient.sharedInstance.postTweet(textField.text!, success: { 
            //
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
