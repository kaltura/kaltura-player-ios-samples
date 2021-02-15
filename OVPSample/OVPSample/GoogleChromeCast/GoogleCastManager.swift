//
//  GoogleCastManager.swift
//  OVPSample
//
//  Created by Nilit Danan on 2/11/21.
//  Copyright © 2021 Kaltura Inc. All rights reserved.
//

import Foundation
import GoogleCast
import PlayKitGoogleCast
import PlayKitProviders
import PlayKit_IMA

/* The player state. */
enum PlaybackMode: Int {
  case none = 0
  case local
  case remote
}

class GoogleCastManager: NSObject, GCKRequestDelegate {
    
    fileprivate var enableSDKLogging = true
    private var playbackMode = PlaybackMode.none
    
    public static let sharedInstance = GoogleCastManager()
    
    // MARK: - Private Functions
    
    private func setupCastLogging() {
      let logFilter = GCKLoggerFilter()
      let classesToLog = ["GCKDeviceScanner", "GCKDeviceProvider", "GCKDiscoveryManager", "GCKCastChannel",
                          "GCKMediaControlChannel", "GCKUICastButton", "GCKUIMediaController", "NSMutableDictionary"]
      logFilter.setLoggingLevel(.verbose, forClasses: classesToLog)
      GCKLogger.sharedInstance().filter = logFilter
      GCKLogger.sharedInstance().delegate = self
    }
    
    private func getCAFMediaInformation(from videoData: VideoData) throws -> GCKMediaInformation {
        let castBuilder = CAFCastBuilder()
        
        castBuilder.set(contentId: videoData.media.entryId)
        
        if let ks = videoData.media.ks {
            castBuilder.set(ks: ks)
        }
        
        if let uiconfID = videoData.media.uiconfId {
            castBuilder.set(uiconfID: uiconfID.stringValue)
        }
        
        if let pluginConfig = videoData.player.pluginConfig, let imaConfig: IMAConfig = pluginConfig.config[IMAPlugin.pluginName] as? IMAConfig {
            castBuilder.set(adTagURL: imaConfig.adTagUrl)
            castBuilder.set(adTagType: cafAdTagType(from: videoData.castAdditionalData?.adTagType))
        }
        
        let mediaInformation = try castBuilder.build()
        return mediaInformation
    }
    
    private func load(mediaInformation:GCKMediaInformation, appending: Bool) -> Void {
        guard let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient else { return }
       
        let mediaQueueItemBuilder = GCKMediaQueueItemBuilder()
        
        mediaQueueItemBuilder.mediaInformation = mediaInformation
        mediaQueueItemBuilder.autoplay = true
        // TODO:: remove/ ask product
        mediaQueueItemBuilder.preloadTime = 0
        
        let mediaQueueItem = mediaQueueItemBuilder.build()
        
        if appending {
          let request = remoteMediaClient.queueInsert(mediaQueueItem, beforeItemWithID: kGCKMediaQueueInvalidItemID)
          request.delegate = self
        } else {
          let queueDataBuilder = GCKMediaQueueDataBuilder(queueType: .generic)
          queueDataBuilder.items = [mediaQueueItem]
          queueDataBuilder.repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off

          let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
          mediaLoadRequestDataBuilder.mediaInformation = mediaInformation
          mediaLoadRequestDataBuilder.queueData = queueDataBuilder.build()

          let request = remoteMediaClient.loadMedia(with: mediaLoadRequestDataBuilder.build())
          request.delegate = self
        }
    }
    
    func switchToLocalPlayback() {
        print("switchToLocalPlayback")
        if playbackMode == .local { return }
        
        GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.remove(self)
        GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.adInfoParserDelegate = nil
        playbackMode = .local
    }
    
    func switchToRemotePlayback() {
        print("switchToRemotePlayback")
        if playbackMode == .remote { return }
        
        GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.add(self)
        GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.adInfoParserDelegate = CastAdInfoParser.shared
        playbackMode = .remote
    }

