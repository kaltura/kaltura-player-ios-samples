//
//  PKMediaPlayerViewController.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit
import KalturaPlayer
import PlayKit_IMA

class KPMediaPlayerViewController: UIViewController, PlayerViewController {
    
    var kalturaBasicPlayer: KalturaBasicPlayer! // Created in the viewDidLoad
    
    var videoData: VideoData? {
        didSet {
            if viewIfLoaded != nil, let videoData = self.videoData {
                kalturaBasicPlayer.stop()
                
                shouldPreparePlayer = true
                
                // Update only; do not override the player options.
                let basicPlayerOptions = playerOptions(videoData)
                if let playerKS = basicPlayerOptions.ks {
                    kalturaBasicPlayer.updatePlayerOptionsKS(playerKS)
                }
                for pluginConfig in basicPlayerOptions.pluginConfig.config {
                    kalturaBasicPlayer.updatePluginConfig(pluginName: pluginConfig.key, config: pluginConfig.value)
                }
            }
        }
    }
    
    var shouldPlayLocally: Bool = false
    private var shouldPreparePlayer: Bool = true
    
    @IBOutlet weak var mediaPlayer: KPMediaPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let basicPlayerOptions = playerOptions(videoData)
        kalturaBasicPlayer = KalturaBasicPlayer(options: basicPlayerOptions)
        mediaPlayer.player = kalturaBasicPlayer
        mediaPlayer.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let videoData = self.videoData else { return }
        
        if shouldPreparePlayer {
            shouldPreparePlayer = false
            
            var mediaOptions: MediaOptions? = nil
            if let startTime = videoData.startTime {
                mediaOptions = MediaOptions()
                mediaOptions?.startTime = startTime
            }
            
            if let mediaEntry = videoData.mediaEntry {
                if shouldPlayLocally {
                    if let localMediaEntry = OfflineManager.shared.getLocalPlaybackEntry(assetId: mediaEntry.id) {
                        kalturaBasicPlayer.setMedia(localMediaEntry, options: mediaOptions)
                    } else {
                        let alert = UIAlertController(title: "Local Playback", message: "The local media was not retrieved.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alert) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    kalturaBasicPlayer.setMedia(mediaEntry, options: mediaOptions)
                }
            } else if let freeFormMedia = videoData.freeFormMedia {
                guard let contentUrl = URL(string: freeFormMedia.contentUrl) else { return }
                kalturaBasicPlayer.setupMediaEntry(id: freeFormMedia.id, contentUrl: contentUrl, drmData: freeFormMedia.drmData, mediaFormat: freeFormMedia.mediaFormat, mediaType: freeFormMedia.mediaType, mediaOptions: mediaOptions)
            }
            
            // If the autoPlay and preload was set to false, prepare will not be called automatically
            if videoData.player.autoPlay == false && videoData.player.preload == false {
                kalturaBasicPlayer.prepare()
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

        if kalturaBasicPlayer.isPlaying {
            kalturaBasicPlayer.pause()
        }
    }
    
    deinit {
        kalturaBasicPlayer.destroy()
        kalturaBasicPlayer = nil
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
