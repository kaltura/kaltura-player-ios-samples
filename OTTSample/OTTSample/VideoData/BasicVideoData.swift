//
//  BasicVideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 5/28/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

extension VideoData {
    
    static func getBasicVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        videos.append(VideoData(title: "548575, autoPlay-true, preload-true",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   authToken: "FIRST_TOKEN_VALUE_1"),
                                media: OTTMedia(assetId: "548575",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http")))
        
        videos.append(VideoData(title: "548570, autoPlay, preload, startTime-20",
                                player: PlayerData(authToken: "Second_token_value_2"),
                                media: OTTMedia(assetId: "548570",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http",
                                                startTime: 20)))
        
        videos.append(VideoData(title: "548576, autoPlay-false, preload",
                                player: PlayerData(autoPlay: false,
                                                   authToken: "Third_token_value_3"),
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
