//
//  YouboraVideoData.swift
//  OVPSample
//
//  Created by Nilit Danan on 8/9/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit
import PlayKitYoubora

extension VideoData {
    
    static func getYouboraVideos() -> [VideoData] {
        var videos: [VideoData] = []

        // Only the account code is mandatory, make sure to put the correct one!
        // See all available params in the YouboraConfig struct.
        let youboraPluginParams: [String: Any] = [
            "accountCode": "kalturatest",
            "enabled": true,
            "httpSecure": true,
            "host": "a-fds.youborafds01.com",
            "authToken": "myTokenString",
            "authType": "Bearer",
            "username": "userTest",
            "offline": false,
            "autoDetectBackground": true,
            "forceInit": false,
            "experiments": ["experiment"],
            "linkedViewId": "viewID",
            "waitForMetadata": false,
            "pendingMetadata": ["title", "username"], // The name of the parameters in the request we are waiting for
            "householdId": "householdId",
            "user": [
                "anonymousId": "anonymous id",
                "type": "Normal",
                "email": "user_email",
                "obfuscateIp": false
            ],
            "ad": [
                "blockerDetected": false,
                "metadata": [
                    "custom_field": "Custom value",
                    "custom_field_2": "Custom value 2"
                    // ...
                ],
                "afterStop": 0,
                "campaign": "campaign name",
                "title": "ad name",
                "resource": "http://resource.url.com",
                "givenBreaks": 5,
                "expectedBreaks": 5,
                "expectedPattern": [
                     "pre": [1],
                     "mid": [1,1],
                     "post": [2]
                ],
                "breaksTime": [0, 25, 45, 60],
                "givenAds": 2,
                "creativeId": "12345",
                "provider": "provider name",
                "customDimension": [
                    "1": "custom dimension 1",
                    "2": "custom dimension 2"
                    // ...
                ]
            ],
            "smartswitch": [
                "configCode": "smartswitch config code",
                "groupCode": "smartswitch group Code",
                "contractCode": "smartswitch contract code"
            ],
            "parse": [
                "manifest": false,
                "cdnNameHeader": "x-cdn",
//                "cdnNode": true, // Ignored, use requestDebugHeaders within cdnNode
                "cdnNode": [
                    "requestDebugHeaders": true, // Replaces cdnNode that was ignored outside.
                    "list": ["Akamai", "Amazon", "Cloudfront", "Level3", "Fastly", "Highwinds", "Telefonica", "Edgecast", "NosOtt", "Balancer"],
                ],
                "cdnTTL": 60.0, // Interval of time to search for a new cdn
                "cdnSwitchHeader": true
            ],
            "network": [
                "ip": "1.1.1.1",
                "isp": "ISPTest",
                "connectionType": "cable/dsl"
            ],
            "device": [
                "code": "iPhoneX",
                "model" : "X",
                "brand": "Apple",
                "type": "smartphone",
                "name": "iPhone",
                "osName": "iPhone",
                "osVersion": "15.3",
                "isAnonymous": false,
                "id": "myUniqueDeviceId",
                "EDID": "123456"
            ],
            "content": [
                "resource": "http://yourhost.com/yourmedia.m3u8",
//                "isLive": true, // Ignored, use isLiveContent within isLive
                "isLive": [
                    "isLiveContent": true, // Replaces isLive that was ignored outside.
                    "noSeek": false,
                    "noMonitor": false,
                ],
                "title": "titleTest",
                "program": "programName",
                "duration": 860,
                "transactionCode": "transactionTest",
                "bitrate": 123456,
                "throughput": 123456,
                "rendition": "myCustomRendition",
                "cdn": "AKAMAI",
                "cdnNode": "cdnNode",
                "cdnType": "cdnType",
                "fps": 60,
                "streamingProtocol": "HLS",
                "transportFormat": "transportFormat",
                "metadata": [
                     "genre": "genreTest",
                     "language": "languageTest",
                     "year": "yearTest",
                     // ...
                ],
                "metrics": [
                    "metrics1": "metrics1Value"
                    // ...
                ],
                "package": "package name",
                "saga": "saga name",
                "tvShow": "tvShow name",
                "season": "season number",
                "episodeTitle": "title name",
                "channel": "channel name",
                "id": "id",
                "imdbId": "imdb id",
                "gracenoteId": "gracenote id",
                "type": "type name",
                "genre": "genre name",
                "language": "language name",
                "subtitles": "subtitles name",
                "contractedResolution": "contracted resolution",
                "cost": "cost number",
                "price": "price number",
                "playbackType": "playback type",
                "drm": "drm",
                "encoding": [
                    "videoCodec": "video codec name",
                    "audioCodec": "audio codec name",
                    "codecSettings": "codec settings", // Ignored until understood
                    "codecProfile": "codec profile",
                    "containerFormat": "container format"
                ],
                "customDimension": [
                    "1": "custom dimension 1",
                    "2": "custom dimension 2"
                    // ...
                ],
                "customDimensions": [
                    "customDimension": "customDimension"
                    // ...
                ],
                "totalBytes": 123456,
                "sendTotalBytes": true
            ],
            "app": [
                "name": "myCustomApp",
                "releaseVersion": "0.1-beta"
            ],
            "session": [
                "metrics": [
                    "metricskey": ["test": 66],
                    "metricskey2": "test",
                    "metricskey3": 2
                    // ...
                ]
            ],
            "errors": [
                "fatal": ["123", "errorcode"],
                "nonFatal": ["123", "errorcode"],
                "ignore": ["123", "errorcode"]
            ]
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
