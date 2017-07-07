//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Agustin Balquin on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userBannerView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editProfile: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var photoHeaderViewHeight:CGFloat = 45
    var tweets: [Tweet]!  {
        didSet {
            tableView.reloadData()
        }
    }
    
    var user:User! {
        didSet {
            if (viewIfLoaded != nil) {
                self.reloadUserData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        if user == nil {
            user = User.current
        }
        reloadUserData()
        reloadTweetData()
        
        editProfile.backgroundColor = .clear
        editProfile.layer.cornerRadius = 5
        editProfile.layer.borderWidth = 1
        editProfile.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Table View
    // ==============
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowTweet = tweets[indexPath.row]
        let originalTweet = rowTweet.originalTweet
        print(originalTweet)
        if let twit = originalTweet {
            print("retweet")
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileRetweetCell", for: indexPath) as! RetweetCell
            cell.retweeter = rowTweet.user
            cell.tweet = twit
            return cell
        } else {
            print("regular tweet")
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileTweetCell", for: indexPath) as! TweetCell
            cell.tweet = rowTweet
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableHeader") as! HeaderCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return photoHeaderViewHeight
    }
    
    
    
    // Reload Tweet Data
    // ====================
    func reloadTweetData() {
        APIManager.shared.getUserTimeLine (user: self.user,completion: { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting user timeline: " + error.localizedDescription)
            }
        })
    }
    
    // Reload User Data
    // =================
    func reloadUserData() {
        print(user)
        followersCount.text = String(describing: user.followersCount!)
        nameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName)"
        //print("URL:", String(tweet.user.profile_imageURL))
        print("profile?")
        if let url = user.profileImageURL {
            print(url)
            userImageView.af_setImage(withURL: url)
        }
        print("banner?")
        if let bannerUrl = user.profileImageURL {
            userImageView.af_setImage(withURL: bannerUrl)
            userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        }
    }
    
}
