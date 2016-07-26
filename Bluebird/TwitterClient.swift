//
//  TwitterClient.swift
//  Bluebird
//
//  Created by Nhung Huynh on 7/22/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

enum Retweet: String {
    case retweet = "retweet"
    case unretweet = "unretweet"
}
enum FavoriteStatus: String {
    case destroy = "destroy"
    case create = "create"
}

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "K2j2tQzdE0oIYa5mYaO6zEzdg", consumerSecret: "AsjDsryWecHZMirnMjzpgsnwANMz0MP9vsFJWJnROttt0gFaE8")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        // change the previous se ssion
        deauthorize()
        // go to info file to set bluebird://oath like URL schemes
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "bluebird://oath"), scope: nil, success: { (requestToken) in
            print("I got a token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error) in
            print("\(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
    }
    func handleOpenUrl(url: NSURL) {
        let requetToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("/oauth/access_token", method: "POST", requestToken: requetToken, success: { (accessToken) in
            self.currentAccount({ (user) in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error) in
                    self.loginFailure?(error)
            })
        }) { (error) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task, response) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            //            for tweet in tweets {
            //                print("\(tweet.text) ")
            //            }
            success(tweets)
            }, failure: { (task, error) in
                failure(error)
        })
    }
    func currentAccount(success: (User)->(), failure: (NSError)->()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, response) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task, error) in
                failure(error)
        })
    }
    
    func retweet(id: String, retweet: Bool, success: (Tweet) -> (), failure: (NSError) -> ()) {
//        let params = ["id": id]
        let retweet = retweet ? Retweet.retweet : Retweet.unretweet
        print(retweet.rawValue)
        print(id)
        POST("1.1/statuses/\(retweet.rawValue)/\(id).json", parameters: nil, progress: nil, success: { (task, response) in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task, error) in
                failure(error)
        })
        
    }
    
    func handleStarTweet(id: String, isFavorited: Bool, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let isFavorited = isFavorited ? FavoriteStatus.create : FavoriteStatus.destroy
        let params = ["id": id]
        print(isFavorited.rawValue)
        POST("1.1/favorites/\(isFavorited.rawValue).json", parameters: params, progress: nil, success: { (task, response) in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task, error) in
                failure(error)
        })
        
    }
    
    func replyTweet(tweetId: String, status: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let params = ["status": status, "in_reply_to_status_id": tweetId]
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task, response) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task, error) in
            failure(error)
        }
    }
    
    func updateTweet(status: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let params = ["status": status]
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task, response) in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task, error) in
            failure(error)
        }
    }
}
