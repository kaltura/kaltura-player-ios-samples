//
//  MediaPlayerViewController.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/4/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit
import KalturaPlayer

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

class MediaPlayerViewController: PlayerViewController {
    
    var kalturaBasicPlayer: KalturaBasicPlayer! // Created in the viewDidLoad
    
    @IBOutlet weak var kalturaPlayerView: KalturaPlayerView!
    
    @IBOutlet private weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var topVisualEffectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var bottomVisualEffectViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var middleVisualEffectView: UIVisualEffectView!
    @IBOutlet private weak var settingsVisualEffectView: UIVisualEffectView!
    private let topBottomVisualEffectViewHeight: Float = 50.0
    
    @IBOutlet private weak var playPauseButton: PPRButton!
    
    @IBOutlet private weak var mediaProgressSlider: UISlider!
    
    private var audioTracks: [KPTrack]?
    private var textTracks: [KPTrack]?
    
    private var shouldPreparePlayer: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoData = self.videoData else { return }
        
        let basicPlayerOptions = BasicPlayerOptions()
        basicPlayerOptions.autoPlay = videoData.autoPlay
        basicPlayerOptions.preload = videoData.preload
        basicPlayerOptions.startTime = videoData.startTime
        if let pluginConfig = videoData.pluginConfig {
            basicPlayerOptions.pluginConfig = pluginConfig
        }
        
        kalturaBasicPlayer = KalturaBasicPlayer(basicPlayerOptions: basicPlayerOptions)
        kalturaBasicPlayer.kalturaPlayerView = kalturaPlayerView
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(playerViewTapped))
        kalturaPlayerView.addGestureRecognizer(gesture)
        settingsVisualEffectView.alpha = 0.0
        middleVisualEffectView.layer.cornerRadius = 40.0
        playPauseButton.displayState = .play
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showPlayerControllers(true)
        guard let videoData = self.videoData else { return }
        
        registerPlayerEvents()
        
        if shouldPreparePlayer {
            shouldPreparePlayer = false
            if let mediaEntry = videoData.mediaEntry {
                kalturaBasicPlayer.mediaEntry = mediaEntry
            } else if let freeFormMedia = videoData.freeFormMedia {
                guard let contentUrl = URL(string: freeFormMedia.contentUrl) else { return }
                kalturaBasicPlayer.setupMediaEntry(from: freeFormMedia.id, contentUrl: contentUrl, drmData: freeFormMedia.drmData, mediaFormat: freeFormMedia.mediaFormat)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        kalturaBasicPlayer.pause()
        kalturaBasicPlayer.removeObserver(self, events: KPEvent.allEventTypes)
    }
    
    deinit {
        kalturaBasicPlayer.destroy()
        kalturaBasicPlayer = nil
        audioTracks = nil
        textTracks = nil
    }
    
    // MARK: - Private Methods
    
    @objc private func playerViewTapped() {
        let show = !(topVisualEffectViewHeightConstraint.constant == CGFloat(topBottomVisualEffectViewHeight))
        showPlayerControllers(show)
    }
    
    private func registerPlayerEvents() {
        registerPlaybackEvents()
        handleTracks()
        handleProgress()
    }
    
    private func registerPlaybackEvents() {
        kalturaBasicPlayer.addObserver(self, events: [KPEvent.stopped, KPEvent.ended, KPEvent.play, KPEvent.playing, KPEvent.pause]) { [weak self] event in
            guard let self = self else { return }
            
            NSLog(event.description)
            
            DispatchQueue.main.async {
                switch event {
                case is KPEvent.Ended:
                    self.playPauseButton.displayState = .replay
                    self.showPlayerControllers(true)
                case is KPEvent.Play:
                    self.playPauseButton.displayState = .pause
                case is KPEvent.Playing:
                    self.playPauseButton.displayState = .pause
                    self.showPlayerControllers(false)
                case is KPEvent.Pause:
                    self.playPauseButton.displayState = .play
                default:
                    break
                }
            }
        }
    }
    
    private func handleTracks() {
        kalturaBasicPlayer.addObserver(self, events: [KPEvent.tracksAvailable]) { [weak self] event in
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
        kalturaBasicPlayer.addObserver(self, events: [KPEvent.playheadUpdate]) { [weak self] event in
            guard let self = self else { return }
            let currentTime = event.currentTime ?? NSNumber(value: self.kalturaBasicPlayer.currentTime)
            DispatchQueue.main.async {
                self.mediaProgressSlider.value = Float(currentTime.doubleValue / self.kalturaBasicPlayer.duration)
            }
        }
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
    
    // MARK: - IBAction
        
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
    
    @IBAction private func speechTouched(_ sender: Any) {
        
        guard let tracks = audioTracks else { return }
        
        let alertController = UIAlertController(title: "Select Speech", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        for track in tracks {
            alertController.addAction(UIAlertAction(title: track.title, style: UIAlertAction.Style.default, handler: { (alertAction) in
                self.kalturaBasicPlayer.selectTrack(trackId: track.id)
            }))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func subtitleTouched(_ sender: Any) {
        guard let tracks = textTracks else { return }
        
        let alertController = UIAlertController(title: "Select Subtitle", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        for track in tracks {
            alertController.addAction(UIAlertAction(title: track.title, style: UIAlertAction.Style.default, handler: { (alertAction) in
                self.kalturaBasicPlayer.selectTrack(trackId: track.id)
            }))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction private func closeTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func mediaProgressSliderValueChanged(_ sender: UISlider) {
        let currentValue = Double(sender.value)
        let seekTo = currentValue * kalturaBasicPlayer.duration
        kalturaBasicPlayer.seek(to: seekTo)
    }
    
    @IBAction private func playButtonTouched(_ sender: Any) {
        if playPauseButton.displayState == .replay {
            kalturaBasicPlayer.replay()
            showPlayerControllers(false, delay: 0.5)
        } else if kalturaBasicPlayer.isPlaying || kalturaBasicPlayer.rate > 0 {
            kalturaBasicPlayer.pause()
        } else {
            kalturaBasicPlayer.play()
            showPlayerControllers(false)
        }
    }
    
    @IBAction private func speedRateTouched(_ sender: Any) {
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
        
        self.present(alertController, animated: true, completion: nil)
    }
}
