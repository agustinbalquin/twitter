//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Agustin Balquin on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userBannerView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    var user:User! {
        didSet {
            if (viewIfLoaded != nil) {
                self.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil {
            user = User.current
        }
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadData() {
        print(user)
        followersCount.text = String(describing: user.followersCount!)
        nameLabel.text = user.name
        screenNameLabel.text = user.screenName
        //print("URL:", String(tweet.user.profile_imageURL))
        if let url:URL = user.profileImageURL {
            print(url)
            userImageView.af_setImage(withURL: url)
        }
    }
    
}
