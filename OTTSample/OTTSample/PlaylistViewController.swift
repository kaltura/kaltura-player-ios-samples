//
//  PlaylistViewController.swift
//  OTTSample
//
//  Created by Nilit Danan on 30/12/2021.
//  Copyright © 2021 Kaltura Inc. All rights reserved.
//

import Foundation
import KalturaPlayer
import PlayKit_IMA
import PlayKit
import UIKit

class PlaylistViewController: UIViewController, MediasView {
    
    @IBOutlet weak var mediaPlayer: KPMediaPlayer!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var autoPlayNextButton: UIButton!
    
    @IBOutlet weak var upNextView: UIView!
    @IBOutlet weak var upNextDurationLabel: UILabel!
    
    var kalturaOTTPlayer: KalturaOTTPlayer! // Created in the viewDidLoad

    var videos: [VideoData] = []
    var videoDataType: MenuItem = .basic
    
    var countdownTimer: Timer?
    var runCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upNextView.isHidden = true
        
        switch videoDataType {
        case .basic:
            videos = VideoData.getBasicVideos()
        case .ima:
            videos = VideoData.getIMAVideos()
        case .imaDAI:
            videos = VideoData.getIMADAIVideos()
        case .youbora:
            videos = VideoData.getYouboraVideos()
        case .youboraIMA:
            videos = VideoData.getYouboraIMAVideos()
        case .youboraIMADAI:
            videos = VideoData.getYouboraIMADAIVideos()
        case .offline:
            // Currently isn't implemented
            break
        }
        
        let ottPlayerOptions = playerOptions(videos.first)
        kalturaOTTPlayer = KalturaOTTPlayer(options: ottPlayerOptions)
        mediaPlayer.player = kalturaOTTPlayer
        mediaPlayer.delegate = self
        
        kalturaOTTPlayer.loadPlaylist(options: mediaOptions(from: videos)) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let playlistController = self.kalturaOTTPlayer.playlistController
                playlistController?.delegate = self
                playlistController?.autoContinue = true
                playlistController?.recoverOnError = true
                playlistController?.preloadTime = 120
                
                self.registerPlaylistControllerEvents()
                
                DispatchQueue.main.async {
                    self.autoPlayNextButton.isSelected = playlistController?.autoContinue ?? false
                    self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
                }
                
                if !self.kalturaOTTPlayer.isPlaying {
                    NSLog("Nilit: loadPlaylist playItem")
                    self.kalturaOTTPlayer.playlistController?.playItem(index: 0)
                }
            }
        }
        
        initBGSession()
    }
    
    deinit {
        deinitBGSession()
        kalturaOTTPlayer.removeObserver(self, events: KPPlaylistEvent.allEventTypes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        if !kalturaOTTPlayer.isPlaying {
            NSLog("Nilit: viewWillAppear playItem")
            kalturaOTTPlayer.playlistController?.playItem(index: 0)
        }
    }
    
    // MARK: - Private Methods
    
    func playerOptions(_ videoData: VideoData?) -> PlayerOptions {
        let playerOptions = PlayerOptions()
        
        if let playerKS = videoData?.player.ks {
            playerOptions.ks = playerKS
        }
        
        // AutoPlay and Preload on player options is not used - Ignoring

        if let pluginConfig = videoData?.player.pluginConfig {
            if let imaConfig = pluginConfig.config[IMAPlugin.pluginName] as? IMAConfig {
                imaConfig.videoControlsOverlays = mediaPlayer.videoControlsOverlays()
            }
            playerOptions.pluginConfig = pluginConfig
        }
        
        return playerOptions
    }
    
    func mediaOptions(from videos: [VideoData]) -> [OTTMediaOptions] {
        var mediaOptions: [OTTMediaOptions] = []
        
        for videoData in videos {
            mediaOptions.append(videoData.media.mediaOptions())
        }
        
        return mediaOptions
    }
    
    func registerPlaylistControllerEvents() {
        kalturaOTTPlayer.addObserver(self, events: [PlaylistEvent.playlistCurrentPlayingItemChanged]) { [weak self] event in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let currentMediaIndex = self.kalturaOTTPlayer.playlistController?.currentMediaIndex {
                    self.tableView.selectRow(at: IndexPath(row: currentMediaIndex, section: 0),
                                             animated: true,
                                             scrollPosition: .middle)
                }
            }
        }
        
        kalturaOTTPlayer.addObserver(self, events: [PlaylistEvent.playlistCountdownStart, PlaylistEvent.playlistCountdownEnd]) { [weak self] event in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch event {
                case is PlaylistEvent.PlaylistCountdownStart:
                    guard let countdownDuration = event.duration else {
                        self.kalturaOTTPlayer.playlistController?.disableCountdownForCurrentItem()
                        return
                    }
                    self.runCount = countdownDuration.intValue
                    self.upNextDurationLabel.text = self.runCount.description
                    self.showUpNextView(true, animated: true)
                    
                    self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                        guard let self = self else { return }
                        
                        DispatchQueue.main.async {
                            self.runCount -= 1
                            self.upNextDurationLabel.text = self.runCount.description
                            
                            if self.runCount <= 0 {
                                self.countdownTimer?.invalidate()
                            }
                        }
                    }
                case is PlaylistEvent.PlaylistCountdownEnd:
                    self.showUpNextView(false, animated: true)
                    self.countdownTimer?.invalidate()
                default: break
                }
            }
        }
        
        kalturaOTTPlayer.addObserver(self, events: [PlaylistEvent.playlistLoadMediaError, PlaylistEvent.playlistError]) { [weak self] event in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: event.error?.description, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func showUpNextView(_ show: Bool, animated: Bool) {
        UIView.transition(with: self.upNextView, duration: animated ? 0.5 : 0,
                          options: .transitionCrossDissolve,
                          animations: {
            self.upNextView.isHidden = !show
        })
    }
}

