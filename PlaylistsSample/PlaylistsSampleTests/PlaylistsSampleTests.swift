//
//  PlaylistsSampleTests.swift
//  PlaylistsSampleTests
//
//  Created by Sergii Chausov on 31.08.2021.
//

import Quick
import Nimble
import KalturaPlayer
@testable import PlaylistsSample

class PlaylistsSampleTests: QuickSpec {

    override func spec() {
        
        KalturaOVPPlayer.setup(partnerId: 1091,
                               serverURL: "https://qa-apache-php7.dev.kaltura.com",
                               referrer: nil)
        
        let ovpPlayerOptions = PlayerOptions()
        let kalturaOVPPlayer = KalturaOVPPlayer(options: ovpPlayerOptions)
        
        let playlistOptions = OVPPlaylistOptions()
        playlistOptions.playlistId = "0_wckoqjnn"
        
        describe("KalturaPlayer") {
            context("Loads playlist") {
                
                it("1. by playlist ID") {
                    waitUntil(timeout: .seconds(150)) { done in
                        
                        kalturaOVPPlayer.loadPlaylist(options: playlistOptions) { (error) in
                            
                            expect(error).to(beNil())

                            
                            done()
                        }
                    }
                }
                
                it("2. playNext") {
                    waitUntil(timeout: .seconds(150)) { done in
                        guard let controller = kalturaOVPPlayer.playlistController else {
                            fail("playlistController not instantiated")
                            done()
                            return
                        }
                        
                        controller.playNext()
                        done()
                    }
                }
                
            }
            
        }
        
    }
    
//    func playerOptions(_ videoData: VideoData?) -> PlayerOptions {
//        let playerOptions = PlayerOptions()
//
//        if let playerKS = videoData?.player.ks {
//            playerOptions.ks = playerKS
//        }
//        if let autoPlay = videoData?.player.autoPlay {
//            playerOptions.autoPlay = autoPlay
//        }
//        if let preload = videoData?.player.preload {
//            playerOptions.preload = preload
//        }
//        if let pluginConfig = videoData?.player.pluginConfig {
//            if let imaConfig = pluginConfig.config[IMAPlugin.pluginName] as? IMAConfig {
//                imaConfig.videoControlsOverlays = [controllersInteractiveView, topVisualEffectView, middleVisualEffectView, bottomVisualEffectView]
//            }
//            playerOptions.pluginConfig = pluginConfig
//        }
//
//        return playerOptions
//    }

}
