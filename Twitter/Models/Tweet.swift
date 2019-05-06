//
//  File.swift
//  Twitter
//
//  Created by Kay Lab on 4/30/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import Foundation

struct Tweet {
    let user: [String: Any]
    let userName: String
    let tweetContent: String
    let handleName: String
    let retweetCount: String
    let favoriteCount: String
    let tweetId: Int
    var retweeted: Bool
    var isFavorited: Bool
    var media: [Any]
    var mediaType: String
    var imageUrlString: String
    let profileUrl: URL
    
    
    func getImageUrl(tweet: [String:Any]) -> String {
        print(tweet)
        if let extended_entities = tweet["extended_entities"] as? [String: Any] {
            
            let media = extended_entities["media"] as! [Any]
            
            for item in media {
                let itemDict = item as! [String:Any]
                
                if itemDict["type"] as? String == "photo"{

                    return itemDict["url"] as! String   
                }
                
                if let video_info = itemDict["video_info"] as? [String: Any] {
                    
                    if let variants = video_info["variants"] as? [Any] {
                        
                        for media in variants{
                            let mediaDict = media as? [String: Any]
                            
                            if let video = mediaDict?["url"] {
                                
                                return video as! String
                            }
                            return "_"
                        }
                    }
                }
                return "_"
            }
        }

        return "_"
    }
    
    func getMediaType(tweet: [String:Any]) -> String {
        //        print(tweet)
        if let extended_entities = tweet["extended_entities"] as? [String: Any] {
            
            let media = extended_entities["media"] as! [Any]
            
            for item in media {
                let itemDict = item as! [String:Any]
                
                if let type = itemDict["type"] as? String {
                    return type
                } else  {
                    return "_"
                }
            }
        }
    return "_"
    }
    
    func getThumNail(media: [[String: Any]]) -> String{
            for item in media {
                    
                let itemDict = item
                let mediaUrl = itemDict["media_url_https"]
                
                return mediaUrl as! String
            }
        return "_"
    }
    
    func getMedia(tweet: [String: Any]) -> [Any] {
        if let extended_entities = tweet["extended_entities"] as? [String: Any] {
            
            let media = extended_entities["media"] as! [Any]
            
            return media
        }
        return []
    }
    
    
}
