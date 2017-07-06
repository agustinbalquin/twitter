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

class ComposeController: UIViewController, UITextViewDelegate {


    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    weak var delegate: ComposeControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        var chars = 140 - numberOfChars
        characterCountLabel.text =  "\(chars)"
        return numberOfChars < 140
    }

    @IBAction func cancelCompose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tweetMessage(_ sender: Any) {
        let twit = textView.text
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
