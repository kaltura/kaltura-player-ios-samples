//
//  ViewController.swift
//  BasicSample_tvOS
//
//  Created by Nilit Danan on 12/17/20.
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
                self.setBackgroundImage(UIImage(named: "play"), for: .normal)
            case .pause:
                self.setBackgroundImage(UIImage(named: "pause"), for: .normal)
            case .replay:
                self.setBackgroundImage(UIImage(named: "reload"), for: .normal)
            }
        }
    }
}

class MediaPlayerViewController: UIViewController {

    var kalturaBasicPlayer: KalturaBasicPlayer! // Created in the viewDidLoad
    
    var videoData: VideoData? {
        didSet {
            if viewIfLoaded != nil, let videoData = self.videoData {
                kalturaBasicPlayer.stop()
                
                shouldPreparePlayer = true
                mediaProgressView.progress = 0
                currentTimeLabel.text = "00:00:00"
                durationLabel.text = "00:00:00"
                audioTracks = nil
                textTracks = nil
                mediaEnded = false
                adsLoaded = false
                allAdsCompleted = false

                let basicPlayerOptions = playerOptions(videoData)
                kalturaBasicPlayer.updatePlayerOptions(basicPlayerOptions)
            }
        }
    }
    
    @IBOutlet weak var kalturaPlayerView: KalturaPlayerView!
    
    @IBOutlet private weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var topVisualEffectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var bottomVisualEffectViewHeightConstraint: NSLayoutConstraint!
//    @IBOutlet private weak var settingsVisualEffectView: UIVisualEffectView!
    private let topBottomVisualEffectViewHeight: Float = 100.0
    
    @IBOutlet private weak var playPauseButton: PPRButton!
    
    @IBOutlet private weak var mediaProgressView: UIPlayerProgressView!

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
        
        playPauseButton.displayState = .play
        
