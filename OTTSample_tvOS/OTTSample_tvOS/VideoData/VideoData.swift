//
//  VideoData.swift
//  OTTSample_tvOS
//
//  Created by Nilit Danan on 12/20/20.
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
    var adapterData: [String: String]?
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
        ottMediaOptions.urlType = urlType
        ottMediaOptions.streamerType = streamerType
        ottMediaOptions.adapterData = adapterData
        
        if let startTime = startTime {
            ottMediaOptions.startTime = startTime
        }
        
        if let networkProtocol = networkProtocol {
            ottMediaOptions.networkProtocol = networkProtocol
        }
        
        return ottMediaOptions
    }
}

struct VideoData {
    var title: String
    
    var player: PlayerData
    var media: OTTMedia
}
