//
//  VideoData.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit

struct FreeFormMedia {
    var id: String
    var contentUrl: String
    var drmData: [DRMParams]?
    var mediaFormat: PKMediaSource.MediaFormat = .unknown
}

struct VideoData {
    var title: String
    
    var autoPlay: Bool = true
    var preload: Bool = true
    var startTime: TimeInterval = 0
    
    // Choose a media type
    var mediaEntry: PKMediaEntry?
    var freeFormMedia: FreeFormMedia?
    
    var pluginConfig: PluginConfig?
    
    init(title: String, mediaEntry: PKMediaEntry, autoPlay: Bool = true, preload: Bool = true, startTime: TimeInterval = 0, pluginConfig: PluginConfig? = nil) {
        self.title = title
        self.mediaEntry = mediaEntry
        self.autoPlay = autoPlay
        self.preload = preload
        self.startTime = startTime
        self.pluginConfig = pluginConfig
    }
    
    init(title: String, freeFormMedia: FreeFormMedia, autoPlay: Bool = true, preload: Bool = true, startTime: TimeInterval = 0, pluginConfig: PluginConfig? = nil) {
        self.title = title
        self.freeFormMedia = freeFormMedia
        self.autoPlay = autoPlay
        self.preload = preload
        self.startTime = startTime
        self.pluginConfig = pluginConfig
    }
}
