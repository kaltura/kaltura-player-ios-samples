//
//  PlayerViewController.swift
//  OVPSample
//
//  Created by Nilit Danan on 8/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit

enum PlayerType {
    case Custom
    case KalturaPlayerUI
    
    func storyboardID() -> String {
        switch self {
        case .Custom: return "MediaPlayerViewController"
        case .KalturaPlayerUI: return "KPMediaPlayerViewController"
        }
    }
}

protocol PlayerViewController: UIViewController {
    var videoData: VideoData? { get set }
    var shouldPlayLocally: Bool { get set }
}
