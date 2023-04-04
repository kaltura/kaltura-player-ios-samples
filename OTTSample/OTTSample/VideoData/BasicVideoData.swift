//
//  BasicVideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 5/28/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import KalturaPlayer
import PlayKitProviders
import PlayKit


extension VideoData {
    
    static func getBasicVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        let customPlaylistCountdownOptions = CountdownOptions()
        customPlaylistCountdownOptions.timeToShow = 30
        customPlaylistCountdownOptions.duration = 20
        
        var phoenixAnalytics = PhoenixAnalyticsPluginConfig(baseUrl: "https://restv4-as.ott.kaltura.com/api_v3/",
                                                    timerInterval: 30,
                                                    ks: "djJ8MzIwMXxVIsd2v-DMHeUsNmMl6SyCSIIFvbHm8Zd8TDJAmvz_iyU5JO4qlS0zxHJ4D2oPACRdlclqFRnVhx4lsdFnzDE0-wy4f19mSNhSSz6Bekz9x5VFYiFsb-X4PAi0ThOU5UM2JNWHIRrmZd5jEdGUwunLFPj2Glb42mn-T4uOOKlhnhgCgh7agB6SY-vz8g5O2yQxVQG-c5n_WbW2Td8vIcTE96BkeGy3XoIJCcIWygMPPnGNmC1esBTMQi4srNeGScjJXvqkq66VCuOwp13wa9aGJlVT9dRVl6-EnhEO6Je2I1TOWO9N48-Xto1cc0a6JJeHWPze1ded_4Ap7oH3C22u",
                                                    partnerId: 3065,
                                                    disableMediaHit: false,
                                                    disableMediaMark: false
                                                    //isExperimentalLiveMediaHit: true,
                                                    //epgId: "12344321"
                                                            
        )
       // phoenixAnalytics.forceConcurrencyOnUnpaidContent = false
    
        videos.append(VideoData(title: "3453528, GILAD vod stg",
                                        player: PlayerData(autoPlay: true, preload: true),

                                        media: OTTMedia(
                                            ks: "djJ8MzIyM3xIQPU3xmEdfhe4gnriLy8uTjUTr6uRJTLhzzE6A0eVt23Ap2LoPSmMVJ2rSpuwoWjmouim3hUuWpAEzCDT2LhzQTDoVwJL1Pp6P_9F0bqnWlY9LDEDAI0RDT4kZRWDw3wrMwCnw_J2S67Z9RnA1v-oYf_ZJV4mykodueea1o01frT_7qi9Mmwjlr1YmJZ1fdYU9UKXkskafN35WUan8FXd9Bko5PS9Jz32up6TtxPvncDBd-I_xqI2Ko_R9TuxGszCf7ICc4T9V9stePz0I4ndEn6Z2KS0QBVB8ruERUDGXy73zKHxX6_edN8zoNrITVA=",

                                            assetId: "3453528",
                                            assetType: .media,
                                                        assetReferenceType: .media,
                                                        playbackContextType: .playback,
                                           // formats: ["Hls_fairplay"],
                                                        networkProtocol: "https",
                                            urlType: "direct",
                                            streamerType: "applehttp"
                                            
                                        )))
        
