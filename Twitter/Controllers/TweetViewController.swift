//
//  TweetViewController.swift
//  Twitter
//
//  Created by Kay Lab on 5/2/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelButton(_ sender: Any) {
        // dismisses the view controller
        dismiss(animated: true, completion: nil)
    }
  
    @IBAction func tweetButton(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print("Error postin tweet \(error)")
            })
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
