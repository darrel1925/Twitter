//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Kay Lab on 4/21/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage
import AVFoundation

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [Tweet]()
    var tweetDictArr = [[String: Any]]()
    var numberOfTweets: Int!

    let myRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self = this screen | what do you want to happen |
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        // tells the table view which refresh control to use
        tableView.refreshControl = myRefreshControl
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    
    @objc func loadTweets() {
        let tweetsURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = 5

        let myParams = ["count": numberOfTweets] as [String:Any]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetDictArr = tweets as! [[String: Any]]
            self.tweetArray.removeAll()
            
            for tweet in tweets {
                
                //print(tweet)
                //print(t.keys)
                
                let user = tweet["user"] as! [String: Any]
                let name = user["name"] as! String
                let tweetContent = tweet["text"] as! String
                let handleName = "@\(user["screen_name"]!)"
                let retweetCount = String(tweet["retweet_count"] as! Int)
                let favoriteCount = String(tweet["favorite_count"] as! Int)
                let isFavorited = tweet["favorited"] as! Bool
                let tweetId = tweet["id"] as! Int
                let retweeted = tweet["retweeted"] as! Bool
                let profileUrlString = user["profile_image_url_https"] as! String
                let profileUrl = URL(string: profileUrlString)!
                
                var tweetObj = Tweet(user: user,
                                     userName: name,
                                     tweetContent: tweetContent,
                                     handleName: handleName,
                                     retweetCount: retweetCount,
                                     favoriteCount: favoriteCount,
                                     tweetId: tweetId,
                                     retweeted: retweeted,
                                     isFavorited: isFavorited,
                                     media: [Any](),
                                     mediaType: " ",
                                     imageUrlString: " ",
                                     profileUrl: profileUrl)
                
                tweetObj.imageUrlString = tweetObj.getImageUrl(tweet: tweet as! [String : Any])
                tweetObj.mediaType = tweetObj.getMediaType(tweet:  tweet as! [String : Any])
                tweetObj.media = tweetObj.getMedia(tweet: tweet as! [String : Any])
                self.tweetArray.append(tweetObj)
                
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            let title  = Error.localizedDescription
            let message = "Unable to load tweets. Please check your network connection and try again"
            self.createAlert(title: title, message: message)
            print("Could not load Tweets")
        })
        
    }
    
    func loadMoreTweets() {
        let tweetsURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets += 5
        let myParams = ["count": numberOfTweets] as [String:Any]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetDictArr = tweets as! [[String: Any]]
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                
                
                let user = tweet["user"] as! [String: Any]
                let name = user["name"] as! String
                let tweetContent = tweet["text"] as! String
                let handleName = "@\(user["screen_name"]!)"
                let retweetCount = String(tweet["retweet_count"] as! Int)
                let favoriteCount = String(tweet["favorite_count"] as! Int)
                let retweeted = tweet["retweeted"] as! Bool
                let isFavorited = tweet["favorited"] as! Bool
                let tweetId = tweet["id"] as! Int

                let profileUrlString = user["profile_image_url_https"] as! String
                let profileUrl = URL(string: profileUrlString)!
                
                var tweetObj = Tweet(user: user,
                                     userName: name,
                                     tweetContent: tweetContent,
                                     handleName: handleName,
                                     retweetCount: retweetCount,
                                     favoriteCount: favoriteCount,
                                     tweetId: tweetId,
                                     retweeted: retweeted,
                                     isFavorited: isFavorited,
                                     media: [Any](),
                                     mediaType: " ",
                                     imageUrlString: " ",
                                     profileUrl: profileUrl)
                
                tweetObj.imageUrlString = tweetObj.getImageUrl(tweet: tweet as! [String : Any])
                tweetObj.mediaType = tweetObj.getMediaType(tweet:  tweet as! [String : Any])
                tweetObj.media = tweetObj.getMedia(tweet: tweet as! [String : Any])
                self.tweetArray.append(tweetObj)
                
                
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not load Tweets")
            print(Error)
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let tweet = tweetArray[indexPath.row]
        let user = tweet.user
        
        cell.userNameLabel.text = tweet.userName
        cell.tweetContentLabel.text = tweet.tweetContent
        cell.handleLabel.text = tweet.handleName
        cell.retweetCountLabel.text = tweet.retweetCount
        cell.favoriteCountLabel.text = String(tweet.favoriteCount)
        cell.retweeted = tweet.retweeted
        
        print("favorite Count \(tweet.favoriteCount)")
        
        cell.setFavorited(tweet.isFavorited)
        //cell.setRetweeted(tweet.isFavorited) 
        cell.tweetId = tweet.tweetId
        
//        print(tweet.imageUrlString)
        print(tweet.mediaType)
        
        if tweet.mediaType == "video"{
            
            cell.mediaView.isHidden = false
            cell.pictureView.isHidden = true
            cell.mediaView.frame.size.height = 240
            cell.pictureView.frame.size.height = 0
            
            let videoUrl = URL(string: tweet.imageUrlString)
            cell.player = AVPlayer(url: videoUrl!)
            
            cell.avPlayerLayer = AVPlayerLayer(player: cell.player)
            cell.avPlayerLayer.videoGravity = AVLayerVideoGravity.resize
            cell.mediaView.layer.addSublayer(cell.avPlayerLayer)
            cell.avPlayerLayer.frame = cell.mediaView.layer.bounds
            

        } else if tweet.mediaType == "photo" {
            let photoUrlString = tweet.getThumNail(media: tweet.media as! [[String : Any]])
            
            cell.mediaView.isHidden = true
            cell.pictureView.isHidden = false
            cell.mediaView.frame.size.height = 0
            cell.pictureView.frame.size.height = 300

            let photoUrl = URL(string: photoUrlString)!
            cell.pictureView.af_setImage(withURL: photoUrl)
            
        } else {
            
            // change the size of the imageView
            cell.mediaView.isHidden = true
            cell.pictureView.isHidden = true
            cell.mediaView.frame.size.height = 0
            cell.pictureView.frame.size.height = 0
            
        }
        let urlString = user["profile_image_url_https"] as! String
        let url = URL(string: urlString)
        cell.profileImage.af_setImage(withURL: url!)
        
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetArray.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (tweetArray[indexPath.row].mediaType == "video") {
        
            if let cell = tableView.cellForRow(at: indexPath) as? TweetCell{
            cell.player.play()
            print(cell.player.timeControlStatus.rawValue)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tweetArray[indexPath.row].mediaType == "video"  || tweetArray[indexPath.row].mediaType == "photo" {
            
            return 383
        }
        return 150
    }
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            print("done")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAlertWithAction(title: String) {

        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        // LOGOUT
        alert.addAction(UIAlertAction(title: "Logout", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            TwitterAPICaller.client?.logout()
            UserDefaults.standard.set(false, forKey: "userLoggedIn")
            // dismiss twitter homepage
            self.dismiss(animated: true, completion: nil)
            //dismiss alert
            alert.dismiss(animated: true, completion: nil)
        }))
        // STAY LOGGED IN
        alert.addAction(UIAlertAction(title: "Go Back", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        // present alert
        self.present(alert, animated: true , completion: nil)
    }

    @IBAction func onLogOut(_ sender: UIBarButtonItem) {
        createAlertWithAction(title: "Would you like to Logout?")
    }
    

}
