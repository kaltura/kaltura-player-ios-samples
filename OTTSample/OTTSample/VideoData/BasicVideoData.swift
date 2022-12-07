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
        
        let ks = "djJ8ODMzN3wTu6k1x9Wkafy3_a8FAquZFghLc82OnH_lc3lGTEqxWGGeI0V76i-lWsqYmPj3fJ9Obgpki9zN8zYknBzZwNTYQYQGgY7NYBydwZWouC6Bqzo1E0cupSraJ7vWno-hLptQVJUv4alXC1wTx0_s6KB2paPzBOI6i7O4K8Ai-TglTE_rjhh3ggTXjm6IJ5LxwsFFIhVWn86tML_gJ18sJyRnkQpwdQ27dB8VJ-o5P5oo74IwNwL-sYgi7jxv4JKTPYhdR6oyMI5YMcQp5dO4F_rdN6kS_dZu8zDkKVNuRdg0Ukprlsec-N61XeXPh4_aSttInuLMcPdPAZ3MJAvypYOohi4Yjgc4kl9-zzJTAU1RZ7VNRX9HLeqiNvmIX6AMrCBeZKjG22d5OhdDqYjdo7oH9ILwzIk9A1kzTm7vRlNPKA=="
        
        
        
        videos.append(VideoData(title: "* 3516688, autoPlay-true, preload-true",
                                player: PlayerData(autoPlay: true,
                                                   preload: true,
                                                   ks: ks),
                                media: OTTMedia(assetId: "3516688",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                fileIds: ["36080467"],
                                                networkProtocol: "https"),
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
