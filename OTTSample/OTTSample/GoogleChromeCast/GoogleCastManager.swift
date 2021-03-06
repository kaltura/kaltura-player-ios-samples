//
//  GoogleCastManager.swift
//  OTTSample
//
//  Created by Nilit Danan on 2/3/21.
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
        
        castBuilder.set(contentId: videoData.media.assetId)
        castBuilder.set(kalturaAssetType: cafKalturaAssetType(from: videoData.media.assetType))
        castBuilder.set(assetReferenceType: cafAssetReferenceType(from: videoData.media.assetReferenceType))
        castBuilder.set(contentType: videoData.media.playbackContextType.description)
        
        if let ks = videoData.media.ks {
            castBuilder.set(ks: ks)
        }
        
        if let formats = videoData.media.formats {
            castBuilder.set(formats: formats)
        }
        
        if let fileIds = videoData.media.fileIds, !fileIds.isEmpty {
            castBuilder.set(fileIds: fileIds.joined(separator: ","))
        }
        
        if let networkProtocol = videoData.media.networkProtocol {
            castBuilder.set(httpProtocol: cafHttpProtocol(from: networkProtocol))
        }
        
        if let urlType = videoData.media.urlType {
            castBuilder.set(urlType: cafUrlType(from: urlType))
        }
        
        if let streamerType = videoData.media.streamerType {
            castBuilder.set(streamType: cafStreamType(from: streamerType))
        }
        
        if let pluginConfig = videoData.player.pluginConfig, let imaConfig: IMAConfig = pluginConfig.config[IMAPlugin.pluginName] as? IMAConfig {
            castBuilder.set(adTagURL: imaConfig.adTagUrl)
            castBuilder.set(adTagType: cafAdTagType(from: videoData.castAdditionalData?.adTagType))
        }
        
        let mediaInformation = try castBuilder.build()
        return mediaInformation
    }
    
    private func load(mediaInformation:GCKMediaInformation, appending: Bool, startTime: TimeInterval?) -> Void {
        guard let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient else { return }
       
        let mediaQueueItemBuilder = GCKMediaQueueItemBuilder()
        
        mediaQueueItemBuilder.mediaInformation = mediaInformation
        mediaQueueItemBuilder.autoplay = true
        // TODO:: remove/ ask product
        mediaQueueItemBuilder.preloadTime = 0
        
        let mediaQueueItem = mediaQueueItemBuilder.build()
        
        if appending {
            let request: GCKRequest
            if let startTime = startTime {
                request = remoteMediaClient.queueInsertAndPlay(mediaQueueItem, beforeItemWithID: kGCKMediaQueueInvalidItemID, playPosition: startTime, customData: nil)
            } else {
                request = remoteMediaClient.queueInsert(mediaQueueItem, beforeItemWithID: kGCKMediaQueueInvalidItemID)
            }
          request.delegate = self
        } else {
          let queueDataBuilder = GCKMediaQueueDataBuilder(queueType: .generic)
          queueDataBuilder.items = [mediaQueueItem]
          queueDataBuilder.repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off

          let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
          mediaLoadRequestDataBuilder.mediaInformation = mediaInformation
          mediaLoadRequestDataBuilder.queueData = queueDataBuilder.build()
            
            if let startTime = startTime {
                mediaLoadRequestDataBuilder.startTime = startTime
            }

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
                self.load(mediaInformation: mediaInformation, appending: false, startTime: videoData.media.startTime)
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
    private func cafKalturaAssetType(from assetType: AssetType) -> CAFCastBuilder.CAFKalturaAssetType {
        var cafKalturaAssetType: CAFCastBuilder.CAFKalturaAssetType = .media
        
        switch assetType {
        case .epg:
            cafKalturaAssetType = .epg
        case .recording:
            cafKalturaAssetType = .recording
        default:
            cafKalturaAssetType = .media
        }
        
        return cafKalturaAssetType
    }
    
    private func cafAssetReferenceType(from assetReferenceType: AssetReferenceType) -> CAFCastBuilder.CAFAssetReferenceType {
        var cafAssetReferenceType: CAFCastBuilder.CAFAssetReferenceType = .media
        
        switch assetReferenceType {
        case .epgInternal:
            cafAssetReferenceType = .epgInternal
        case .epgExternal:
            cafAssetReferenceType = .epgExternal
        default:
            cafAssetReferenceType = .media
        }
        
        return cafAssetReferenceType
    }
    
    private func cafHttpProtocol(from networkProtocol: String?) -> CAFCastBuilder.CAFHttpProtocol {
        var cafHttpProtocol: CAFCastBuilder.CAFHttpProtocol = .all
        
        switch networkProtocol?.lowercased() {
        case "http":
            cafHttpProtocol = .http
        case "https":
            cafHttpProtocol = .https
        default:
            cafHttpProtocol = .all
        }
        
        return cafHttpProtocol
    }
    
    private func cafUrlType(from urlType: String?) -> CAFCastBuilder.CAFUrlType {
        var cafUrlType: CAFCastBuilder.CAFUrlType = .playmanifest
        
        switch urlType?.lowercased() {
        case "playmanifest":
            cafUrlType = .playmanifest
        case "direct":
            cafUrlType = .direct
        default:
            cafUrlType = .playmanifest
        }
        
        return cafUrlType
    }
    
    private func cafStreamType(from streamerType: String?) -> BasicCastBuilder.StreamType {
        var cafStreamType: BasicCastBuilder.StreamType = .unknown
        
        switch streamerType?.lowercased() {
        case "live":
            cafStreamType = .live
        case "vod":
            cafStreamType = .vod
        default:
            cafStreamType = .unknown
        }
        
        return cafStreamType
    }
    
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
