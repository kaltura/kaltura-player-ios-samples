//
//  PKMediaPlayerViewController.swift
//  OVPSample
//
//  Created by Nilit Danan on 8/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit
import KalturaPlayer
import PlayKit_IMA

class KPMediaPlayerViewController: UIViewController, PlayerViewController {
    
    var kalturaOVPPlayer: KalturaOVPPlayer! // Created in the viewDidLoad
    
    var videoData: VideoData? {
        didSet {
            if viewIfLoaded != nil, let videoData = self.videoData {
                kalturaOVPPlayer.stop()
                
                shouldPreparePlayer = true
                
                // Update only; do not override the player options.
                let ovpPlayerOptions = playerOptions(videoData)
                if let playerKS = ovpPlayerOptions.ks {
                    kalturaOVPPlayer.updatePlayerOptionsKS(playerKS)
                }
                for pluginConfig in ovpPlayerOptions.pluginConfig.config {
                    kalturaOVPPlayer.updatePluginConfig(pluginName: pluginConfig.key, config: pluginConfig.value)
                }
            }
        }
    }
    
    var shouldPlayLocally: Bool = false
    private var shouldPreparePlayer: Bool = true
    
    @IBOutlet weak var mediaPlayer: KPMediaPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ovpPlayerOptions = playerOptions(videoData)
        kalturaOVPPlayer = KalturaOVPPlayer(options: ovpPlayerOptions)
        mediaPlayer.player = kalturaOVPPlayer
        mediaPlayer.delegate = self
        
        initBGSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let videoData = self.videoData else { return }
        
        if shouldPreparePlayer {
            shouldPreparePlayer = false
            
            let mediaOptions = videoData.media.mediaOptions()
            
            if shouldPlayLocally {
                if let localMediaEntry = OfflineManager.shared.getLocalPlaybackEntry(assetId: videoData.media.entryId) {
                    kalturaOVPPlayer.setMedia(localMediaEntry, options: mediaOptions)
                    
                    // If the autoPlay and preload was set to false, prepare will not be called automatically
                    if videoData.player.autoPlay == false && videoData.player.preload == false {
                        self.kalturaOVPPlayer.prepare()
                    }
                } else {
                    let alert = UIAlertController(title: "Local Playback", message: "The local media was not retrieved.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alert) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                kalturaOVPPlayer.loadMedia(options: mediaOptions) { [weak self] (error) in
                    guard let self = self else { return }
                    if let error = error {
                        let message = error.localizedDescription

                        let alert = UIAlertController(title: "Media not loaded", message: message, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        // If the autoPlay and preload was set to false, prepare will not be called automatically
                        if videoData.player.autoPlay == false && videoData.player.preload == false {
                            self.kalturaOVPPlayer.prepare()
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if videoData == nil {
            let alert = UIAlertController(title: "Video Data Empty", message: "Can't load the Player without the video data.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if kalturaOVPPlayer.isPlaying {
            kalturaOVPPlayer.pause()
        }
    }
    
    deinit {
        deinitBGSession()
        kalturaOVPPlayer.destroy()
        kalturaOVPPlayer = nil
    }
    
    // MARK: - Private Methods
    
    func playerOptions(_ videoData: VideoData?) -> PlayerOptions {
        let playerOptions = PlayerOptions()
        
        if let playerKS = videoData?.player.ks {
            playerOptions.ks = playerKS
        }
        if let autoPlay = videoData?.player.autoPlay {
            playerOptions.autoPlay = autoPlay
        }
        if let preload = videoData?.player.preload {
            playerOptions.preload = preload
        }
        if let pluginConfig = videoData?.player.pluginConfig {
            if let imaConfig = pluginConfig.config[IMAPlugin.pluginName] as? IMAConfig {
                imaConfig.videoControlsOverlays = mediaPlayer.videoControlsOverlays()
            }
            playerOptions.pluginConfig = pluginConfig
        }
        
        return playerOptions
    }
}

// MARK: - KPMediaPlayerDelegate

extension KPMediaPlayerViewController: KPMediaPlayerDelegate {
 
    func closeButtonClicked(onMediaPlayer mediaPlayer: KPMediaPlayer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func errorOccurred(_ error: NSError?, onMediaPlayer mediaPlayer: KPMediaPlayer) {
        let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
