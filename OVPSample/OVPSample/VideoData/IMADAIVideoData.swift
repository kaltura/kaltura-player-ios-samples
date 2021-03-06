//
//  IMADAIVideoData.swift
//  OVPSample
//
//  Created by Nilit Danan on 8/9/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit
import PlayKit_IMA

extension VideoData {
    
    static func getIMADAIVideos() -> [VideoData] {
        var videos: [VideoData] = []

        let imaDAIConfigVODStartWithPreroll = IMADAIConfig()
        imaDAIConfigVODStartWithPreroll.assetTitle = "VOD - Tears of Steel"
        imaDAIConfigVODStartWithPreroll.assetKey = nil
        imaDAIConfigVODStartWithPreroll.contentSourceId = "2528370"
        imaDAIConfigVODStartWithPreroll.videoId = "tears-of-steel"
        imaDAIConfigVODStartWithPreroll.streamType = .vod
        imaDAIConfigVODStartWithPreroll.alwaysStartWithPreroll = true
        
        videos.append(VideoData(title: "IMA DAI - VOD Start With Preroll, 1_xay0wjby, autoPlay, preload",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigVODStartWithPreroll])),
                                media: OVPMedia(entryId: "1_xay0wjby")))
        
        videos.append(VideoData(title: "IMA DAI - VOD Start With Preroll, 1_ytsd86sc, autoPlay, preload, startTime-20",
                                player: PlayerData(pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigVODStartWithPreroll])),
                                media: OVPMedia(entryId: "1_ytsd86sc", startTime: 20)))
        
        let imaDAIConfigVODDontStartWithPreroll = IMADAIConfig()
        imaDAIConfigVODDontStartWithPreroll.assetTitle = "VOD - Tears of Steel"
        imaDAIConfigVODDontStartWithPreroll.assetKey = nil
        imaDAIConfigVODDontStartWithPreroll.contentSourceId = "2528370"
        imaDAIConfigVODDontStartWithPreroll.videoId = "tears-of-steel"
        imaDAIConfigVODDontStartWithPreroll.streamType = .vod
        imaDAIConfigVODDontStartWithPreroll.alwaysStartWithPreroll = false
        
        videos.append(VideoData(title: "IMA DAI - VOD Don't Start With Preroll, 1_3wzacuha, autoPlay-false, preload, startTime-20",
                                player: PlayerData(autoPlay: false,
                                                   pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigVODDontStartWithPreroll])),
                                media: OVPMedia(entryId: "1_3wzacuha", startTime: 20)))
        
        let imaDAIConfigLiveDontStartWithPreroll = IMADAIConfig()
        imaDAIConfigLiveDontStartWithPreroll.assetTitle = "Live Video - Big Buck Bunny"
        imaDAIConfigLiveDontStartWithPreroll.assetKey = "sN_IYUG8STe1ZzhIIE_ksA"
        imaDAIConfigLiveDontStartWithPreroll.contentSourceId = nil
        imaDAIConfigLiveDontStartWithPreroll.videoId = nil
        imaDAIConfigLiveDontStartWithPreroll.streamType = .live
        imaDAIConfigLiveDontStartWithPreroll.alwaysStartWithPreroll = false
        
        videos.append(VideoData(title: "IMA DAI - Live Don't Start With Preroll, 1_25q88snr, autoPlay, preload-false",
                                player: PlayerData(preload: false,
                                                   pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigLiveDontStartWithPreroll])),
                                media: OVPMedia(entryId: "1_25q88snr")))

        let imaDAIConfigError = IMADAIConfig()
        imaDAIConfigError.assetTitle = "BBB-widevine"
        imaDAIConfigError.assetKey = nil
        imaDAIConfigError.contentSourceId = "9992474148"
        imaDAIConfigError.videoId = "the-tears-of-steel"
        imaDAIConfigError.streamType = .vod
        imaDAIConfigError.alwaysStartWithPreroll = false
        
        videos.append(VideoData(title: "IMA DAI - Error, 1_kvv3j1zk, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false,
                                                   preload: false,
                                                   pluginConfig: PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfigError])),
                                media: OVPMedia(entryId: "1_kvv3j1zk")))
        
        return videos
    }
    
}
