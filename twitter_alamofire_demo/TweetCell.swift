//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var rtButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.user.name
            screenNameLabel.text = tweet.user.screenName
            //print("URL:", String(tweet.user.profile_imageURL))
            if let url:URL = tweet.user.profileImageURL {
                userImageView.af_setImage(withURL: url)
                userImageView.layer.cornerRadius = userImageView.frame.size.width/2
            }
            retweetCountLabel.text = String(describing: tweet.retweetCount as! Int)
            createdAtLabel.text = tweet.createdAtString as? String
            refreshCell()
            refreshCellRt()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    // Refresh cell
    // ===============
    func refreshCell() {
        var img = ""
//        var img = tweet.favorited! ? "favor-icon-red" : "favor-icon"
        if tweet.favorited! == true {
            img = "favor-icon-red"
        } else {
            img = "favor-icon"
        }
        favButton.setImage(UIImage(named:img), for: .normal)
        var count = tweet.favoriteCount
        favCountLabel.text = String(describing: count!)
    }
    
    func refreshCellRt() {
        var img = ""
        // var img = tweet.favorited! ? "favor-icon-red" : "favor-icon"
        if tweet.retweeted == true {
            img = "retweet-icon-green"
        } else {
            img = "retweet-icon"
        }
        rtButton.setImage(UIImage(named:img), for: .normal)
        var count = tweet.retweetCount
        retweetCountLabel.text = String(describing: count)

    }
    
    
    // Favorite tweet
    // ==================
    @IBAction func favoriteTweet(_ sender: Any) {
        if tweet.favorited! == false {
            print("favorite")
            APIManager.shared.favorite(tweet) { (tweet: Tweet?,error: Error?) in
                if let tweet = tweet {
                    self.tweet.favorited = true
                    var favs = self.tweet.favoriteCount!
                    favs += 1
                    self.tweet.favoriteCount = favs
                    self.refreshCell()
                } else if let error = error {
                    print("Could not favorite tweet: " + error.localizedDescription)
                }
            }
        } else {
            print("unfavorite")
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?,error: Error?) in
                if let tweet = tweet {
                    self.tweet.favorited = false
                    var favs = self.tweet.favoriteCount!
                    favs -= 1
                    self.tweet.favoriteCount = favs
                    self.refreshCell()
                } else if let error = error {
                    print("Could not favorite tweet: " + error.localizedDescription)
                }
            }
        }
    }
    
    // Retweet tweet
    // =================
    @IBAction func retweetTweet(_ sender: Any) {
        if tweet.retweeted == false {
            print("retweet")
            APIManager.shared.retweet(tweet) { (tweet: Tweet?,error: Error?) in
                if let retweet = tweet {
                    self.tweet.retweeted = true
                    var rts = self.tweet.retweetCount
                    rts += 1
                    self.tweet.retweetCount = rts
                    self.refreshCellRt()
                } else if let error = error {
                    print("Could not retweet tweet: " + error.localizedDescription)
                }
            }
        } else {
            print("unretweet")
            APIManager.shared.unretweet(tweet) { (tweet: Tweet?,error: Error?) in
                if let retweet = tweet {
                    self.tweet.retweeted = false
                    var rts = self.tweet.retweetCount
                    rts -= 1
                    self.tweet.retweetCount = rts
                    self.refreshCellRt()
                } else if let error = error {
                    print("Could not unretweet: " + error.localizedDescription)
                }
            }
        }

    }
    
}