        videos.append(VideoData(title: "1272232, GILAD vod",
                                        player: PlayerData(autoPlay: true, preload: true),

                                        media: OTTMedia(
                                            ks: "djJ8MzIyM3yjd9W-JesWVuXjIN2Y1kLOj5WF0ugMjSNaR2vabQ1PfjfKGVR9JcF_-TpjgPM6U2auS0SAhAl8vhQGpuo6qiMFVu46CNf7DF1PS1GXI9kWeMHq-SYavCLdpSD9hGRiEatnHekTHOCUA1UxBLYvT3YDo0hg9Y0JzH3CMv_kgn-4ftB3pDaAEr5YvbG1j_5MT9A64cQhv1MjyPyXdLq6IHb-re6g-bstpkQSHR0yI6TsaqlEIC18mMnQYBJ9mf__CJXUi-xu-EnxCPvzizpo0XxRKssUBz32BokQfbP00I7fR3kgXJGJTK62ZhicGt0tTin55WBoK4Z9KuE_jVRbuxXTXT2xjfKQygnwx9GjhW5cmuABEskM04S1_R04t59SBhY=",

                                            assetId: "1272232",
                                            assetType: .media,
                                                        assetReferenceType: .media,
                                                        playbackContextType: .playback,
                                            formats: ["Hls_fairplay"],
                                                        networkProtocol: "https"
                                            //urlType: "direct",
                                            //streamerType: "applehttp"
                                            
                                        )))
        
        
        videos.append(VideoData(title: "809754, GILAD live",
                                        player: PlayerData(autoPlay: true, preload: true,  pluginConfig: PluginConfig(config: [PhoenixAnalyticsPlugin.pluginName: phoenixAnalytics])),

                                        media: OTTMedia(
                                            ks: "djJ8MzIwMXwXWhDm3XY2BMQeGpxTyHW6novA1uZ7C2Ub6GhDWecD8Y5ggzSTBf7_vDsWLUKVAO4YdPWMtimPzqEb_xsUwVrMZOS9JAvZCOn7Mg5y5nsx6yIXywjuyg4hCjdEL7dRCYQxabq4trTWzZih7e2JnvxWK4t1XW9XTklJBPURlWmG7uE0MOVwuh-vdtAW3Ov0renyrDdBcRgw5Qgwqg6rBCCQAXL58r1o2sWVpZ_ntXHs9xAM5aK80ql8bYTFBkurt8a4-OxO4SJ2BWscMyif7hM8LuOHdNdZpeGh0s2-vo2ZASpt6Zs-pfuqx4XtVXi8nkM37-I2MdRMDDJ8kLeC_JbX",

                                            assetId: "809754",
                                            assetType: .media,
                                                        assetReferenceType: .media,
                                                        playbackContextType: .playback,
                                                        networkProtocol: "https",
                                                        urlType: "direct",
                                                        streamerType: "applehttp"
                                        )))
        
                                                   
        videos.append(VideoData(title: "129179255, GILAD catchup",
                                        player: PlayerData(autoPlay: true, preload: true,  pluginConfig: PluginConfig(config: [PhoenixAnalyticsPlugin.pluginName: phoenixAnalytics])),

                                        media: OTTMedia(
                                            ks: "djJ8MzIwMXxVIsd2v-DMHeUsNmMl6SyCSIIFvbHm8Zd8TDJAmvz_iyU5JO4qlS0zxHJ4D2oPACRdlclqFRnVhx4lsdFnzDE0-wy4f19mSNhSSz6Bekz9x5VFYiFsb-X4PAi0ThOU5UM2JNWHIRrmZd5jEdGUwunLFPj2Glb42mn-T4uOOKlhnhgCgh7agB6SY-vz8g5O2yQxVQG-c5n_WbW2Td8vIcTE96BkeGy3XoIJCcIWygMPPnGNmC1esBTMQi4srNeGScjJXvqkq66VCuOwp13wa9aGJlVT9dRVl6-EnhEO6Je2I1TOWO9N48-Xto1cc0a6JJeHWPze1ded_4Ap7oH3C22u",

                                            assetId: "129179255",
                                            assetType: .epg,
                                                        assetReferenceType: .epgInternal,
                                                        playbackContextType: .startOver,
                                                        networkProtocol: "https",
                                                        urlType: "direct",
                                                        streamerType: "applehttp"
                                        )))
                                
        videos.append(VideoData(title: "130063854, GILAD recording",
                                        player: PlayerData(autoPlay: true, preload: true,  pluginConfig: PluginConfig(config: [PhoenixAnalyticsPlugin.pluginName: phoenixAnalytics])),

                                        media: OTTMedia(
                                            ks: "djJ8MzIwMXxVIsd2v-DMHeUsNmMl6SyCSIIFvbHm8Zd8TDJAmvz_iyU5JO4qlS0zxHJ4D2oPACRdlclqFRnVhx4lsdFnzDE0-wy4f19mSNhSSz6Bekz9x5VFYiFsb-X4PAi0ThOU5UM2JNWHIRrmZd5jEdGUwunLFPj2Glb42mn-T4uOOKlhnhgCgh7agB6SY-vz8g5O2yQxVQG-c5n_WbW2Td8vIcTE96BkeGy3XoIJCcIWygMPPnGNmC1esBTMQi4srNeGScjJXvqkq66VCuOwp13wa9aGJlVT9dRVl6-EnhEO6Je2I1TOWO9N48-Xto1cc0a6JJeHWPze1ded_4Ap7oH3C22u",

                                            assetId: "130063854",
                                            assetType: .recording,
                                                        assetReferenceType: .npvr,
                                                        playbackContextType: .playback,
                                                        networkProtocol: "https",
                                                        urlType: "direct",
                                                        streamerType: "applehttp"
                                        )))
        

        
        videos.append(VideoData(title: "548575, autoPlay-true, preload-true",
                                player: PlayerData(autoPlay: true,
                                                   preload: true),
                                media: OTTMedia(assetId: "548575",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http"),
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