    // MARK: - Public Functions
    
    public func setup(applicationId: String) {
        // Set your receiver application ID.
        let options = GCKCastOptions(discoveryCriteria: GCKDiscoveryCriteria(applicationID: applicationId))
        options.physicalVolumeButtonsWillControlDeviceVolume = true
        
        // Following code enables CastConnect
        let launchOptions = GCKLaunchOptions()
        launchOptions.androidReceiverCompatible = true
        options.launchOptions = launchOptions
        
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        
        // Theme the cast button using UIAppearance.
        GCKUICastButton.appearance().tintColor = UIColor.gray
        
        setupCastLogging()
        
        GCKCastContext.sharedInstance().sessionManager.add(self)
        GCKCastContext.sharedInstance().imagePicker = self
    }
    
    public func isConnected() -> Bool {
        return GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession()
    }
    
    public func cast(videoData: VideoData) {
        var gckMediaInformation: GCKMediaInformation? = nil
        do {
            // V3
            gckMediaInformation = try getCAFMediaInformation(from: videoData)
            
            if let mediaInformation = gckMediaInformation {
                self.load(mediaInformation: mediaInformation, appending: false)
            }
            
        } catch {
            print(error)
        }
    }
    
    public func showExpandedControl() -> Void {
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }
}

// MARK: - CAFCastBuilder Helpers

extension GoogleCastManager {
    private func cafAdTagType(from adTagType: String?) -> CAFCastBuilder.CAFAdTagType {
        var cafAdTagType: CAFCastBuilder.CAFAdTagType = .unset
        
        switch adTagType?.lowercased() {
        case "vast":
            cafAdTagType = .vast
        case "vmap":
            cafAdTagType = .vmap
        default:
            cafAdTagType = .unset
        }
        
        return cafAdTagType
    }
}

// MARK: - GCKSessionManagerListener

extension GoogleCastManager: GCKSessionManagerListener {
    
    func sessionManager(_: GCKSessionManager, didStart session: GCKSession) {
        print("SessionManager didStartSession \(session)")
        switchToRemotePlayback()
    }

    func sessionManager(_: GCKSessionManager, didResumeSession session: GCKSession) {
        print("SessionManager didResumeSession \(session)")
        switchToRemotePlayback()
    }
    
    func sessionManager(_: GCKSessionManager, didEnd _: GCKSession, withError error: Error?) {
        print("SessionManager ended with error: \(String(describing: error))")
        switchToLocalPlayback()
    }

    func sessionManager(_: GCKSessionManager, didFailToStartSessionWithError error: Error?) {
        print("SessionManager failed to start a session with error: \(String(describing: error))")
    }

    func sessionManager(_: GCKSessionManager, didFailToResumeSession _: GCKSession, withError error: Error?) {
        print("SessionManager failed to resume the session with error: \(String(describing: error))")
        switchToLocalPlayback()
    }
}

// MARK: - GCKLoggerDelegate

extension GoogleCastManager: GCKLoggerDelegate {
    
    func logMessage(_ message: String, at _: GCKLoggerLevel, fromFunction function: String, location: String) {
        if enableSDKLogging {
            // Send SDK's log messages directly to the console.
            print("\(location): \(function) - \(message)")
        }
    }
}

// MARK: - GCKUIImagePicker

extension GoogleCastManager: GCKUIImagePicker {
    
    func getImageWith(_ imageHints: GCKUIImageHints, from metadata: GCKMediaMetadata) -> GCKImage? {
        let images = metadata.images
        guard !images().isEmpty else {
            print("No images available in media metadata.");
            return nil
        }
        
        if images().count > 1, imageHints.imageType == .background {
          return images()[1] as? GCKImage
        } else {
          return images()[0] as? GCKImage
        }
    }
}

// MARK: - GCKRemoteMediaClientListener

extension GoogleCastManager: GCKRemoteMediaClientListener {
    // Implement methods if needed.
}
