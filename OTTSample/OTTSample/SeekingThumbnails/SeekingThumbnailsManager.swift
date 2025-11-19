//
//  SeekingThumbnailsManager.swift
//  OTTSample
//
//  Created by Виктор on 11.11.2025.
//  Copyright © 2025 Kaltura Inc. All rights reserved.
//

import Foundation
import KalturaPlayer

//AG
/////////////////

class SeekingThumbnailsManager {
    
    @objc public var kalturaPlayer: KalturaPlayer?
    @objc public var granularity: Float64 = 1
    
    private var thumbnailsCache: [Float64: ThumbnailInfo] = [:]
    private var lastRequestedPosition: Float64?
    
    private var queue: DispatchQueue = .init(label: "seekingThumbnailsQueue")
    
    @objc public func getThumbnailInfo(for position: Float64, params: ThumbnailRequestParams?, completion: @escaping (ThumbnailInfo?) -> Void) {
        DispatchQueue.global().async {
            let positionApplyingGranularity = self.positionApplyingGranularity(position)
            var cachedInfo: ThumbnailInfo?
            self.queue.sync { // to prevent crash during parallel requests
                cachedInfo = self.thumbnailsCache[positionApplyingGranularity]
            }
            if let cachedInfo {
                completion(cachedInfo)
            } else {
                self.lastRequestedPosition = positionApplyingGranularity
                self.kalturaPlayer?.getThumbnailInfo(for: positionApplyingGranularity, params: params) { [weak self] info in
                    guard let self else { return }
                    self.thumbnailsCache[positionApplyingGranularity] = info
                    if positionApplyingGranularity == self.lastRequestedPosition {
                        completion(info)
                    }
                }
            }
        }
    }
    
    private func positionApplyingGranularity(_ position: Float64) -> Float64 {
        position - position.truncatingRemainder(dividingBy: granularity)
    }
    
}

/////////////////
