//
//  ProfileViewController.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/28/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User!

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var taglineLabel: UILabel!
    
    
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var statusesCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.af_setImageWithURL(self.user.profileUrl!)
        nameLabel.text = self.user.name
        screenName.text = "@\(self.user.screenname!)"
        taglineLabel.text = "\(self.user.tagline!)"
        followersCountLabel.text = String(self.user.followersCount!)
        followingCountLabel.text = String(self.user.friendsCount!)
        statusesCountLabel.text = String(self.user.statusesCount!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
