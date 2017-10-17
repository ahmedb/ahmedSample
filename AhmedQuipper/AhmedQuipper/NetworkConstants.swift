//
//  NetworkConstants.swift
//  AhmedQuipper
//
//  Created by Ahmed Bakir on 2017/10/10.
//  Copyright © 2017 Ahmed Bakir. All rights reserved.
//

import Foundation

//This file contains constants (key's, url's) which are used frequently for network functions throughout the app

struct SessionConstants {
    static var sessionIdentifier = "AhmedQuipperBackgroundSession"
}

struct ContentUrlStrings {
    static var videoFeed = "https://gist.githubusercontent.com/sa2dai/04da5a56718b52348fbe05e11e70515c/raw/c7bb2472537f4527f9640e456eee3337139f7656/code_test_iOS.json"
}

struct VideoFeedKeys {
    static var title = "title"
    static var presenterName = "presenter_name"
    static var description = "description"
    static var thumbnailUrl = "thumbnail_url"
    static var videoUrl = "video_url"
    static var videoDuration = "video_duration"
}
