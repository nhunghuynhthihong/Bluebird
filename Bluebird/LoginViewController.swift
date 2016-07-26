//
//  LoginViewController.swift
//  Bluebird
//
//  Created by Nhung Huynh on 7/20/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLogin(sender: UIButton) {
        TwitterClient.sharedInstance.login({ 
            print("I've logged in!")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            }) { (error) in
                print("Error: \(error.localizedDescription)")
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

}
