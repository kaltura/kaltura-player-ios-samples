//
//  VideoData.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit

struct VideoData {
    var title: String
    
    var id: String
    var contentUrl: String
    var drmData: [DRMParams]?
    var mediaFormat: PKMediaSource.MediaFormat = .unknown
    var pluginConfigs: PluginConfig?
    
    var autoPlay: Bool = false
    var startPosition: Double = 0
}
