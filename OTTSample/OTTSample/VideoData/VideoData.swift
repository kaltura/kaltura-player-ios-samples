//
//  VideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 5/3/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit
import PlayKitProviders
import KalturaPlayer

struct PlayerData {

    var autoPlay: Bool = true
    var preload: Bool = true
    
    var ks: String?
    
    var pluginConfig: PluginConfig?
    
    init(autoPlay: Bool = true, preload: Bool = true, ks: String? = nil, pluginConfig: PluginConfig? = nil) {
        self.autoPlay = autoPlay
        self.preload = preload
        self.ks = ks
        self.pluginConfig = pluginConfig
    }
}

struct OTTMedia {
    var ks: String?
    var assetId: String
    var assetType: AssetType
    var assetReferenceType: AssetReferenceType
    var playbackContextType: PlaybackContextType
    var formats: [String]?
    var fileIds: [String]?
    var networkProtocol: String?
    var urlType: String?
    var streamerType: String?
    var startTime: TimeInterval?
    
    var disableMediaHit: Bool = false
    var disableMediaMark: Bool = false
    
    func mediaOptions() -> OTTMediaOptions {
        let ottMediaOptions = OTTMediaOptions()
        
        ottMediaOptions.ks = ks
        ottMediaOptions.assetId = assetId
        ottMediaOptions.assetType = assetType
        ottMediaOptions.assetReferenceType = assetReferenceType
        ottMediaOptions.formats = formats
        ottMediaOptions.fileIds = fileIds
        ottMediaOptions.playbackContextType = playbackContextType
        ottMediaOptions.networkProtocol = networkProtocol
        ottMediaOptions.urlType = urlType
        ottMediaOptions.streamerType = streamerType
        
        if let startTime = startTime {
            ottMediaOptions.startTime = startTime
        }
        
        ottMediaOptions.disableMediaHit = disableMediaHit
        ottMediaOptions.disableMediaMark = disableMediaMark
        
        return ottMediaOptions
    }
}

struct VideoData {
    var title: String
    
    var player: PlayerData
    var media: OTTMedia
    
    var offlineSelectionOptions: OfflineSelectionOptions?
}
