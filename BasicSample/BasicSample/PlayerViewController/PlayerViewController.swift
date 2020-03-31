//
//  PlayerViewController.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit

enum PlayerType {
    case Custom
    case PlayKitUI
    
    func storyboardID() -> String {
        switch self {
        case .Custom: return "MediaPlayerViewController"
        case .PlayKitUI: return "PKMediaPlayerViewController"
        }
    }
}

class PlayerViewController: UIViewController {
    var videoData: VideoData?
}
