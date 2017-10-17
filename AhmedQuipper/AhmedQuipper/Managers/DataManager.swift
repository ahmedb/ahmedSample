//
//  DataManager.swift
//  AhmedQuipper
//
//  Created by Ahmed Bakir on 2017/10/10.
//  Copyright © 2017 Ahmed Bakir. All rights reserved.
//

import Foundation

/**
 The DataManager class is in charge of retrieving data from the store for the application. To ease the transtion to a
 sensitive, shared store (like CoreData), this class is instantiated as a singleton.
 */

class DataManager {
    
    static let sharedManager = DataManager()
    
    /**
     The getVideos method calls the data source for the videos (memory store, core data, network API)
     and returns an array of VideoItems. If there is an error accessing the data source, the Error
     object is non-nil. We do not know how long this method will take to execute, so it is best for it to
     be asynchronous.
     
     - Parameter completion: A completion handler specifying an optional list of VideoItems and error object

     */
    
    func getVideos(completion : @escaping ([VideoItem]?, Error? ) -> Void) {
        
        NetworkManager.sharedManager.getJsonArray(urlString: ContentUrlStrings.videoFeed) { [weak self] (resultArray: [AnyObject]?, error: Error?) in
            
            if let error = error {
                completion([VideoItem](), error)
            } else {
                if let results = resultArray {
                    completion(self?.processJsonVideoArray(inputArray: results), nil)
                }
            }
            
        }
    }
    
    /**
     The processJsonVideoArray methods consumes a valid array of Swift objects and serializes them into
     VideoItems. Invalid fields are not serialized.
     
     - Parameter inputArray: An array of valid objects
     
     - Returns: VideoItems: An optional array of VideoItems
     */
    func processJsonVideoArray(inputArray: [AnyObject]) -> [VideoItem]? {
        
        var outputArray = [VideoItem]()
        
        for jsonItem in inputArray {
            var videoItem = VideoItem()
            if let duration = jsonItem[VideoFeedKeys.videoDuration] as? Int64 {
                videoItem.videoDuration = duration
            }
            
            if let presenterName = jsonItem[VideoFeedKeys.presenterName] as? String {
                videoItem.presenterName = presenterName
            }
            
            if let title = jsonItem[VideoFeedKeys.title] as? String {
                videoItem.title = title
            }
            
            if let thumbnailUrlString = jsonItem[VideoFeedKeys.thumbnailUrl] as? String {
                videoItem.thumbnailUrlString = thumbnailUrlString
            }
            
            if let description = jsonItem[VideoFeedKeys.description] as? String {
                videoItem.descString = description
            }
            
            if let videoUrlString = jsonItem[VideoFeedKeys.videoUrl] as? String {
                videoItem.videoUrlString = videoUrlString
            }
            
            outputArray.append(videoItem)
        }
        
        return outputArray
    }
}
