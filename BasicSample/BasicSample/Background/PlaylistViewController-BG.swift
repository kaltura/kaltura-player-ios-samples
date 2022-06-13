//
//  PlaylistViewController-BG.swift
//  BasicSample
//
//  Created by Nilit Danan on 08/06/2022.
//  Copyright © 2022 Kaltura Inc. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import PlayKit

// Minimum implementation for playing audio of the video asset in the BG
// Does not work for assets including IMA

extension PlaylistViewController {
    
    func initBGSession() {
        
        kalturaBasicPlayer.settings.allowAudioFromVideoAssetInBackground = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(audioSessionInterrupted(_:)),
                                               name: AVAudioSession.interruptionNotification,
                                               object: AVAudioSession.sharedInstance())
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            let _ = try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("an error occurred when audio session category.\n \(error)")
        }
    }
    
    func deinitBGSession() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notifications
    @objc func audioSessionInterrupted(_ notification:Notification) {
        print("interruption received: \(notification)")
    }
    
    // Response to remote control events
    func remoteControlReceivedWithEvent(_ receivedEvent:UIEvent) {
        if (receivedEvent.type == .remoteControl) {
            switch receivedEvent.subtype {
            case .remoteControlTogglePlayPause:
                if kalturaBasicPlayer.isPlaying {
                    kalturaBasicPlayer.pause()
                } else {
                    kalturaBasicPlayer.play()
                }
            case .remoteControlPlay:
                kalturaBasicPlayer.play()
            case .remoteControlPause:
                kalturaBasicPlayer.pause()
            default:
                print("received sub type \(receivedEvent.subtype) Ignoring")
            }
        }
    }
}
