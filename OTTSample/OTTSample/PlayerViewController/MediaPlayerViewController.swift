//
//  MediaPlayerViewController.swift
//  OTTSample
//
//  Created by Nilit Danan on 5/3/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit
import KalturaPlayer
import PlayKit_IMA
import PlayKit

class PPRButton: UIButton {
    enum PPRButtonState {
        case play
        case pause
        case replay
    }
    var displayState: PPRButtonState = .play {
        didSet {
            switch displayState {
            case .play:
                self.setImage(UIImage(named: "play"), for: .normal)
            case .pause:
                self.setImage(UIImage(named: "pause"), for: .normal)
            case .replay:
                self.setImage(UIImage(named: "reload"), for: .normal)
            }
        }
    }
}

class MediaPlayerViewController: UIViewController, PlayerViewController {
    
    var kalturaOTTPlayer: KalturaOTTPlayer! // Created in the viewDidLoad
    
    var videoData: VideoData? {
        didSet {
            if viewIfLoaded != nil, let videoData = self.videoData {
                kalturaOTTPlayer.stop()
                
                shouldPreparePlayer = true
                mediaProgressSlider.value = 0
                currentTimeLabel.text = "00:00:00"
                durationLabel.text = "00:00:00"
                audioTracks = nil
                textTracks = nil
                mediaEnded = false
                adsLoaded = false
                allAdsCompleted = false
                
                let ottPlayerOptions = playerOptions(videoData)
                kalturaOTTPlayer.updatePlayerOptions(ottPlayerOptions)
            }
        }
    }
    var shouldPlayLocally: Bool = false
    
    @IBOutlet weak var kalturaPlayerView: KalturaPlayerView!
    
    // We have to have the 'controllersInteractiveView' and set the tap guesture on it and not on the 'kalturaPlayerView' because IMA's ad view is above the player's view.
    @IBOutlet private weak var controllersInteractiveView: UIView!
    @IBOutlet private weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var topVisualEffectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var bottomVisualEffectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var middleVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var settingsVisualEffectView: UIVisualEffectView!
    private let topBottomVisualEffectViewHeight: Float = 50.0
    
    @IBOutlet private weak var playPauseButton: PPRButton!
    
    @IBOutlet private weak var mediaProgressSlider: UIPlayerSlider!
    private var userSeekInProgress: Bool = false {
        didSet {
            mediaProgressSlider.isEnabled = !self.userSeekInProgress
        }
    }
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var audioTracks: [KPTrack]?
    private var textTracks: [KPTrack]?
    
    private var shouldPreparePlayer: Bool = true
    
