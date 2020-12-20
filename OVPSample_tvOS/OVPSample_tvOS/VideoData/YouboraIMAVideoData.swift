//
//  YouboraIMAVideoData.swift
//  OVPSample_tvOS
//
//  Created by Nilit Danan on 12/20/20.
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
        videos.append(VideoData(title: "1_xay0wjby, autoPlay, preload - IMAPrerollTag",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaPrerollConfig,
                                                                                       YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_xay0wjby")))
        
        let imaSkippableConfig = IMAConfig()
        imaSkippableConfig.alwaysStartWithPreroll = true
        imaSkippableConfig.adTagUrl = IMASkippableTag
        videos.append(VideoData(title: "1_ytsd86sc, autoPlay, preload, startTime-20 - IMASkippableTag",
                                player: PlayerData(pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaSkippableConfig,
                                                                                       YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_ytsd86sc", startTime: 20)))
        
        let imaPostrollConfig = IMAConfig()
        imaPostrollConfig.adTagUrl = IMAPostrollTag
        videos.append(VideoData(title: "1_3wzacuha, autoPlay-false, preload - IMAPostrollTag",
                                player: PlayerData(autoPlay: false,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaPostrollConfig,
                                                                                       YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_3wzacuha")))
        
        let imaAdRulesConfig = IMAConfig()
        imaAdRulesConfig.adTagUrl = IMAAdRulesTag
        videos.append(VideoData(title: "1_25q88snr, autoPlay, preload-false - IMAAdRulesTag",
                                player: PlayerData(preload: false,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaAdRulesConfig,
                                                                                       YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_25q88snr")))

        let imaPrerollAdsResponseConfig = IMAConfig()
        imaPrerollAdsResponseConfig.adsResponse = IMAPrerollAdsResponse
        videos.append(VideoData(title: "1_kvv3j1zk, autoPlay-false, preload-false - IMAPrerollAdsResponse",
                                player: PlayerData(autoPlay: false,
                                                   preload: false,
                                                   pluginConfig: PluginConfig(config: [IMAPlugin.pluginName : imaPrerollAdsResponseConfig,
                                                                                       YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_kvv3j1zk")))
        
        return videos
    }
}

