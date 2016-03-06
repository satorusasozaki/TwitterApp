//
//  TweetViewController.swift
//  TwitterApp
//
//  Created by Satoru Sasozaki on 3/5/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text)
            }
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
////        navigationController!.popViewControllerAnimated(true)
//        self.dismissViewControllerAnimated(true, completion:
//        print("TweetViewController will disappear")
//    }

    @IBAction func onLogoutButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        TwitterClient.sharedInstance.logout()
    }
}
