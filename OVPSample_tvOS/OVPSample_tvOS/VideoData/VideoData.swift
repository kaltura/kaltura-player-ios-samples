//
//  VideoData.swift
//  OVPSample_tvOS
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

struct OVPMedia {
    var ks: String?
    var entryId: String
    var uiconfId: NSNumber?
    var startTime: TimeInterval?
    
    func mediaOptions() -> OVPMediaOptions {
        let ovpMediaOptions = OVPMediaOptions()
        
        ovpMediaOptions.ks = ks
        ovpMediaOptions.entryId = entryId
        ovpMediaOptions.uiconfId = uiconfId
        
        if let startTime = startTime {
            ovpMediaOptions.startTime = startTime
        }
        
        return ovpMediaOptions
    }
}

struct VideoData {
    var title: String
    
    var player: PlayerData
    var media: OVPMedia
}

