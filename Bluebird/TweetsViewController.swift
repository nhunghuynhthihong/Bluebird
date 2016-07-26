//
//  TweetsViewController.swift
//  Bluebird
//
//  Created by Nhung Huynh on 7/22/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var myTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadHomeTimeline()
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadHomeTimeline()
        refreshControl.endRefreshing()
    }
    
    func loadHomeTimeline(){
        TwitterClient.sharedInstance.homeTimeline({ (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: UIBarButtonItem) {
        TwitterClient.sharedInstance.logout()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let nextVC = segue.destinationViewController as? TweetDetailViewController {
            let indexPath = tableView.indexPathForSelectedRow
            let currentTweet = tweets![indexPath!.row]
            nextVC.tweet = currentTweet
        }
    }
}
extension TweetsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TweetTableViewCell
        guard let _tweets = tweets else { return cell }
        cell.tweet = _tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
}
extension TweetsViewController: TweetDelegate {
    
    func replyAction(tweetCell: TweetTableViewCell, didSet tweet: Tweet) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tweet.id, forKey: "TWEET_ID")
        defaults.setObject(tweet.screenname, forKey: "REPLY_NAME")
        defaults.synchronize()
        performSegueWithIdentifier("NewTweetSegue", sender: tweetCell)
    }
    func retweetAction(tweetCell: TweetTableViewCell, didSet tweet: Tweet) {
        TwitterClient.sharedInstance.retweet(tweet.id, retweet: !tweet.retweeted, success: { (tweet) in
            self.loadHomeTimeline()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func starAction(tweetCell: TweetTableViewCell, didSet tweet: Tweet) {
        TwitterClient.sharedInstance.handleStarTweet(tweet.id, isFavorited: !tweet.retweeted, success: { (tweet) in
            self.loadHomeTimeline()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
extension TweetsViewController {
    @IBAction func unwindToTweets(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? NewTweetViewController, tweet = sourceViewController.tweet {
            // Add a new tweet.
            let newIndexPath = NSIndexPath(forRow: tweets!.count, inSection: 0)
            tweets?.append(tweet)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Top)
        }
    }
}

