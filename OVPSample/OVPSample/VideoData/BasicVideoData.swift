//
//  BasicVideoData.swift
//  OVPSample
//
//  Created by Nilit Danan on 8/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import KalturaPlayer

extension VideoData {

    static func getBasicVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        let customPlaylistCountdownOptions = CountdownOptions()
        customPlaylistCountdownOptions.timeToShow = 30
        customPlaylistCountdownOptions.duration = 20

        videos.append(VideoData(title: "1_tmomdals, autoPlay, preload",
                                player: PlayerData(autoPlay: true, preload: true),
                                media: OVPMedia(entryId: "1_tmomdals"),
                                playlistCountdownOptions: customPlaylistCountdownOptions))
        
        videos.append(VideoData(title: "1_ytsd86sc, autoPlay, preload, startTime-20",
                                player: PlayerData(),
                                media: OVPMedia(entryId: "1_ytsd86sc", startTime: 20)))
        
        videos.append(VideoData(title: "1_3wzacuha, autoPlay-false, preload",
                                player: PlayerData(autoPlay: false),
                                media: OVPMedia(entryId: "1_3wzacuha")))
        
        videos.append(VideoData(title: "1_25q88snr, autoPlay, preload-false",
                                player: PlayerData(preload: false),
                                media: OVPMedia(entryId: "1_25q88snr")))

        videos.append(VideoData(title: "1_kvv3j1zk, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false, preload: false),
                                media: OVPMedia(entryId: "1_kvv3j1zk")))
        
        return videos
    }
}
