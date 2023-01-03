//
//  BasicVideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 5/28/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import KalturaPlayer
import PlayKit
import PlayKitProviders

extension VideoData {
    
    static func getBasicVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        let customPlaylistCountdownOptions = CountdownOptions()
        customPlaylistCountdownOptions.timeToShow = 30
        customPlaylistCountdownOptions.duration = 20
        
        let ks = ""
        
        
        let providersConfig = PhoenixAnalyticsPluginConfig(baseUrl: "https://api.frs1.ott.kaltura.com/api_v3/",
                                                           timerInterval: 15,
                                                           ks: ks,
                                                           partnerId: 8337)
        
        providersConfig.forceConcurrencyOnUnpaidContent = true
        
        videos.append(VideoData(title: "* 3516688, autoPlay-true, preload-true",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   ks: ks,
                                                   pluginConfig: PluginConfig(config: [PhoenixAnalyticsPlugin.pluginName: providersConfig])),
                                media: OTTMedia(assetId: "3516688",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                fileIds: ["36080467"],
                                                networkProtocol: "https"),
                                playlistCountdownOptions: customPlaylistCountdownOptions))
        
        videos.append(VideoData(title: "548570, autoPlay, preload, startTime-20",
                                player: PlayerData(),
                                media: OTTMedia(assetId: "548570",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http",
                                                startTime: 20)))
        
        videos.append(VideoData(title: "548576, autoPlay-false, preload",
                                player: PlayerData(autoPlay: false),
                                media: OTTMedia(assetId: "548576",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http")))
        
        videos.append(VideoData(title: "548577, autoPlay, preload-false",
                                player: PlayerData(preload: false),
                                media: OTTMedia(assetId: "548577",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http")))

        videos.append(VideoData(title: "548551, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false, preload: false),
                                media: OTTMedia(assetId: "548551",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http")))
        
        return videos
    }
}
