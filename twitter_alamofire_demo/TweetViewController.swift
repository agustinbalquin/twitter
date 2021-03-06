//
//  TweetViewController.swift
//  twitter_alamofire_demo
//
//  Created by Agustin Balquin on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var userPicture: UIImageView!
    
    var tweet:Tweet! {
        didSet {
            if (viewIfLoaded != nil) {
                self.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Reload Data
    // =================
    
    func reloadData() {
        tweetLabel.text = tweet.text
        usernameLabel.text = "@\(tweet.user.screenName)"
        nameButton.setTitle(tweet.user.name, for: .normal)
        if let url:URL = tweet.user.profileImageURL {
            userPicture.af_setImage(withURL: url)
        }
    }

    @IBAction func userLink(_ sender: Any) {
        performSegue(withIdentifier: "linkSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let profileViewController = segue.destination as! ProfileViewController
        profileViewController.user = self.tweet.user
    }
    

}
