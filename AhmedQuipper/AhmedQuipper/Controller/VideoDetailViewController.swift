//
//  VideoDetailViewController.swift
//  AhmedQuipper
//
//  Created by Ahmed Bakir on 2017/10/09.
//  Copyright © 2017 Ahmed Bakir. All rights reserved.
//

import UIKit
import AVKit
import FontAwesome_swift

/**
 The VideoDetailViewController class is in charge of the media player which plays videos in the app and
 its custom control UI.
 */

class VideoDetailViewController: UIViewController {
    
    @IBOutlet weak var navigationControlView : UIView?
    @IBOutlet weak var navigationControlBackgroundView : UIView?
    
    //We don't want to release the player, keep it STRONG (retained)
    @IBOutlet var playbackView : PlayerView?
    
    @IBOutlet weak var scrubberControlView : UIView?
    @IBOutlet weak var playbackControlView : UIView?
    
    @IBOutlet weak var closeButton : UIButton?
    @IBOutlet weak var playButton : UIButton?
    @IBOutlet weak var fastForwardButton : UIButton?
    @IBOutlet weak var rewindButton : UIButton?
    
    @IBOutlet weak var elapsedTimeLabel : UILabel?
    @IBOutlet weak var totalTimeLabel : UILabel?
    @IBOutlet weak var playbackScrubber : UISlider?
    
    fileprivate var timeObserverToken: Any?
    fileprivate var timeFormatter : DateComponentsFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initializeUI()
        
        //To save memory, share one Date Formatter
        timeFormatter = DateComponentsFormatter()
        timeFormatter?.zeroFormattingBehavior = .pad
        timeFormatter?.allowedUnits = [.hour, .minute, .second]

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //We don't need to track video progress anymore, let's save some CPU cycles and memory
        if let timeObserverToken = timeObserverToken {
            playbackView?.player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        //Stop video playback
        playbackView?.player?.pause()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set the preferred orientation of the ViewController to landscape
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    private func shouldAutorotate() -> Bool {
        return false
    }
    
    /**
     The initializeUI method takes care of the UI scaffolding tasks (adding effects, gesture recognizers)
     */
    func initializeUI() {
        
        forceLandscapeOrientation()
        
        self.navigationControlBackgroundView?.alpha = 0.8
        self.navigationControlBackgroundView?.layer.cornerRadius = 16.0
        self.navigationControlBackgroundView?.layer.masksToBounds = true
        
        self.playButton?.titleLabel?.font = UIFont.fontAwesome(ofSize: StoryboardConstants.playButtonSize)
        self.playButton?.setTitle(String.fontAwesomeIcon(name: .playCircle), for: .normal)
        
        self.fastForwardButton?.titleLabel?.font = UIFont.fontAwesome(ofSize: StoryboardConstants.scrubButtonSize)
        self.fastForwardButton?.setTitle(String.fontAwesomeIcon(name: .fastForward), for: .normal)
        
        self.rewindButton?.titleLabel?.font = UIFont.fontAwesome(ofSize: StoryboardConstants.scrubButtonSize)
        self.rewindButton?.setTitle(String.fontAwesomeIcon(name: .fastBackward), for: .normal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.togglePlaybackControls))
        self.playbackView?.addGestureRecognizer(tapGesture)
        
    }
    
    /**
     The initializePlayer method creates the AVPlayer video playback object for the view controller
     and attaches it to the playbackView object. Since we need the outlet for the playbackView to be valid,
     as well as the controls, this method should be called after the ViewController has been setup (later than viewDidLoad)
     
     - Parameter: URL The valid URL object to initialize the AVPlayer with
     
     */
    func initializePlayer(videoUrl: URL) {
        
        if let playbackView = self.playbackView,
           let navigationControlView = self.navigationControlView,
           let playbackControlView = self.playbackControlView,
           let scrubberControlView = self.scrubberControlView {
            
            let player = AVPlayer(url: videoUrl)
            
            DispatchQueue.main.async { [weak self] in
                
                playbackView.playerLayer.player = player
                
                playbackView.bringSubview(toFront: navigationControlView)
                playbackView.bringSubview(toFront: scrubberControlView)
                playbackView.bringSubview(toFront: playbackControlView)

                self?.initializeObserverForPlayer(player: player)
                
                player.play()
                
            }
            
            togglePlaybackControls()
        }
    }
    
