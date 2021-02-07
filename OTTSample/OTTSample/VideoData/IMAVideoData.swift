//
//  IMAVideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 5/28/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit
import PlayKit_IMA

extension VideoData {
    
    static func getIMAVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        let imaPrerollConfig = IMAConfig()
        imaPrerollConfig.adTagUrl = IMAPrerollTag
        videos.append(VideoData(title: "548575, autoPlay-true, preload-true - IMAPrerollTag",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaPrerollConfig])),
                                media: OTTMedia(assetId: "548575",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http"),
                                castAdditionalData: CastAdditionalData(adTagType: "vast")))
        
        let imaSkippableConfig = IMAConfig()
        imaSkippableConfig.alwaysStartWithPreroll = true
        imaSkippableConfig.adTagUrl = IMASkippableTag
        videos.append(VideoData(title: "548570, autoPlay, preload, startTime-20 - IMASkippableTag",
                                player: PlayerData(pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaSkippableConfig])),
                                media: OTTMedia(assetId: "548570",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http",
                                                startTime: 20),
                                castAdditionalData: CastAdditionalData(adTagType: "vast")))
        
        let imaPostrollConfig = IMAConfig()
        imaPostrollConfig.adTagUrl = IMAPostrollTag
        videos.append(VideoData(title: "548576, autoPlay-false, preload - IMAPostrollTag",
                                player: PlayerData(autoPlay: false,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaPostrollConfig])),
                                media: OTTMedia(assetId: "548576",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http"),
                                castAdditionalData: CastAdditionalData(adTagType: "vmap")))
        
        let imaAdRulesConfig = IMAConfig()
        imaAdRulesConfig.adTagUrl = IMAAdRulesTag
        videos.append(VideoData(title: "548577, autoPlay, preload-false - IMAAdRulesTag",
                                player: PlayerData(preload: false,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaAdRulesConfig])),
                                media: OTTMedia(assetId: "548577",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http"),
                                castAdditionalData: CastAdditionalData(adTagType: "vast")))

        let imaPrerollAdsResponseConfig = IMAConfig()
        imaPrerollAdsResponseConfig.adsResponse = IMAPrerollAdsResponse
        videos.append(VideoData(title: "548551, autoPlay-false, preload-false - IMAPrerollAdsResponse",
                                player: PlayerData(autoPlay: false,
                                                   preload: false,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaPrerollAdsResponseConfig])),
                                media: OTTMedia(assetId: "548551",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http"),
                                castAdditionalData: CastAdditionalData(adTagType: "vast")))
        
        return videos
    }
}
