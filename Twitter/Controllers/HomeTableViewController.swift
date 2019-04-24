//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Kay Lab on 4/21/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [[String: Any]]()
    var numberOfTweets: Int!
    
    let myRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        //self = this screen | what do you want to happen |
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        // tells the table view which refresh control to use
        tableView.refreshControl = myRefreshControl
        
    }
    
    @objc func loadTweets() {
        let tweetsURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweets = 20
//        let title = "Tweets loaded"
//        let message = "\(numberOfTweets!) tweets have been loaded"
        let myParams = ["count": numberOfTweets] as [String:Any]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            self.tweetArray = tweets as! [[String : Any]]
            
//            for tweet in self.tweetArray {
//                let t = tweet
//    //            let mediaDict = t["media"] as! [String: Any]
////                print(self.tweetArray)
////                print(self.tweetArray[15].keys)
////                print("\n\n")
////                print(t["entities"])
//                let entities = t["entities"] as! [String: Any]
////                print("\n\n")
////                print(entities.keys)
////                print(entities["urls"] as! NSArray)
//                let urls = (entities["urls"] as! [Any])
//                print(urls)
//                if urls.count > 0 {
//                    print("HERE")
//                    print(urls[0])
//                    let url1 = urls[0] as! [String: Any]
//                    print(url1["display_url"] as? String)
//                }
//            }
////            print(t["media"])
//
////            let displayUrl = mediaDict["display_url"]!
////            print(displayUrl)
////            self.createAlert(title: title, message: message)
            
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
        numberOfTweets += 20
        let myParams = ["count": numberOfTweets] as [String:Any]
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetsURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray = tweets as! [[String : Any]]
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not load Tweets")
            print(Error)
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        let user = tweetArray[indexPath.row]["user"] as! [String:Any]
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        cell.handleLabel.text = "@\(user["screen_name"]!)"
        cell.retweetCountLabel.text = String(tweetArray[indexPath.row]["retweet_count"] as! Int)
        cell.favoriteCountLabel.text = String(tweetArray[indexPath.row]["favorite_count"] as! Int)
        
        let imageUrl = getImageUrl(tweet: tweetArray[indexPath.row])
        print(imageUrl)
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
        // preset alert
        self.present(alert, animated: true , completion: nil)
    }
    
    func getImageUrl(tweet: [String:Any]) -> String {
    
        let t = tweet

        let entities = t["entities"] as! [String: Any]

        let urls = (entities["urls"] as! [Any])

        if urls.count > 0 {

            let url1 = urls[0] as! [String: Any]
            
            //print(url1)
            let urlString = url1["expanded_url"] as! String
            
            let imageUrl = URL(string: urlString)
            
//            print(urlString)
//            print(String(urlString.prefix(5)))
            
            if String(urlString.prefix(5)) == "https" {
                return urlString
            }
            //let request = URLRequest(url: imageUrl!)
        }
         return "_"
    }
        
    
    @IBAction func onLogOut(_ sender: UIBarButtonItem) {
        createAlertWithAction(title: "Would you like to Logout?")
    }
}























/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


