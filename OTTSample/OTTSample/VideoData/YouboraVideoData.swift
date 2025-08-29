//
//  YouboraVideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 6/17/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit
import PlayKitYoubora

extension VideoData {
    
    static func getYouboraVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        // The account code is mandatory, make sure to put the correct one.
        // See all available params in the YouboraConfig struct.
        let youboraPluginParams: [String: Any] = [
            "accountCode": "kalturatest"
        ]
        let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
        
        videos.append(VideoData(title: "3835484, autoPlay-true, preload-true",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https")))
        
        videos.append(VideoData(title: "3835484, autoPlay, preload, startTime-20",
                                player: PlayerData(pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                startTime: 20)))
        
        videos.append(VideoData(title: "3835484, autoPlay-false, preload",
                                player: PlayerData(autoPlay: false,
                                                   pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https")))
        
        videos.append(VideoData(title: "3835484, autoPlay, preload-false",
                                player: PlayerData(preload: false,
                                                   pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https")))

        videos.append(VideoData(title: "3835484, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false, preload: false,
                                                   pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https")))
        
        return videos
    }
}

