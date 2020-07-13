//
//  OfflineVideoData.swift
//  BasicSample
//
//  Created by Nilit Danan on 7/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import KalturaPlayer
import PlayKit

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

        videos.append(VideoData(title: "KalturaMedia 1_vl96wf1o",
                                mediaEntry: PKMediaEntry("1_vl96wf1o",
                                                         sources: [PKMediaSource("1_vl96wf1o",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "AES-128 multi-key",
                                mediaEntry: PKMediaEntry("AES-128 multi-key",
                                                         sources: [PKMediaSource("AES-128 multi-key",
                                                                                 contentUrl: URL(string: "https://noamtamim.com/random/hls/test-enc-aes/multi.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "Eran multi audio - 0_7s8q41df",
                                mediaEntry: PKMediaEntry("0_7s8q41df",
                                                         sources: [PKMediaSource("0_7s8q41df",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/2035982/sp/203598200/playManifest/entryId/0_7s8q41df/format/applehttp/protocol/https/name/a.m3u8?deliveryProfileId=4712"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "Trailer - 0_ksthpwh8",
                                mediaEntry: PKMediaEntry("0_ksthpwh8",
                                                         sources: [PKMediaSource("0_ksthpwh8",
                                                                                 contentUrl: URL(string: "http://cdnbakmi.kaltura.com/p/1758922/sp/175892200/playManifest/entryId/0_ksthpwh8/format/applehttp/tags/ipad/protocol/http/f/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "Bunny",
                                mediaEntry: PKMediaEntry("bunny",
                                                         sources: [PKMediaSource("bunny",
                                                                                 contentUrl: URL(string: "https://noamtamim.com/hls-bunny/index.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        let offlineSelectionOptionsSelectedLanguages = OfflineSelectionOptions()
            .setTextLanguages(["en", "ru"])
            .setAudioLanguages(["en"])
        
        videos.append(VideoData(title: "QA multi/multi - Selected Languages",
                                mediaEntry: PKMediaEntry("0_mskmqcit",
                                                         sources: [PKMediaSource("0_mskmqcit",
                                                                                 contentUrl: URL(string: "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_mskmqcit/flavorIds/0_et3i1dux,0_pa4k1rn9/format/applehttp/protocol/http/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedLanguages))
        
        let offlineSelectionOptionsSelectedBitrate = OfflineSelectionOptions()
            .setMinVideoBitrate(.avc1, 800_000)
            .setMinVideoBitrate(.hevc, 600_000)
        
        videos.append(VideoData(title: "hevc- - Selected Video Bitrate",
                                mediaEntry: PKMediaEntry("1_w9zx2eti",
                                                         sources: [PKMediaSource("1_w9zx2eti",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/0/playManifest/entryId/0_axrfacp3/format/applehttp/protocol/https/flavorParamIds/2390161,2390171,2390181,2390201,487091,487081,487071,487061/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedBitrate))
        
        let offlineSelectionOptionsSelectedBitrateAllowInefficientCodecs = OfflineSelectionOptions()
            .setMinVideoBitrate(.avc1, 800_000)
            .setMinVideoBitrate(.hevc, 600_000)
        
        offlineSelectionOptionsSelectedBitrateAllowInefficientCodecs.allowInefficientCodecs = true
        
        videos.append(VideoData(title: "hevc+ - Selected Video Bitrate",
                                mediaEntry: PKMediaEntry("1_w9zx2eti+",
                                                         sources: [PKMediaSource("1_w9zx2eti+",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/0/playManifest/entryId/0_axrfacp3/format/applehttp/protocol/https/flavorParamIds/2390161,2390171,2390181,2390201,487091,487081,487071,487061/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedBitrate))
        
        let offlineSelectionOptionsSelectedCodecsAllowInefficientCodecsNoHevc = OfflineSelectionOptions()
            .setPreferredVideoCodecs([.avc1])
        
        offlineSelectionOptionsSelectedCodecsAllowInefficientCodecsNoHevc.allowInefficientCodecs = true
        
        videos.append(VideoData(title: "hevc+ but no hevc - Selected Video Bitrate",
                                mediaEntry: PKMediaEntry("1_w9zx2eti+-",
                                                         sources: [PKMediaSource("1_w9zx2eti+-",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/0/playManifest/entryId/0_axrfacp3/format/applehttp/protocol/https/flavorParamIds/2390161,2390171,2390181,2390201,487091,487081,487071,487061/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedCodecsAllowInefficientCodecsNoHevc))
        
        let offlineSelectionOptionsSelectedVideoHeight = OfflineSelectionOptions()
            .setMinVideoHeight(360)
        
        videos.append(VideoData(title: "Kaltura 360p - Selected Video Height",
                                mediaEntry: PKMediaEntry("1_sf5ovm7u",
                                                         sources: [PKMediaSource("1_sf5ovm7u",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/243342/sp/24334200/playManifest/entryId/1_sf5ovm7u/format/applehttp/protocol/https/name/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedVideoHeight))
        
        let offlineSelectionOptionsSelectedVideoHeight2 = OfflineSelectionOptions()
            .setMinVideoHeight(720)
        
        videos.append(VideoData(title: "Kaltura 720p - Selected Video Height",
                                mediaEntry: PKMediaEntry("1_sf5ovm7u-720p",
                                                         sources: [PKMediaSource("1_sf5ovm7u-720p",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/243342/sp/24334200/playManifest/entryId/1_sf5ovm7u/format/applehttp/protocol/https/name/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedVideoHeight2))
        
        return videos
    }
}
