//
//  VideoItem.swift
//  AhmedQuipper
//
//  Created by Ahmed Bakir on 2017/10/10.
//  Copyright © 2017 Ahmed Bakir. All rights reserved.
//

import Foundation

/**
 A VideoItem represents a video in the playlist, including title, presenter, URL's, and playback duration
 */


struct VideoItem {
    var title: String?
    var presenterName: String?
    var descString: String?
    var thumbnailUrlString : String?
    var videoUrlString: String?
    var videoDuration: Int64?
    
    /**
     The videoDurationString computed property takes the videoDuration member and converts it to a human-readable string indicating the length of the video.
     
     - Returns: A formatted string indicating the length of the video in a human-readable format (days, months, hours, minutes, and seconds)
     */
    var videoDurationString : String {
        
        var durationString = "--:--:--"
        
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.second, .minute, .hour, .day]
        
        if let duration = videoDuration, let formattedString = dateFormatter.string(from: TimeInterval(duration)) {
            durationString = formattedString
        }
        return durationString
    }
    
    /**
     The initializer allows us to create new VideoItems with optional members
     */
    init(title: String? = nil, presenterName: String? = nil, descString: String? = nil,
         thumbnailUrlString: String? = nil, videoUrlString: String? = nil, videoDuration: Int64? = nil) {
        self.title = title
        self.presenterName = presenterName
        self.descString = descString
        self.thumbnailUrlString = thumbnailUrlString
        self.videoUrlString = videoUrlString
        self.videoDuration = videoDuration        
    }
}
