//
//  BasicVideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 5/28/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import KalturaPlayer

extension VideoData {
    
    static func getBasicVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        let customPlaylistCountdownOptions = CountdownOptions()
        customPlaylistCountdownOptions.timeToShow = 30
        customPlaylistCountdownOptions.duration = 20
        videos.append(VideoData(title: "3835484, autoPlay-true, preload-true",
                                player: PlayerData(autoPlay: true,
                                                   preload: true),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT"),                                
                                playlistCountdownOptions: customPlaylistCountdownOptions))
        
        videos.append(VideoData(title: "3835484, autoPlay, preload, startTime-20",
                                player: PlayerData(),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT",
                                                startTime: 20)))
        
        videos.append(VideoData(title: "3835484, autoPlay-false, preload",
                                player: PlayerData(autoPlay: false),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT")))
        
        videos.append(VideoData(title: "3835484, autoPlay, preload-false",
                                player: PlayerData(preload: false),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT")))

        videos.append(VideoData(title: "3835484, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false, preload: false),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT")))
        
        return videos
    }
}
