//
//  TweetDetailViewController.swift
//  Bluebird
//
//  Created by Nhung Huynh on 7/25/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}
extension TweetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TweetDetailTableViewCell
        cell.tweet = self.tweet
        cell.delegate = self
        return cell
    }
}
extension TweetDetailViewController: TweetDetailDelegate {
    func replyAction(tweetCell: TweetDetailTableViewCell, didSet tweet: Tweet) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tweet.id, forKey: "TWEET_ID")
        defaults.setObject(tweet.screenname, forKey: "REPLY_NAME")
        defaults.synchronize()
        performSegueWithIdentifier("NewTweetSegue", sender: tweetCell)
    }
    func retweetAction(tweetCell: TweetDetailTableViewCell, didSet tweet: Tweet) {
        TwitterClient.sharedInstance.retweet(tweet.id, retweet: !tweet.retweeted, success: { (tweet) in
            self.tweet = tweet
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func starAction(tweetCell: TweetDetailTableViewCell, didSet tweet: Tweet) {
        TwitterClient.sharedInstance.handleStarTweet(tweet.id, isFavorited: !tweet.retweeted, success: { (tweet) in
            self.tweet = tweet
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}