//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by Satoru Sasozaki on 3/4/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "OE3KwJeNtpgj4T1yRGwQq9EMx", consumerSecret: "o14d7m2TMSdptbIew3Gf276yF2FKzxt9XKHxBlSLr3DUiFxtji")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    // First half of login process
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance.deauthorize()  // Clear everything in keychain to prevent any problems 
        // Go and get request token and assign it to requestToken
        // Callback contains the app extension (twitterapp://) to go back to this app
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterapp://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential!) -> Void in
            // Authorize the application to access my account
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            // Open Safari to the url
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error : NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    // Second half of login process
    func handleOpenUrl(url : NSURL) {
        // requestToken is going to be a part after ? in the passed URL
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        // Jump to oauth/access_token URL with POST method and requestToken which has been gotten before
        // To obtain accessToken
        // Passing success and failure closure
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("I got the access token!")
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
            }) {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        // Post notification saying user did logout
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    // Passing success and failure closure (What to do if succeed or failed)
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        // GET with endpoint: 1.1/statuses/home_timeline.json
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // Use Tweet class
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            // Call success closure from homeTimeline method to print tweets
            success(tweets)
            
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                // Cal failure closure from homeTimeline method
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        // https://dev.twitter.com/rest/reference/get/account/verify_credentials
        // Call GET to get account information
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in

            // Use User model class to deserialization
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)

            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
                
        })
    }

}
