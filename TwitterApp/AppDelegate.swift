//
//  AppDelegate.swift
//  TwitterApp
//
//  Created by Satoru Sasozaki on 2/27/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // This method will get called when the app open a URL
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print(url.description)
        // requestToken is going to be a part after ? in the passed URL
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        // Create session manager to fetch access token
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "OE3KwJeNtpgj4T1yRGwQq9EMx", consumerSecret: "o14d7m2TMSdptbIew3Gf276yF2FKzxt9XKHxBlSLr3DUiFxtji")
        
        // Jump to oauth/access_token URL with POST method and requestToken which has been gotten before
        // To obtain accessToken
        twitterClient.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            // Inside success handler with an argument; accessToken
            // The result is going to be passed to accessToken variable
            print("I got the access token!")
            
            // https://dev.twitter.com/rest/reference/get/account/verify_credentials
            // Call GET to get account information
            twitterClient.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
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
            
            // Method: GET
            // Endpoint: 1.1/statuses/home_timeline.json
            twitterClient.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: {(task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                // Inside success handler passed two arguments. task and response
                
//                // get tweets from response returned from GET API method
//                let tweets = response as! [NSDictionary]
//                
//                // Iterate through tweet array of dictionary
//                for tweet in tweets {
//                    // Print text contained by each tweet
//                    print("\(tweet["text"]!)")
//                }
                
                // Use Tweet class 
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries)
                
                for tweet in tweets {
                    print("\(tweet.text!)")
                }
                
                }, failure: {(task: NSURLSessionDataTask?, error: NSError) -> Void in
                // Inside failure handler passed two argument. task and error
                // error contains what happened if error happened
                    
                })
            
            }) {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
        }
        return true
    }


}

