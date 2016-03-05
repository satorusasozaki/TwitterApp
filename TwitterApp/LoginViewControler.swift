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
        TwitterClient.sharedInstance.login({ () -> () in
            print("I've logged in!")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }, failure: { (error: NSError) -> () in
            print("Error: \(error.localizedDescription)")
        })
        
        // There are two way to write how to pass two argment to closure
//        client.login({ () -> () in
//            print("I've logged in!")
//        }) { (error: NSError) -> () in
//                print("Error: \(error.localizedDescription)")
//        }

        
    }
    
}
