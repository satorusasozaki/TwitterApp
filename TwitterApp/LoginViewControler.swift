//
//  LoginViewControler.swift
//  TwitterApp
//
//  Created by Satoru Sasozaki on 2/27/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewControler: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        // Create a session
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "OE3KwJeNtpgj4T1yRGwQq9EMx", consumerSecret: "o14d7m2TMSdptbIew3Gf276yF2FKzxt9XKHxBlSLr3DUiFxtji")
        
        // Clear everything in keychain to prevent any problems
        twitterClient.deauthorize()
        
        // Go and get request token and assign it to requestToken
        twitterClient.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterapp://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token!")
            // Authorize the application to access my account
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            // Open Safari to the url
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error : NSError!) -> Void in
                print("error: \(error.localizedDescription)")
        }
        
    }
    
}
