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
    var referrer: String?
    
    var pluginConfig: PluginConfig?
    
    init(autoPlay: Bool = true, preload: Bool = true, ks: String? = nil, referrer: String? = nil, pluginConfig: PluginConfig? = nil) {
        self.autoPlay = autoPlay
        self.preload = preload
        self.ks = ks
        self.referrer = referrer
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
    var startTime: TimeInterval?
    
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
        
        if let startTime = startTime {
            ottMediaOptions.startTime = startTime
        }
        
        return ottMediaOptions
    }
}

struct VideoData {
    var title: String
    
    var player: PlayerData
    var media: OTTMedia
    
    var offlineSelectionOptions: OfflineSelectionOptions?
}