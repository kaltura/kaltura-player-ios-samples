//
//  KPMediaPlayerViewController-BG.swift
//  BasicSample
//
//  Created by Nilit Danan on 11/05/2022.
//  Copyright © 2022 Kaltura Inc. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import PlayKit

extension KPMediaPlayerViewController {
    
    func initBGSession() {
        
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
    
    // MARK: - Notifications
    @objc func audioSessionInterrupted(_ notification:Notification)
    {
        print("interruption received: \(notification)")
    }
    
    // Response to remote control events
    func remoteControlReceivedWithEvent(_ receivedEvent:UIEvent)  {
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
