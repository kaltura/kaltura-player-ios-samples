//
//  UIMediaDownloadTableViewCell.swift
//  OVPSample
//
//  Created by Nilit Danan on 8/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import Foundation
import UIKit
import KalturaPlayer

class UIDownloadButton: UIButton {
    enum downloadState {
        case download
        case resume
        case pause
        case complete
        case error
    }
    
    var displayState: downloadState = .download {
        didSet {
            switch displayState {
            case .download:
                setImage(UIImage(named: "download"), for: .normal)
            case .resume:
                setImage(UIImage(named: "play"), for: .normal)
            case .pause:
                setImage(UIImage(named: "pause"), for: .normal)
            case .complete:
                setImage(UIImage(named: "delete"), for: .normal)
            case .error:
                setImage(UIImage(named: "error"), for: .normal)
            }
        }
    }
}

class UIMediaDownloadTableViewCell: UITableViewCell, DownloadMediaTableViewCell {

    @IBOutlet private weak var mediaLabel: UILabel!
    @IBOutlet private weak var downloadProgressView: CircleProgressView!
    @IBOutlet private weak var downloadButton: UIDownloadButton!

    var videoData: VideoData? {
        didSet {
            if videoData == nil { return }
            if let newVideoData = videoData,
               let entryId = newVideoData.media.entryId {
                let assetInfo = OfflineManager.shared.getAssetInfo(assetId: entryId)
                updateProgress(assetInfo?.progress ?? 0.0)
                updateDownloadState(assetInfo?.state ?? AssetDownloadState.new)
            }
            
            // force layout
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // MARK: - UITableViewCell Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mediaLabel.text = videoData?.title
    }
}

// MARK: - DownloadMediaTableViewCell

extension UIMediaDownloadTableViewCell {
    public func updateProgress(_ value: Float) {
        self.downloadProgressView.progressAnimation(toValue: value)
    }
    
    public func updateDownloadState(_ state: AssetDownloadState) {
        switch state {
        case .new:
            if self.downloadButton.displayState == .pause { return }
            self.downloadButton.displayState = .download
            self.updateProgress(0.0)
        case .prepared,.started:
            self.downloadButton.displayState = .pause
        case .paused:
            self.downloadButton.displayState = .resume
        case .completed:
            self.downloadButton.displayState = .complete
            self.updateProgress(1.0)
        case .failed, .outOfSpace:
            self.downloadButton.displayState = .error
        }
    }
    
    func canPlayDownloadedMedia() -> Bool {
        guard let media = videoData?.media else { return false }
        guard let entryId = media.entryId, let assetInfo = OfflineManager.shared.getAssetInfo(assetId: entryId) else { return false }
        
        return assetInfo.state == .completed
    }
}

// MARK: - Actions

extension UIMediaDownloadTableViewCell {
    @IBAction private func downloadButtonClicked(_ sender: Any) {
        guard let videoData = videoData,
              let offlineSelectionOptions = videoData.offlineSelectionOptions,
              let entryId = videoData.media.entryId else {
            return
        }
        
        switch downloadButton.displayState {
        case .download:
            downloadButton.displayState = .pause
            
            OfflineManager.shared.prepareAsset(mediaOptions: videoData.media.mediaOptions(),
                                               options: offlineSelectionOptions) { (error, assetInfo, pkMediaEntry)  in
                DispatchQueue.main.async {
                    if let assetInfo = assetInfo, error == nil {
                        try? OfflineManager.shared.startAssetDownload(assetId: assetInfo.itemId)
                    }
                    else {
                        self.downloadButton.displayState = .error
                    }
                }
            }
        case .resume:
            downloadButton.displayState = .pause
            try? OfflineManager.shared.startAssetDownload(assetId: entryId)
        case .pause:
            downloadButton.displayState = .resume
            try? OfflineManager.shared.pauseAssetDownload(assetId: entryId)
        case .complete:
            try? OfflineManager.shared.removeAssetDownload(assetId: entryId)
        case .error:
            downloadButton.displayState = .download
        }
    }
}