// MARK: -

extension PlaylistViewController {
    // MARK: IBAction
    
    @IBAction func playNextButtonClicked(_ sender: UIButton) {
        kalturaOTTPlayer.playlistController?.playNext()
    }
    
    @IBAction func playPrevButtonClicked(_ sender: UIButton) {
        kalturaOTTPlayer.playlistController?.playPrev()
    }
    
    @IBAction func repeatButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        kalturaOTTPlayer.playlistController?.loop = sender.isSelected
    }
    
    @IBAction func shuffleButtonClicked(_ sender: UIButton) {
        // Currently not implemented
    }
    
    @IBAction func autoPlayNextButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        kalturaOTTPlayer.playlistController?.autoContinue = sender.isSelected
    }
    
    @IBAction func preloadNextButtonClicked(_ sender: UIButton) {
        kalturaOTTPlayer.playlistController?.preloadNext()
    }
    
    @IBAction func skipUpNextButtonClicked(_ sender: UIButton) {
        showUpNextView(false, animated: false)
        countdownTimer?.invalidate()
        kalturaOTTPlayer.playlistController?.disableCountdownForCurrentItem()
    }
}

// MARK: -

extension PlaylistViewController: KPMediaPlayerDelegate {
    // MARK: KPMediaPlayerDelegate
 
    func closeButtonClicked(onMediaPlayer mediaPlayer: KPMediaPlayer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func errorOccurred(_ error: NSError?, onMediaPlayer mediaPlayer: KPMediaPlayer) {
        let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: -

extension PlaylistViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIMediaTableViewCell", for: indexPath) as! MediaTableViewCell
        
        cell.videoData = videos[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        kalturaOTTPlayer.playlistController?.playItem(index: indexPath.row)
    }
}

// MARK: -

extension PlaylistViewController: PlaylistControllerDelegate {
    // MARK: PlaylistControllerDelegate
    
    func playlistController(_ controller: PlaylistController, updatePluginConfigForMediaEntry mediaEntry: PKMediaEntry, atIndex mediaItemIndex: Int) -> Bool {
        return true
    }
    
    func playlistController(_ controller: PlaylistController, pluginConfigForMediaEntry mediaEntry: PKMediaEntry, atIndex mediaItemIndex: Int) -> PluginConfig? {
        let videoData = videos[mediaItemIndex]
        if let pluginConfig = videoData.player.pluginConfig {
            if let imaConfig = pluginConfig.config[IMAPlugin.pluginName] as? IMAConfig {
                imaConfig.videoControlsOverlays = mediaPlayer.videoControlsOverlays()
            }
            return pluginConfig
        }
        return nil
    }
    
    func playlistController(_ controller: PlaylistController, enableCountdownForMediaEntry mediaEntry: PKMediaEntry, atIndex mediaItemIndex: Int) -> Bool {
        
        let mediaType = mediaEntry.mediaType
        
        if mediaType == .dvrLive || mediaType == .live {
            return false
        }
        
        return true
    }
    
    func playlistController(_ controller: PlaylistController, countdownOptionsForMediaEntry mediaEntry: PKMediaEntry, atIndex mediaItemIndex: Int) -> CountdownOptions? {
        if let playlistCountdownOptions = videos[mediaItemIndex].playlistCountdownOptions {
            return playlistCountdownOptions
        } else {
            // Use default
            return CountdownOptions()
        }
    }
}
