//
//  YouboraIMADAIVideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 6/17/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit
import PlayKit_IMA
import PlayKitYoubora

extension VideoData {
    
    static func getYouboraIMADAIVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        // The account code is mandatory, make sure to put the correct one.
        // See all available params in the YouboraConfig struct.
        let youboraPluginParams: [String: Any] = [
            "accountCode": "kalturatest"
        ]
        let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
        
        let imaDAIConfigVODStartWithPreroll = IMADAIConfig()
        imaDAIConfigVODStartWithPreroll.assetTitle = "VOD - Tears of Steel"
        imaDAIConfigVODStartWithPreroll.assetKey = nil
        imaDAIConfigVODStartWithPreroll.contentSourceId = "2528370"
        imaDAIConfigVODStartWithPreroll.videoId = "tears-of-steel"
        imaDAIConfigVODStartWithPreroll.streamType = .vod
        imaDAIConfigVODStartWithPreroll.alwaysStartWithPreroll = true
        
        videos.append(VideoData(title: "IMA DAI - VOD Start With Preroll, 548575, autoPlay, preload",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigVODStartWithPreroll, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "548575",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http")))
        
        videos.append(VideoData(title: "IMA DAI - VOD Start With Preroll, 548570, autoPlay, preload, startTime-20",
                                player: PlayerData(pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigVODStartWithPreroll, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "548570",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http",
                                                startTime: 20)))
        
        let imaDAIConfigVODDontStartWithPreroll = IMADAIConfig()
        imaDAIConfigVODDontStartWithPreroll.assetTitle = "VOD - Tears of Steel"
        imaDAIConfigVODDontStartWithPreroll.assetKey = nil
        imaDAIConfigVODDontStartWithPreroll.contentSourceId = "2528370"
        imaDAIConfigVODDontStartWithPreroll.videoId = "tears-of-steel"
        imaDAIConfigVODDontStartWithPreroll.streamType = .vod
        imaDAIConfigVODDontStartWithPreroll.alwaysStartWithPreroll = false
        
        videos.append(VideoData(title: "IMA DAI - VOD Don't Start With Preroll, 548576, autoPlay-false, preload, startTime-20",
                                player: PlayerData(autoPlay: false,
                                                   pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigVODDontStartWithPreroll, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "548576",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http",
                                                startTime: 20)))
        
        
        let imaDAIConfigLiveDontStartWithPreroll = IMADAIConfig()
        imaDAIConfigLiveDontStartWithPreroll.assetTitle = "Live Video - Big Buck Bunny"
        imaDAIConfigLiveDontStartWithPreroll.assetKey = "sN_IYUG8STe1ZzhIIE_ksA"
        imaDAIConfigLiveDontStartWithPreroll.contentSourceId = nil
        imaDAIConfigLiveDontStartWithPreroll.videoId = nil
        imaDAIConfigLiveDontStartWithPreroll.streamType = .live
        imaDAIConfigLiveDontStartWithPreroll.alwaysStartWithPreroll = false
        
        videos.append(VideoData(title: "IMA DAI - Live Don't Start With Preroll, 548577, autoPlay, preload-false",
                                player: PlayerData(preload: false,
                                                   pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigLiveDontStartWithPreroll, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "548577",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http")))

        let imaDAIConfigError = IMADAIConfig()
        imaDAIConfigError.assetTitle = "BBB-widevine"
        imaDAIConfigError.assetKey = nil
        imaDAIConfigError.contentSourceId = "9992474148"
        imaDAIConfigError.videoId = "the-tears-of-steel"
        imaDAIConfigError.streamType = .vod
        imaDAIConfigError.alwaysStartWithPreroll = false
        
        videos.append(VideoData(title: "IMA DAI - Error, 548551, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false,
                                                   preload: false,
                                                   pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigError, YouboraPlugin.pluginName: analyticsConfig])),
                                media: OTTMedia(assetId: "548551",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http")))
        
        return videos
    }
}

