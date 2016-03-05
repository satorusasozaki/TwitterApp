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
    // Create session manager to fetch access token
    // static make it cannot be overwritten
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "OE3KwJeNtpgj4T1yRGwQq9EMx", consumerSecret: "o14d7m2TMSdptbIew3Gf276yF2FKzxt9XKHxBlSLr3DUiFxtji")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        // Clear everything in keychain to prevent any problems
        TwitterClient.sharedInstance.deauthorize()
        
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
    
    func handleOpenUrl(url : NSURL) {
        // requestToken is going to be a part after ? in the passed URL
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        // Jump to oauth/access_token URL with POST method and requestToken which has been gotten before
        // To obtain accessToken
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("I got the access token!")
            self.loginSuccess?()
            
            }) {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        // Method: GET
        // Endpoint: 1.1/statuses/home_timeline.json
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // Inside success handler passed two arguments. task and response
            
            // Use Tweet class
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            // Call success closure to print tweets
            success(tweets)
            
            }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                // Inside failure handler passed two argument. task and error
                // error contains what happened if error happened
            
                // Cal failure closure
                failure(error)
        })
    }
    
    func currentAccount() {
        // https://dev.twitter.com/rest/reference/get/account/verify_credentials
        // Call GET to get account information
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            // Inside success handler with two argument; task and response
            // The result is going to be passed to response
            //print("acount: \(response)")
            //                let user = response as! NSDictionary
            //                print("name: \(user["name"])")
            
            // Use User model class to deserialization
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile url: \(user.profileUrl)")
            
            
            
            // failure handler with two argument; task and response
            }, failure: {(task: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                
        })
    }

}
