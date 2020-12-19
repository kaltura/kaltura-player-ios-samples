//
//  VideoData.swift
//  BasicSample_tvOS
//
//  Created by Nilit Danan on 12/17/20.
//

import PlayKit
import KalturaPlayer

struct FreeFormMedia {
    var id: String
    var contentUrl: String
    var drmData: [DRMParams]?
    var mediaFormat: PKMediaSource.MediaFormat = .unknown
    var mediaType: MediaType = .unknown
}

struct PlayerData {

    var autoPlay: Bool = true
    var preload: Bool = true
    
    var pluginConfig: PluginConfig?
    
    init(autoPlay: Bool = true, preload: Bool = true, pluginConfig: PluginConfig? = nil) {
        self.autoPlay = autoPlay
        self.preload = preload
        self.pluginConfig = pluginConfig
    }
}

struct VideoData {
    var title: String
    
    var player: PlayerData

    var startTime: TimeInterval?
    
    // Choose a media type
    var mediaEntry: PKMediaEntry?
    var freeFormMedia: FreeFormMedia?
    
    init(title: String, mediaEntry: PKMediaEntry, player: PlayerData = PlayerData(), startTime: TimeInterval? = nil) {
        self.title = title
        self.mediaEntry = mediaEntry
        self.player = player
        self.startTime = startTime
    }
    
    init(title: String, freeFormMedia: FreeFormMedia, player: PlayerData = PlayerData(), startTime: TimeInterval? = nil) {
        self.title = title
        self.freeFormMedia = freeFormMedia
        self.player = player
        self.startTime = startTime
    }
}