    /**
     The initializeObserverForPlayer method defines the periodicTimeObserver object and completion block
     to handle changes that should occur when the AVPlayer advances (UI updates). The periodicTimeObserver
     is a feature of AVPlayer to simplify monitoring playback time changes.
     
     - Parameter: player The valid AVPlayer object to monitor for changes in playback time

     */
    
    func initializeObserverForPlayer(player: AVPlayer) {
        
        //observer for when playback advances by a second
        
        let interval = CMTimeMake(1, 1)
        
        self.timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (time: CMTime) in
            
            let timeElapsed = Float(CMTimeGetSeconds(time))
            let timeString = self?.timeFormatter?.string(from: TimeInterval(timeElapsed))
            self?.elapsedTimeLabel?.text = timeString
            
            if let duration = player.currentItem?.duration {
                let totalTime = Float(CMTimeGetSeconds(duration))
                let timeString = self?.timeFormatter?.string(from: TimeInterval(totalTime))
                self?.totalTimeLabel?.text = timeString
                
                let progress = timeElapsed / totalTime
                
                self?.playbackScrubber?.setValue(progress, animated: true)

            }
        })
    }
    
    /**
     The forceLandscapeOrientation method sets the orientation of the device to landscape mode
     */
    func forceLandscapeOrientation() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    /**
     The updatePlaybackButtonState method updates the control UI based on the playback status of the video (play/pause icon)
     */
    func updatePlaybackButtonState() {
        if let player = self.playbackView?.player {
            //If the rate is greater than 0, video is playing
            if player.rate > 0 {
                self.playButton?.setTitle(String.fontAwesomeIcon(name: .pauseCircle), for: .normal)
            } else {
                self.playButton?.setTitle(String.fontAwesomeIcon(name: .playCircle), for: .normal)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Playback Actions
    
    /**
     The togglePlaybackControls method shows or hides the playback controls (play button, fast forward, rewind button)
     */
    
    @objc func togglePlaybackControls() {
        
        DispatchQueue.main.async { [weak self] in
            if let playbackControlView = self?.playbackControlView {
                if playbackControlView.alpha == 1.0 {
                    UIView.animate(withDuration: 1.0, animations: {
                        playbackControlView.alpha = 0.0
                    })
                } else {
                    playbackControlView.alpha = 1.0
                }
                self?.updatePlaybackButtonState()
            }
        }
    }
    
    /**
     The togglePlayback method resumes or pauses video based on the current state of the media player.
     */
    @IBAction func togglePlayback() {
        if let player = self.playbackView?.player {
            if player.rate > 0 {
                player.pause()
                self.playButton?.setTitle(String.fontAwesomeIcon(name: .playCircle), for: .normal)
            } else {
                player.play()
                self.playButton?.setTitle(String.fontAwesomeIcon(name: .pauseCircle), for: .normal)
                togglePlaybackControls()
            }
        }
    }
    
    /**
     The fastForward method increases the speed of playback of videos to 2x while it is held down. This allows
     the user to skip forward easily
     */
    @IBAction func fastForward() {
        if let player = self.playbackView?.player {
            if player.currentItem?.status == AVPlayerItemStatus.readyToPlay {
                player.rate = 2.0
            }
        }
    }
    
    /**
     The rewind method decreases the speed of playback of videos to -2x while it is held down. This allows
     the user to skip backward easily
     */
    @IBAction func rewind() {
        if let player = self.playbackView?.player {
            if player.currentItem?.status == AVPlayerItemStatus.readyToPlay {
                player.rate = -2.0
            }
        }
    }
    
    /**
     The resetTracking method resets the speed of playback of videos to 1x after the fast forward or rewind buttons are released.
     */
    @IBAction func resetTracking() {
        if let player = self.playbackView?.player {
            if player.currentItem?.status == AVPlayerItemStatus.readyToPlay {
                player.rate = 1.0
            }
            togglePlaybackControls()
        }
    }
    
    /**
     The sliderChanged method allows the user to quickly scrub (skip) to a position in the video by
     changing its position visually.
     
     - Parameter: sender: The UISlider object to monitor for changes
     */
    @IBAction func sliderChanged(sender: UISlider?) {
        
        if let player = self.playbackView?.player,
           let currentItem = player.currentItem,
           let slider = sender  {
           if currentItem.status == AVPlayerItemStatus.readyToPlay {
            
            let desiredTime = CMTimeMultiplyByFloat64(currentItem.duration, Float64(slider.value))
                player.seek(to: desiredTime)
            }
        }
    }
    
    // MARK: - Navigation Actions
    
    /**
     The close method dismisses the ViewController.
     */
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }

}
