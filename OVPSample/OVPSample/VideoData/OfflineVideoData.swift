//
//  OfflineVideoData.swift
//  OVPSample
//
//  Created by Nilit Danan on 8/9/20.
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

        videos.append(VideoData(title: "1_xay0wjby, autoPlay, preload",
                                player: PlayerData(autoPlay: true, preload: true),
                                media: OVPMedia(entryId: "1_xay0wjby"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "1_ytsd86sc, autoPlay, preload, startTime-20",
                                player: PlayerData(),
                                media: OVPMedia(entryId: "1_ytsd86sc", startTime: 20),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "1_3wzacuha, autoPlay-false, preload",
                                player: PlayerData(autoPlay: false),
                                media: OVPMedia(entryId: "1_3wzacuha"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "1_25q88snr, autoPlay, preload-false",
                                player: PlayerData(preload: false),
                                media: OVPMedia(entryId: "1_25q88snr"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))

        videos.append(VideoData(title: "1_kvv3j1zk, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false, preload: false),
                                media: OVPMedia(entryId: "1_kvv3j1zk"),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        return videos
    }
}
