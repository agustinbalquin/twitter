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
            }
            retweetCountLabel.text = String(describing: tweet.retweetCount as! Int)
            createdAtLabel.text = tweet.createdAtString as? String
            refreshCell()
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
        if tweet.favorited == true {
            img = "favor-icon-red"
        } else {
            img = "favor-icon"
        }
        favButton.setImage(UIImage(named:img), for: .normal)
        var count = tweet.favoriteCount
        favCountLabel.text = String(describing: count!)
    }
    
    
    // Favorite tweet
    // ==================
    @IBAction func favoriteTweet(_ sender: Any) {
        if tweet.favorited == false {
            print("favorite")
            tweet.favorited = true
            var favs = tweet.favoriteCount!
            favs += 1
            tweet.favoriteCount = favs
            APIManager.shared.favorite(tweet) { (tweet: Tweet?,error: Error?) in
                if let tweet = tweet {
                    self.refreshCell()
                } else if let error = error {
                    print("Could not favorite tweet: " + error.localizedDescription)
                }
            }
        } else {
            print("unfavorite")
            tweet.favorited = false
            var favs = tweet.favoriteCount!
            favs -= 1
            tweet.favoriteCount = favs
            APIManager.shared.unfavorite(tweet) { (tweet: Tweet?,error: Error?) in
                if let tweet = tweet {
                    self.refreshCell()
                } else if let error = error {
                    print("Could not favorite tweet: " + error.localizedDescription)
                }
            }
        }
    }
    
    
}
