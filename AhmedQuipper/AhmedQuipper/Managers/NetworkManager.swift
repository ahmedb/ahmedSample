//
//  NetworkManager.swift
//  AhmedQuipper
//
//  Created by Ahmed Bakir on 2017/10/10.
//  Copyright © 2017 Ahmed Bakir. All rights reserved.
//

import Foundation

/**
 The NetworkManager class is in charge of network operations for the application. URL sessions are meant to be shared within an app, so this class is instantiated as a singleton.
 */

class NetworkManager : NSObject{
    
    static let sharedManager = NetworkManager()
    
    fileprivate var session : URLSession?
    
    override init() {
        
        super.init()
        session = URLSession(configuration: URLSessionConfiguration.default)
        
    }
    
    /**
     The getJsonArray method calls the specified URL and attempts convert the response (JSON data) to an array of
     Swift objects. If there is an error accessing the URL or serializing the JSON data, the Error object is non-nil.
     We do not know how long this method will take to execute, so it is best for it to be asynchronous.
     
     - Parameter: completion A completion handler specifying an optional list of Swift objects and error object
     
     */
    func getJsonArray( urlString: String, completion: @escaping ([AnyObject]?, Error? ) -> Void) {
        if let videoURL = URL(string: ContentUrlStrings.videoFeed) {
            
            let getVideoTask = session?.dataTask(with: videoURL, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                if let responseData = data {
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? [AnyObject] {
                            completion(jsonArray, nil)
                        }
                    } catch {
                        completion(nil, error)
                    }
                }
            })
            getVideoTask?.resume()
        }
    }
}
