//
//  BasicVideoData.swift
//  OVPSample
//
//  Created by Nilit Danan on 8/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import KalturaPlayer
import PlayKit
import PlayKitProviders

extension VideoData {

    static func getBasicVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        let customPlaylistCountdownOptions = CountdownOptions()
        customPlaylistCountdownOptions.timeToShow = 30
        customPlaylistCountdownOptions.duration = 20
        
        let ks = "djJ8MjIyMjQwMXwOldN3V8Yh0njn_l3drWXXk8HfQ1XMn8bxYhSaVBMuaTQSi86N3hzFvYLeLMAOLfY7m3PXrVcf90OwPRphJEXow8140juw-c9ULCmyESe89A=="
        
        let extSub = PKExternalSubtitle(id: "123",
                                        name: "Eng-2",
                                        language: "en",
                                        vttURLString: "http://externaltests.dev.kaltura.com/player/captions_files/eng.vtt",
                                        duration: -1)
        
        videos.append(VideoData(title: "External subs 1 1_x0ygxknt, preload",
                                player: PlayerData(autoPlay: true, preload: true),
                                media: OVPMedia(entryId: "1_x0ygxknt", externalSubtitles: [extSub]),
                                playlistCountdownOptions: customPlaylistCountdownOptions))
        
        
        
        videos.append(VideoData(title: "External subs 2 1_cqzapbhz, preload",
                                player: PlayerData(autoPlay: true, preload: true),
                                media: OVPMedia(entryId: "1_cqzapbhz"),
                                playlistCountdownOptions: customPlaylistCountdownOptions))
        
        
        videos.append(VideoData(title: "YT 1_icndymes, preload",
                                player: PlayerData(autoPlay: false, preload: true),
                                media: OVPMedia(entryId: "1_icndymes"),
                                playlistCountdownOptions: customPlaylistCountdownOptions))
        
        videos.append(VideoData(title: "CC 0_hut6q26s, autoPlay, preload",
                                player: PlayerData(autoPlay: true, preload: true),
                                media: OVPMedia(entryId: "0_hut6q26s"),
                                playlistCountdownOptions: customPlaylistCountdownOptions))
        
        videos.append(VideoData(title: "1_xay0wjby, autoPlay, preload",
                                player: PlayerData(autoPlay: true, preload: true),
                                media: OVPMedia(entryId: "1_xay0wjby", externalSubtitles: [extSub]),
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
                                player: PlayerData(autoPlay: false, preload: false, ks: ks),
                                media: OVPMedia(entryId: "1_kvv3j1zk", externalSubtitles: [extSub])))
        
        return videos
    }
}
