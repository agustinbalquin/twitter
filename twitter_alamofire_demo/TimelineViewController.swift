//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    // TableView
    // =================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowTweet = tweets[indexPath.row]
        if let rowUser = rowTweet.retweetedByUser {
            print("retweet")
            let cell = tableView.dequeueReusableCell(withIdentifier: "RetweetCell", for: indexPath) as! RetweetCell
            cell.retweeter = rowUser
            cell.tweet = rowTweet
            return cell
        } else {
            print("regular tweet")
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            cell.tweet = rowTweet
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Logout
    // ============
    @IBAction func didTapLogout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    // Prepare for Segue
    // ====================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "composeSegue" {
            let composeController = segue.destination as! ComposeController
            composeController.delegate = self
        } else if segue.identifier == "tweetViewSegue" {
            let tweetViewController = segue.destination as! TweetViewController
            let cell = sender as! TweetCell
            if let indexPath = tableView.indexPath(for: cell) {
                let tweet:Tweet = tweets[indexPath.row]
                print(tweet.text)
                tweetViewController.tweet = tweet
            }
            
        }
    }
    

    
    
    
    // Compose tweet
    // ===============
    @IBAction func composeTweet(_ sender: Any) {
        performSegue(withIdentifier: "composeSegue", sender: nil)
    }
    
    // Refresh Control
    // ==================
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    // LoadMoreData
    // ============
    func loadMoreData() {
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.tweets += tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    
    // Infinite Scroll
    // ====================
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    

    
    
}

extension TimelineViewController: ComposeControllerDelegate {
    func did(post: Tweet) {
        let alertController = UIAlertController(title: "Success", message: "Tweet was posted", preferredStyle: .alert)
        
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) { }
        self.tweets.insert(post, at: 0)
        self.tableView.reloadData()

    }
}