    private var mediaEnded: Bool = false
    private var adsLoaded: Bool = false
    private var allAdsCompleted: Bool = false
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(controllersInteractiveViewTapped))
        controllersInteractiveView.addGestureRecognizer(gesture)
        
        settingsVisualEffectView.alpha = 0.0
        middleVisualEffectView.layer.cornerRadius = 40.0
        playPauseButton.displayState = .play
        activityIndicator.layer.cornerRadius = 20.0
        
        let ottPlayerOptions = playerOptions(videoData)
        kalturaOTTPlayer = KalturaOTTPlayer(options: ottPlayerOptions)
        kalturaOTTPlayer.view = kalturaPlayerView
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.kalturaOTTPlayer.pause()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let videoData = self.videoData else { return }
        
        registerPlayerEvents()
        // IMA
        registerAdEvents()
        
        if shouldPreparePlayer {
            shouldPreparePlayer = false
            
            activityIndicator.startAnimating()
            
            let mediaOptions = videoData.media.mediaOptions()
            
//            if shouldPlayLocally {
//                if let localMediaEntry = OfflineManager.shared.getLocalPlaybackEntry(assetId: videoData.media.assetId) {
//                    kalturaOTTPlayer.setMedia(localMediaEntry, options: mediaOptions)
//
//                    // If the autoPlay and preload was set to false, prepare will not be called automatically
//                    if videoData.player.autoPlay == false && videoData.player.preload == false {
//                        self.kalturaOTTPlayer.prepare()
//                    }
//                } else {
//                    let alert = UIAlertController(title: "Local Playback", message: "The local media was not retrieved.", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alert) in
//                        self.dismiss(animated: true, completion: nil)
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                }
//            } else {
                kalturaOTTPlayer.loadMedia(options: mediaOptions) { [weak self] (error) in
                    guard let self = self else { return }
                    if error != nil {
                        let alert = UIAlertController(title: "Media not loaded", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        // If the autoPlay and preload was set to false, prepare will not be called automatically
                        if videoData.player.autoPlay == false && videoData.player.preload == false {
                            self.kalturaOTTPlayer.prepare()
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if !videoData.player.autoPlay {
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
//            }
            
            if videoData.player.autoPlay {
                playPauseButton.displayState = .pause
                showPlayerControllers(false)
            } else {
                playPauseButton.displayState = .play
                showPlayerControllers(true)
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

        if kalturaOTTPlayer.isPlaying {
            kalturaOTTPlayer.pause()
        }
        kalturaOTTPlayer.removeObserver(self, events: KPPlayerEvent.allEventTypes)
        // IMA
        kalturaOTTPlayer.removeObserver(self, events: KPAdEvent.allEventTypes)
    }
    
    deinit {
        kalturaOTTPlayer.destroy()
        kalturaOTTPlayer = nil
        audioTracks = nil
        textTracks = nil
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
                imaConfig.videoControlsOverlays = [controllersInteractiveView, topVisualEffectView, middleVisualEffectView, bottomVisualEffectView]
            }
            playerOptions.pluginConfig = pluginConfig
        }
        
        return playerOptions
    }
    
    @objc private func controllersInteractiveViewTapped() {
        let show = !(topVisualEffectViewHeightConstraint.constant == CGFloat(topBottomVisualEffectViewHeight))
        showPlayerControllers(show)
    }
    
    private func showPlayerControllers(_ show: Bool, delay: Double = 0.0) {
        let constantValue: Float = show ? topBottomVisualEffectViewHeight : 0.0
        UIView.animate(withDuration: 0.5, delay: delay, animations: {
            self.topVisualEffectViewHeightConstraint.constant = CGFloat(constantValue)
            self.bottomVisualEffectViewHeightConstraint.constant = CGFloat(constantValue)
            self.middleVisualEffectView.alpha = show ? 1.0 : 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    private func getTimeRepresentation(_ time: TimeInterval) -> String {
        if time > 3600 {
            let hours = Int(time / 3600)
            let minutes = Int(time.truncatingRemainder(dividingBy: 3600) / 60)
            let seconds = Int(time.truncatingRemainder(dividingBy: 60))
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            let minutes = Int(time / 60)
            let seconds = Int(time.truncatingRemainder(dividingBy: 60))
            return String(format: "00:%02d:%02d", minutes, seconds)
        }
    }
    
    // MARK: - Register Events
    
    private func registerPlayerEvents() {
        registerPlaybackEvents()
        handleTracks()
        handleProgress()
        handleBufferedProgress()
        handleDuration()
        handleError()
    }
    
    private func registerPlaybackEvents() {
        kalturaOTTPlayer.addObserver(self, events: [KPPlayerEvent.loadedMetadata, KPPlayerEvent.ended, KPPlayerEvent.play, KPPlayerEvent.playing, KPPlayerEvent.pause, KPPlayerEvent.canPlay, KPPlayerEvent.seeking, KPPlayerEvent.seeked, KPPlayerEvent.playbackStalled, KPPlayerEvent.stateChanged]) { [weak self] event in
            guard let self = self else { return }
            
            NSLog("Event triggered: " + event.description)
            
            DispatchQueue.main.async {
                switch event {
                case is KPPlayerEvent.LoadedMetadata:
                    if self.kalturaOTTPlayer.isLive() {
                        self.mediaProgressSlider.thumbTintColor = UIColor.red
                    } else {
                        self.mediaProgressSlider.thumbTintColor = UIColor.white
                    }
                case is KPPlayerEvent.Ended:
                    self.mediaEnded = true
                    if self.adsLoaded == false || self.allAdsCompleted {
                        // No ads on media or all ads where completed
                        self.playPauseButton.displayState = .replay
                        self.showPlayerControllers(true)
                    }
                case is KPPlayerEvent.Play:
                    self.playPauseButton.displayState = .pause
                case is KPPlayerEvent.Playing:
                    self.activityIndicator.stopAnimating()
                    self.playPauseButton.displayState = .pause
                    self.showPlayerControllers(false)
                case is KPPlayerEvent.Pause:
                    self.playPauseButton.displayState = .play
                case is KPPlayerEvent.CanPlay:
                    self.activityIndicator.stopAnimating()
                case is KPPlayerEvent.Seeking:
                    if self.kalturaOTTPlayer.isPlaying {
                        self.showPlayerControllers(false, delay: 0.5)
                    } else {
                        self.activityIndicator.startAnimating()
                    }
                case is KPPlayerEvent.Seeked:
                    self.userSeekInProgress = false
                    self.activityIndicator.stopAnimating()
                    if self.kalturaOTTPlayer.currentTime < self.kalturaOTTPlayer.duration, self.playPauseButton.displayState == .replay {
                        self.playPauseButton.displayState = .play
                    }
                case is KPPlayerEvent.PlaybackStalled:
                    if !self.kalturaOTTPlayer.isPlaying {
                        self.activityIndicator.startAnimating()
                    }
                case is KPPlayerEvent.StateChanged:
                    switch event.newState {
                    case .buffering:
                        if !self.kalturaOTTPlayer.isPlaying {
                            self.activityIndicator.startAnimating()
                        }
                    case .ready:
                        self.activityIndicator.stopAnimating()
                    default:
                        break
                    }
                default:
                    break
                }
            }
        }
    }
    
    private func handleTracks() {
        kalturaOTTPlayer.addObserver(self, events: [KPPlayerEvent.tracksAvailable]) { [weak self] event in
            guard let self = self else { return }
            guard let tracks = event.tracks else {
                NSLog("No Tracks Available")
                return
            }
            
            self.audioTracks = tracks.audioTracks
            self.textTracks = tracks.textTracks
        }
    }
    
    private func handleProgress() {
        kalturaOTTPlayer.addObserver(self, events: [KPPlayerEvent.playheadUpdate]) { [weak self] event in
            guard let self = self else { return }
            
            if self.userSeekInProgress { return }
            let currentTime = self.getTimeRepresentation(self.kalturaOTTPlayer.currentTime)
            DispatchQueue.main.async {
                self.currentTimeLabel.text = currentTime
                self.mediaProgressSlider.value = Float(self.kalturaOTTPlayer.currentTime / self.kalturaOTTPlayer.duration)
            }
        }
    }
    
    private func handleBufferedProgress() {
        kalturaOTTPlayer.addObserver(self, event: KPPlayerEvent.loadedTimeRanges) { [weak self] event in
            guard let self = self else { return }
            
            if self.userSeekInProgress { return }
            
            guard let timeRanges = event.timeRanges else { return }
            let bufferPosition = self.bufferPosition(from: self.kalturaOTTPlayer.currentTime, loadedTimeRanges: timeRanges)
            DispatchQueue.main.async {
                self.mediaProgressSlider.bufferValue = Float(bufferPosition / self.kalturaOTTPlayer.duration)
            }
        }
    }
    
    // PKTimeRange needs an import PlayKit
    private func bufferPosition(from currentTime: TimeInterval, loadedTimeRanges: [PKTimeRange]) -> TimeInterval {
        for timeRange in loadedTimeRanges {
            if currentTime.isLess(than: timeRange.end) {
                return timeRange.end
            }
        }
        
        return currentTime
    }
    
    private func handleDuration() {
        kalturaOTTPlayer.addObserver(self, events: [KPPlayerEvent.durationChanged]) { [weak self] event in
            guard let self = self else { return }
            
            let duration = self.getTimeRepresentation(self.kalturaOTTPlayer.duration)
            DispatchQueue.main.async {
                self.durationLabel.text = duration
            }
        }
    }
    
    private func handleError() {
        kalturaOTTPlayer.addObserver(self, events: [KPPlayerEvent.error]) { [weak self] event in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "Error", message: event.error?.description, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Register IMA Events
    
    private func registerAdEvents() {
        kalturaOTTPlayer.addObserver(self, events: [KPAdEvent.adLoaded, KPAdEvent.adPaused, KPAdEvent.adResumed, KPAdEvent.adStartedBuffering, KPAdEvent.adPlaybackReady, KPAdEvent.adStarted, KPAdEvent.adComplete, KPAdEvent.adSkipped, KPAdEvent.allAdsCompleted]) { [weak self] adEvent in
            guard let self = self else { return }
            
            NSLog("Event triggered: " + adEvent.description)
            
            DispatchQueue.main.async {
                switch adEvent {
                case is KPAdEvent.AdLoaded:
                    self.adsLoaded = true
                case is KPAdEvent.AdPaused:
                    self.playPauseButton.displayState = .play
                case is KPAdEvent.AdResumed:
                    self.activityIndicator.stopAnimating()
                    self.playPauseButton.displayState = .pause
                case is KPAdEvent.AdStartedBuffering:
                    if !self.kalturaOTTPlayer.isPlaying {
                        self.activityIndicator.startAnimating()
                    }
                case is KPAdEvent.AdPlaybackReady:
                    self.activityIndicator.stopAnimating()
                case is KPAdEvent.AdStarted:
                     self.activityIndicator.stopAnimating()
                    self.playPauseButton.displayState = .pause
                     self.mediaProgressSlider.isEnabled = false
                case is KPAdEvent.AdComplete:
                    self.mediaProgressSlider.isEnabled = true
                case is KPAdEvent.AdSkipped:
                    self.mediaProgressSlider.isEnabled = true
                case is KPAdEvent.AllAdsCompleted:
                    self.allAdsCompleted = true
                    // In case of a post-roll the media has ended
                    if self.mediaEnded {
                        self.playPauseButton.displayState = .replay
                        self.showPlayerControllers(true)
                    }
                default:
                    break
                }
            }
        }
    }
}
    
// MARK: - IBAction

extension MediaPlayerViewController {
        
    @IBAction private func openSettingsTouched(_ sender: Any) {
        showPlayerControllers(false)
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
            self.settingsVisualEffectView.alpha = 1.0
        }, completion: nil)
    }
    
    @IBAction private func closeSettingsTouched(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCrossDissolve, animations: {
            self.settingsVisualEffectView.alpha = 0.0
        }, completion: {(succeded) in
            self.showPlayerControllers(true)
        })
    }
    
    @IBAction private func speechTouched(_ button: UIButton) {
        
        guard let tracks = audioTracks else { return }
        
        let alertController = UIAlertController(title: "Select Speech", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        for track in tracks {
            alertController.addAction(UIAlertAction(title: track.title, style: UIAlertAction.Style.default, handler: { (alertAction) in
                self.kalturaOTTPlayer.selectTrack(trackId: track.id)
            }))
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func subtitleTouched(_ button: UIButton) {
        guard let tracks = textTracks else { return }
        
        let alertController = UIAlertController(title: "Select Subtitle", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        for track in tracks {
            alertController.addAction(UIAlertAction(title: track.title, style: UIAlertAction.Style.default, handler: { (alertAction) in
                self.kalturaOTTPlayer.selectTrack(trackId: track.id)
            }))
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func closeTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mediaProgressSliderTouchDown(_ sender: UISlider) {
        userSeekInProgress = true
    }
    
    @IBAction func mediaProgressSliderTouchUpOutside(_ sender: UISlider) {
        userSeekInProgress = false
    }
    
    @IBAction func mediaProgressSliderTouchUpInside(_ sender: UISlider) {
        let currentValue = Double(sender.value)
        let seekTo = currentValue * kalturaOTTPlayer.duration
        kalturaOTTPlayer.seek(to: seekTo)
    }
    
    @IBAction private func playButtonTouched(_ sender: Any) {
        if playPauseButton.displayState == .replay {
            kalturaOTTPlayer.replay()
            showPlayerControllers(false, delay: 0.5)
        } else if kalturaOTTPlayer.isPlaying || kalturaOTTPlayer.rate > 0 {
            kalturaOTTPlayer.pause()
        } else {
            kalturaOTTPlayer.play()
            showPlayerControllers(false)
        }
    }
    
    @IBAction private func speedRateTouched(_ button: UIButton) {
        let alertController = UIAlertController(title: "Select Speed Rate", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "Normal", style: UIAlertAction.Style.default, handler: { (alertAction) in
            self.kalturaOTTPlayer.rate = 1
        }))
        alertController.addAction(UIAlertAction(title: "x2", style: UIAlertAction.Style.default, handler: { (alertAction) in
            self.kalturaOTTPlayer.rate = 2
        }))
        alertController.addAction(UIAlertAction(title: "x3", style: UIAlertAction.Style.default, handler: { (alertAction) in
            self.kalturaOTTPlayer.rate = 3
        }))
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
