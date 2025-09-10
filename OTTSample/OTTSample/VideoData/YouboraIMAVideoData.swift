//
//  YouboraIMAVideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 6/17/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit
import PlayKit_IMA
import PlayKitYoubora

extension VideoData {
    
    static func getYouboraIMAVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        // The account code is mandatory, make sure to put the correct one.
        // See all available params in the YouboraConfig struct.
        let youboraPluginParams: [String: Any] = [
            "accountCode": "kalturatest"
        ]
        let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
        
        let imaPrerollConfig = IMAConfig()
        imaPrerollConfig.adTagUrl = IMAPrerollTag
        videos.append(VideoData(title: "3835484, autoPlay-true, preload-true - IMAPrerollTag",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaPrerollConfig, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT")))
        
        let imaSkippableConfig = IMAConfig()
        imaSkippableConfig.alwaysStartWithPreroll = true
        imaSkippableConfig.adTagUrl = IMASkippableTag
        videos.append(VideoData(title: "3835484, autoPlay, preload, startTime-20 - IMASkippableTag",
                                player: PlayerData(pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaSkippableConfig, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT",
                                                startTime: 20)))
        
        let imaPostrollConfig = IMAConfig()
        imaPostrollConfig.adTagUrl = IMAPostrollTag
        videos.append(VideoData(title: "3835484, autoPlay-false, preload - IMAPostrollTag",
                                player: PlayerData(autoPlay: false,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaPostrollConfig, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT")))
        
        let imaAdRulesConfig = IMAConfig()
        imaAdRulesConfig.adTagUrl = IMAAdRulesTag
        videos.append(VideoData(title: "3835484, autoPlay, preload-false - IMAAdRulesTag",
                                player: PlayerData(preload: false,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaAdRulesConfig, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT")))

        let imaPrerollAdsResponseConfig = IMAConfig()
        imaPrerollAdsResponseConfig.adsResponse = IMAPrerollAdsResponse
        videos.append(VideoData(title: "3835484, autoPlay-false, preload-false - IMAPrerollAdsResponse",
                                player: PlayerData(autoPlay: false,
                                                   preload: false,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaPrerollAdsResponseConfig, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT")))
        
        return videos
    }
}

