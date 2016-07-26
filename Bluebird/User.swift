//
//  User.swift
//  Bluebird
//
//  Created by Nhung Huynh on 7/22/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    var name: String?
    var screenName: String?
    var profileUrl: NSURL?
    var tagline: String?
    
    var dictionary: NSDictionary?
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(user, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}

