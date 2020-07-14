//
//  PKMediaPlayerViewController.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit
//import PlayKitUI

class PKMediaPlayerViewController: UIViewController, PlayerViewController {
    
    var videoData: VideoData?
    var shouldPlayLocally: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
