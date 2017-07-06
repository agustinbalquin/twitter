//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tableView: UITableView!
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
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
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
    }
    

    
    
}

extension TimelineViewController: ComposeControllerDelegate {
    func did(post: Tweet) {
        loadMoreData()
    }
}

// Date since
// =============
extension Date {
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "YEAR AGO" :
                "\(year)" + " " + "YEARS AGO"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "MONTH AGO" :
                "\(month)" + " " + "MONTHS AGO"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "DAY AGO" :
                "\(day)" + " " + "DAYS AGO"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "HOUR AGO" :
                "\(hour)" + " " + "HOURS AGO"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute)" + " " + "MINUTE AGO" :
                "\(minute)" + " " + "MINUTES AGO"
        } else {
            return "A MOMENT AGO"
        }
    }
}
