//
//  DetailViewController.swift
//  SandTwitter
//
//  Created by Pedro Sandoval Segura on 6/28/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var tweet: Tweet! {
        didSet {
            print("received tweet")
        }
    }

}
