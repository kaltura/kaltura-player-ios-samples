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
        
        videos.append(VideoData(title: "3835484, autoPlay-true, preload-true",
                                player: PlayerData(autoPlay: true,
                                                   preload: true),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "3835484, autoPlay, preload, startTime-20",
                                player: PlayerData(),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT",
                                                startTime: 20),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "3835484, autoPlay-false, preload",
                                player: PlayerData(autoPlay: false),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "3835484, autoPlay, preload-false",
                                player: PlayerData(preload: false),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))

        videos.append(VideoData(title: "3835484, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false,
                                                   preload: false),
                                media: OTTMedia(assetId: "3835484",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "https",
                                                urlType: "DIRECT"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        return videos
    }
}
