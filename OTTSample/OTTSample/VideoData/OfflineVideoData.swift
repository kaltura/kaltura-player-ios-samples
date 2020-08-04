//
//  OfflineVideoData.swift
//  OTTSample
//
//  Created by Nilit Danan on 6/28/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import Foundation
import KalturaPlayer

extension VideoData {
    
    static func getOfflineVideos() -> [VideoData] {
        var videos: [VideoData] = []
                        
        let defaultOfflineSelectionOptions = OfflineSelectionOptions()
            .setMinVideoHeight(300)
            .setMinVideoBitrate(.avc1, 3_000_000)
            .setMinVideoBitrate(.hevc, 5_000_000)
            .setPreferredVideoCodecs([.hevc, .avc1])
            .setPreferredAudioCodecs([.ac3, .mp4a])
            .setAllTextLanguages()
            .setAllAudioLanguages()

        defaultOfflineSelectionOptions.allowInefficientCodecs = true
        
        videos.append(VideoData(title: "548575, autoPlay-true, preload-true",
                                player: PlayerData(autoPlay: true,
                                                   preload: true),
                                media: OTTMedia(assetId: "548575",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "548570, autoPlay, preload, startTime-20",
                                player: PlayerData(),
                                media: OTTMedia(assetId: "548570",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http",
                                                startTime: 20),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "548576, autoPlay-false, preload",
                                player: PlayerData(autoPlay: false),
                                media: OTTMedia(assetId: "548576",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "548577, autoPlay, preload-false",
                                player: PlayerData(preload: false),
                                media: OTTMedia(assetId: "548577",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))

        videos.append(VideoData(title: "548551, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false,
                                                   preload: false),
                                media: OTTMedia(assetId: "548551",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        return videos
    }
}
