//
//  YouboraVideoData.swift
//  OVPSample_tvOS
//
//  Created by Nilit Danan on 12/20/20.
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
        
        videos.append(VideoData(title: "1_xay0wjby, autoPlay, preload",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_xay0wjby")))
        
        videos.append(VideoData(title: "1_ytsd86sc, autoPlay, preload, startTime-20",
                                player: PlayerData(pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_ytsd86sc", startTime: 20)))
        
        videos.append(VideoData(title: "1_3wzacuha, autoPlay-false, preload",
                                player: PlayerData(autoPlay: false,
                                                   pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_3wzacuha")))
        
        videos.append(VideoData(title: "1_25q88snr, autoPlay, preload-false",
                                player: PlayerData(preload: false,
                                                   pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_25q88snr")))

        videos.append(VideoData(title: "1_kvv3j1zk, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false,
                                                   preload: false,
                                                   pluginConfig: PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])),
                                media: OVPMedia(entryId: "1_kvv3j1zk")))
        return videos
    }
    
}