        let basicPlayerOptions = playerOptions(videoData)
        kalturaBasicPlayer = KalturaBasicPlayer(options: basicPlayerOptions)
        kalturaBasicPlayer.view = kalturaPlayerView
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.kalturaBasicPlayer.pause()
            }
        }
        
        let playPauseTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped(recognizer:)))
        playPauseTapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)];
        self.view.addGestureRecognizer(playPauseTapRecognizer)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showControllersSwipe(recognizer:)))
        swipeUpRecognizer.direction = .up
        self.view.addGestureRecognizer(swipeUpRecognizer)
        
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showControllersSwipe(recognizer:)))
        swipeDownRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeDownRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let videoData = self.videoData else { return }
        
        registerPlayerEvents()
        // IMA
        registerAdEvents()
        
        if shouldPreparePlayer {
            shouldPreparePlayer = false
            
            var mediaOptions: MediaOptions? = nil
            if let startTime = videoData.startTime {
                mediaOptions = MediaOptions()
                mediaOptions?.startTime = startTime
            }
            
            if let mediaEntry = videoData.mediaEntry {
                kalturaBasicPlayer.setMedia(mediaEntry, options: mediaOptions)
            } else if let freeFormMedia = videoData.freeFormMedia {
                guard let contentUrl = URL(string: freeFormMedia.contentUrl) else { return }
                kalturaBasicPlayer.setupMediaEntry(id: freeFormMedia.id, contentUrl: contentUrl, drmData: freeFormMedia.drmData, mediaFormat: freeFormMedia.mediaFormat, mediaType: freeFormMedia.mediaType, mediaOptions: mediaOptions)
            }
            
            // If the autoPlay and preload was set to false, prepare will not be called automatically
            if videoData.player.autoPlay == false && videoData.player.preload == false {
                kalturaBasicPlayer.prepare()
            }
            
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

        if kalturaBasicPlayer.isPlaying {
            kalturaBasicPlayer.pause()
        }
        
        kalturaBasicPlayer.removeObserver(self, events: KPPlayerEvent.allEventTypes)
        // IMA
        kalturaBasicPlayer.removeObserver(self, events: KPAdEvent.allEventTypes)
    }
    
    deinit {
        kalturaBasicPlayer.destroy()
        kalturaBasicPlayer = nil
    }
    
    // MARK: - Private Methods
    
    func playerOptions(_ videoData: VideoData?) -> PlayerOptions {
        let playerOptions = PlayerOptions()
        
        if let autoPlay = videoData?.player.autoPlay {
            playerOptions.autoPlay = autoPlay
        }
        if let preload = videoData?.player.preload {
            playerOptions.preload = preload
        }
        if let pluginConfig = videoData?.player.pluginConfig {
            if let imaConfig = pluginConfig.config[IMAPlugin.pluginName] as? IMAConfig {
//                imaConfig.videoControlsOverlays = [controllersInteractiveView, topVisualEffectView, middleVisualEffectView, bottomVisualEffectView]
            }
            playerOptions.pluginConfig = pluginConfig
        }
        
        return playerOptions
    }
    
    @objc func playPauseTapped(recognizer:UITapGestureRecognizer) {
        if kalturaBasicPlayer.isPlaying || kalturaBasicPlayer.rate > 0 {
            kalturaBasicPlayer.pause()
        } else {
            kalturaBasicPlayer.play()
            showPlayerControllers(false)
        }
    }
    
    @objc func showControllersSwipe(recognizer:UISwipeGestureRecognizer) {
        let show = !(topVisualEffectViewHeightConstraint.constant == CGFloat(topBottomVisualEffectViewHeight))
        showPlayerControllers(show)
    }
    
    private func showPlayerControllers(_ show: Bool, delay: Double = 0.0) {
        let constantValue: Float = show ? topBottomVisualEffectViewHeight : 0.0
        UIView.animate(withDuration: 0.5, delay: delay, animations: {
            self.topVisualEffectViewHeightConstraint.constant = CGFloat(constantValue)
            self.bottomVisualEffectViewHeightConstraint.constant = CGFloat(constantValue)
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
        kalturaBasicPlayer.addObserver(self, events: [KPPlayerEvent.loadedMetadata, KPPlayerEvent.ended, KPPlayerEvent.play, KPPlayerEvent.playing, KPPlayerEvent.pause, KPPlayerEvent.canPlay, KPPlayerEvent.seeking, KPPlayerEvent.seeked, KPPlayerEvent.playbackStalled, KPPlayerEvent.stateChanged]) { [weak self] event in
            guard let self = self else { return }
            
            NSLog("Event triggered: " + event.description)
            
            DispatchQueue.main.async {
                switch event {
                case is KPPlayerEvent.LoadedMetadata:
                    if self.kalturaBasicPlayer.isLive() {
                        self.mediaProgressView.progressTintColor = UIColor.red
                    } else {
                        self.mediaProgressView.progressTintColor = UIColor.white
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
                    if self.kalturaBasicPlayer.isPlaying {
                        self.showPlayerControllers(false, delay: 0.5)
                    } else {
                        self.activityIndicator.startAnimating()
                    }
                case is KPPlayerEvent.Seeked:
//                    self.userSeekInProgress = false
                    self.activityIndicator.stopAnimating()
                    if self.kalturaBasicPlayer.currentTime < self.kalturaBasicPlayer.duration, self.playPauseButton.displayState == .replay {
                        self.playPauseButton.displayState = .play
                    }
                case is KPPlayerEvent.PlaybackStalled:
                    if !self.kalturaBasicPlayer.isPlaying {
                        self.activityIndicator.startAnimating()
                    }
                case is KPPlayerEvent.StateChanged:
                    switch event.newState {
                    case .buffering:
                        if !self.kalturaBasicPlayer.isPlaying {
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
        kalturaBasicPlayer.addObserver(self, events: [KPPlayerEvent.tracksAvailable]) { [weak self] event in
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
        kalturaBasicPlayer.addObserver(self, events: [KPPlayerEvent.playheadUpdate]) { [weak self] event in
            
            guard let self = self else { return }
            
//            if self.userSeekInProgress { return }
            
            guard let currentTimeNumber = event.currentTime else { return }
            let currentTime = self.getTimeRepresentation(currentTimeNumber.doubleValue)
            DispatchQueue.main.async {
                self.currentTimeLabel.text = currentTime
                self.mediaProgressView.progress = Float(currentTimeNumber.doubleValue / self.kalturaBasicPlayer.duration)
            }
        }
    }
    
    private func handleBufferedProgress() {
        kalturaBasicPlayer.addObserver(self, event: KPPlayerEvent.loadedTimeRanges) { [weak self] event in
            guard let self = self else { return }

//            if self.userSeekInProgress { return }

            DispatchQueue.main.async {
                self.mediaProgressView.bufferValue = Float(self.kalturaBasicPlayer.bufferedTime / self.kalturaBasicPlayer.duration)
            }
        }
    }
    
    private func handleDuration() {
        kalturaBasicPlayer.addObserver(self, events: [KPPlayerEvent.durationChanged]) { [weak self] event in
            guard let self = self else { return }
            
            let duration = self.getTimeRepresentation(self.kalturaBasicPlayer.duration)
            DispatchQueue.main.async {
                self.durationLabel.text = duration
            }
        }
    }
    
    private func handleError() {
        kalturaBasicPlayer.addObserver(self, events: [KPPlayerEvent.error]) { [weak self] event in
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
        kalturaBasicPlayer.addObserver(self, events: [KPAdEvent.adLoaded, KPAdEvent.adPaused, KPAdEvent.adResumed, KPAdEvent.adStartedBuffering, KPAdEvent.adPlaybackReady, KPAdEvent.adStarted, KPAdEvent.adComplete, KPAdEvent.adSkipped, KPAdEvent.allAdsCompleted]) { [weak self] adEvent in
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
                    if !self.kalturaBasicPlayer.isPlaying {
                        self.activityIndicator.startAnimating()
                    }
                case is KPAdEvent.AdPlaybackReady:
                    self.activityIndicator.stopAnimating()
                case is KPAdEvent.AdStarted:
                    self.activityIndicator.stopAnimating()
                    self.playPauseButton.displayState = .pause
//                    self.mediaProgressView.isEnabled = false
                case is KPAdEvent.AdComplete:
//                    self.mediaProgressView.isEnabled = true
                    break
                case is KPAdEvent.AdSkipped:
//                    self.mediaProgressView.isEnabled = true
                    break
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
    
    @IBAction private func speechTouched(_ button: UIButton) {
        guard let tracks = audioTracks else { return }
        
        let alertController = UIAlertController(title: "Select Speech", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        for track in tracks {
            alertController.addAction(UIAlertAction(title: track.title, style: UIAlertAction.Style.default, handler: { (alertAction) in
                self.kalturaBasicPlayer.selectTrack(trackId: track.id)
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
                self.kalturaBasicPlayer.selectTrack(trackId: track.id)
            }))
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func speedRateTouched(_ button: UIButton) {
        let alertController = UIAlertController(title: "Select Speed Rate", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alertController.addAction(UIAlertAction(title: "Normal", style: UIAlertAction.Style.default, handler: { (alertAction) in
            self.kalturaBasicPlayer.rate = 1
        }))
        alertController.addAction(UIAlertAction(title: "x2", style: UIAlertAction.Style.default, handler: { (alertAction) in
            self.kalturaBasicPlayer.rate = 2
        }))
        alertController.addAction(UIAlertAction(title: "x3", style: UIAlertAction.Style.default, handler: { (alertAction) in
            self.kalturaBasicPlayer.rate = 3
        }))
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}
