//
//  TableViewCell.swift
//  Bluebird
//
//  Created by Nhung Huynh on 7/23/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetDelegate {
    optional func replyAction(tweetCell: TweetTableViewCell, didSet tweet:Tweet)
    optional func retweetAction(tweetCell: TweetTableViewCell, didSet tweet:Tweet)
    optional func starAction(tweetCell: TweetTableViewCell, didSet tweet:Tweet)
    
}
class TweetTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImage: UIImageView!
//    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var textMsgLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var retweetOutletBtn: UIButton!
    
    @IBOutlet weak var starOutletBtn: UIButton!
    
    @IBOutlet weak var replyOutletBtn: UIButton!
    
    var delegate: TweetDelegate?
    var tweet: Tweet! {
        didSet {
            if tweet.profileImgUrl != nil {
                avatarImage.alpha = 1.0
                avatarImage.setImageWithURL(tweet.profileImgUrl!)
            } else {
                self.avatarImage.image = UIImage(named: "noImage")
            }
            self.usernameLabel.text = tweet.username
            self.screennameLabel.text = "@ \(tweet.screenname!)"
            self.textMsgLabel.text = tweet.text
            
            if let timeAgo: String = AppHelper.timeAgoSinceDate(tweet.timestamp!, numericDates: true) {
                self.timerLabel.text = timeAgo
            }
            
            print("retweet: \(tweet.retweeted) and favorited: \(tweet.favorited)")
            retweetOutletBtn.tintColor = tweet.retweeted ? UIColor(red: 31.0/255.0, green:
                134.0/255.0, blue: 212.0/255.0, alpha: 1.0): UIColor.grayColor()
            starOutletBtn.tintColor = tweet.favorited ? UIColor(red: 31.0/255.0, green:
                134.0/255.0, blue: 212.0/255.0, alpha: 1.0) : UIColor.grayColor()
            replyOutletBtn.tintColor = UIColor.grayColor()
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onReplyButton(sender: UIButton) {
        delegate?.replyAction?(self, didSet: tweet)
    }
    
    @IBAction func onRetweetButton(sender: UIButton) {
        delegate?.retweetAction?(self, didSet: tweet)
    }
    
    @IBAction func onStarButton(sender: UIButton) {
        delegate?.starAction?(self, didSet: tweet)
    }
    
    
}


