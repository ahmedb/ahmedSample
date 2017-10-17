//
//  VideoTableViewController.swift
//  AhmedQuipper
//
//  Created by Ahmed Bakir on 2017/10/10.
//  Copyright © 2017 Ahmed Bakir. All rights reserved.
//

import UIKit
import SDWebImage
import FontAwesome_swift

/**
 The VideoTableViewController class manages the list of vidoes in the app and launches the video detail controller
 when a valid item is selected.
 */

class VideoTableViewController: UITableViewController {
    
    fileprivate var videoArray : [VideoItem]?

    override func viewDidLoad() {
        super.viewDidLoad()

        //Show a cool iOS11-style navigation bar, if available on the target device
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
        self.title = NSLocalizedString("Playlist", comment: "This is the playlist title string")
        
        //Enable Pull-To-Refresh in the table
        self.refreshControl?.addTarget(self, action: #selector(refreshTable), for: UIControlEvents.valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        forcePortraitOrientation()
        
        refreshTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     The forcePortraitOrientation method sets the orientation of the device to portrait mode
     */
    func forcePortraitOrientation() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //If there are no videos, show the placeholder
        
        if let videos = self.videoArray {
            return max(1, videos.count)
        }
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        // If the video array has data, use it to load the table
        if let videoArray = self.videoArray, videoArray.count > 0 {
            
            cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifiers.videoCell, for: indexPath)
            
            if let videoCell = cell as? VideoTableViewCell {
                
                let videoItem = videoArray[indexPath.row]
                
                videoCell.titleLabel?.text = videoItem.title
                videoCell.descriptionLabel?.text = videoItem.descString
                videoCell.durationLabel?.text = videoItem.videoDurationString
                videoCell.presenterLabel?.text = videoItem.presenterName
                
                if let thumbnailUrlString = videoItem.thumbnailUrlString, let thumbnailUrl = URL(string: thumbnailUrlString) {
                    videoCell.thumbnailImageView?.sd_setShowActivityIndicatorView(true)
                    videoCell.thumbnailImageView?.sd_setIndicatorStyle(UIActivityIndicatorViewStyle.whiteLarge)
                    videoCell.thumbnailImageView?.sd_setImage(with: thumbnailUrl, placeholderImage: UIImage(named: ImageNames.placeholder))
                }
            
                cell = videoCell
            }
        } else {
            // Otherwise load the placeholder
            
             cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifiers.placeholderCell, for: indexPath)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StoryboardConstants.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let videoArray = self.videoArray, videoArray.count > 0 {
            if let videoUrlString = videoArray[indexPath.row].videoUrlString,
                let videoUrl = URL(string: videoUrlString),
                let playerViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardIdentifiers.videoDetailController) as? VideoDetailViewController {
                
                playerViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                
                self.present(playerViewController, animated: true, completion: {
                    playerViewController.initializePlayer(videoUrl: videoUrl)
                })
            }
        } else {
            //Do nothing, the placeholder has no action
        }
        
    }
    
    // MARK: Custom actions
    
    /**
     The refreshTable method is used to fetch the list of videos from the DataManager. When the method
     finishes executing, the completion handler is used to update the UI (display data or placeholder).
     */
    
    @objc func refreshTable() {
        DataManager.sharedManager.getVideos { [weak self](videos: [VideoItem]?, error: Error?) in
            
            DispatchQueue.main.async {
                
                //The error cases (no videos, invalid JSON) are handled by the placeholder cell
                if let error = error {
                    print(error.localizedDescription)
                }
                
                self?.videoArray = videos
                self?.tableView?.reloadData()
                self?.refreshControl?.endRefreshing()
            }
            
        }
    }

}
