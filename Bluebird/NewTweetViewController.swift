//
//  NewTweetViewController.swift
//  Bluebird
//
//  Created by Nhung Huynh on 7/24/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var newTweetTextfield: UITextView!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!

    @IBOutlet weak var tweetBarButton: UIBarButtonItem!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.image = UIImage(data: NSData(contentsOfURL: (User.currentUser?.profileUrl)!)!)
        countdownLabel.text = "140"
        initTextViewWithPlaceholder(newTweetTextfield, text: "What's happening?")
    }

    func initTextViewWithPlaceholder(textView: UITextView, text: String) {
        textView.text = text
        textView.textColor = UIColor.lightGrayColor()
        textView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Navigation
    @IBAction func onCancelBarButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

   
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if tweetBarButton === sender {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let tweetId = defaults.objectForKey("TWEET_ID") {
                
                TwitterClient.sharedInstance.replyTweet(tweetId as! String, status: self.newTweetTextfield.text!, success: { (tweet) in
                    self.tweet = tweet
                    }, failure: { (error) in
                        print(error)
                })
                defaults.setObject(nil, forKey: "TWEET_ID")
                defaults.setObject(nil, forKey: "REPLY_NAME")
                defaults.synchronize()
            } else {
                
                TwitterClient.sharedInstance.updateTweet(self.newTweetTextfield.text!, success: { (tweet) in
                    self.tweet = tweet
                }) { (error) in
                    print(error)
                }
            }
        }
    }

}
extension NewTweetViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = newTweetTextfield.text!.utf16.count + text.utf16.count - range.length
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        if updatedText.isEmpty {
            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGrayColor()
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            self.countdownLabel.text = "140"
            
        } else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = text
            textView.textColor = UIColor.blackColor()
            self.countdownLabel.text = "\(140 - 1)"
        } else{
            if newLength <= 140 {
                self.countdownLabel.text = "\(140 - newLength)"
                return true
            }
        }
        return false
    }
}
    