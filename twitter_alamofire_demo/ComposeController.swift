//
//  ComposeController.swift
//  twitter_alamofire_demo
//
//  Created by Agustin Balquin on 7/3/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit


protocol ComposeControllerDelegate: NSObjectProtocol {
    func did(post: Tweet)
}

class ComposeController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    
    
    weak var delegate: ComposeControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func cancelCompose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tweetMessage(_ sender: Any) {
        let twit = tweetTextView.text
        print(twit!)
        APIManager.shared.composeTweet(with: (twit!)) { (tweet, error) in
            if let error = error {
                print("TERROR")
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}
