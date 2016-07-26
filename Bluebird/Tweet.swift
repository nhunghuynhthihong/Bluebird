//
//  Tweet.swift
//  Bluebird
//
//  Created by Nhung Huynh on 7/22/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp : NSDate?
    var retweetCount = 0
    var favoritesCount = 0
    
    var profileImgUrl: NSURL?
    var username: String?
    var screenname: String?
    
    var favorited = false
    var retweeted = false
    var id: String
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as! String
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["entities"]?["favourites_count"] as? Int) ?? 0
        print(favoritesCount)
        favorited = dictionary["favorited"] as? Bool ?? false
        retweeted = dictionary["retweeted"] as? Bool ?? false
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)!
        }
        
        let userDictionary = dictionary["user"] as? NSDictionary
        
        if let userDictionary = userDictionary {
            self.username = (userDictionary["name"] as? String)!
            self.screenname = (userDictionary["screen_name"] as? String)
            if let url = userDictionary["profile_image_url_https"] as? String{
                print(url)
                self.profileImgUrl = NSURL(string: url)
            }
            let userMention = dictionary["user_mentions"] as? [NSDictionary]
            if let userMention = userMention {
                print(userMention)
            }
        }
        
   }
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}