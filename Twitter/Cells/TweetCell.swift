//
//  TweetCell.swift
//  Twitter
//
//  Created by Kay Lab on 4/22/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
    var videoStrURL: String!
    var favorited: Bool = false
    var retweeted: Bool!
    var tweetId: Int!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 30
    }
    
    @IBAction func retweetButton(_ sender: UIButton) {
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        print(favorited)
        if (favorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                
                self.setFavorited(false)
                
            }, failure: { (Error) in
                print(Error)
                self.setFavorited(false)

            })
        } else {
            
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
    
                self.setFavorited(true)
                
            }, failure: { (Error) in
                print(Error)
                self.setFavorited(true)
            })
        }
            
    }
    
    func setFavorited(_ isFavorited: Bool){
        if (isFavorited){
            favoriteButton.setImage(UIImage(named: "redLike"), for: UIControl.State.normal)
            favorited = true
        } else {
            favoriteButton.setImage(UIImage(named: "greyLike"), for: UIControl.State.normal)
            favorited = false
        }
        
        print(isFavorited)
        print()
    }

    
}
