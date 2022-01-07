//
//  UIMediaDownloadTableViewCell.swift
//  BasicSample
//
//  Created by Nilit Danan on 6/26/20.
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
            if let newVideoData = videoData, let mediaEntry = newVideoData.mediaEntry {
                let assetInfo = OfflineManager.shared.getAssetInfo(assetId: mediaEntry.id)
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
        guard let mediaEntry = videoData?.mediaEntry else { return false }
        guard let assetInfo = OfflineManager.shared.getAssetInfo(assetId: mediaEntry.id) else { return false }
        
        return assetInfo.state == .completed
    }
}

// MARK: - Actions

extension UIMediaDownloadTableViewCell {
    @IBAction private func downloadButtonClicked(_ sender: Any) {
        guard let videoData = videoData, let mediaEntry = videoData.mediaEntry, let offlineSelectionOptions = videoData.offlineSelectionOptions else {
            return
        }
        
        switch downloadButton.displayState {
        case .download:
            downloadButton.displayState = .pause
            OfflineManager.shared.prepareAsset(mediaEntry: mediaEntry,
                                               options: offlineSelectionOptions) { [weak self] (error, assetInfo) in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    if let assetInfo = assetInfo, error == nil {
                        do {
                            try OfflineManager.shared.startAssetDownload(assetId: assetInfo.itemId)
                        } catch {
                            if let err = error as? OfflineManagerError {
                                self.presentAlert(withMessage: err.errorDescription)
                            } else {
                                self.presentAlert(withMessage: error.localizedDescription)
                            }
                            self.downloadButton.displayState = .error
                        }
                    }
                    else {
                        let errorMessage = (error as? OfflineManagerError)?.errorDescription ?? error?.localizedDescription
                        self.presentAlert(withMessage: errorMessage)
                        self.downloadButton.displayState = .error
                    }
                }
            }
        case .resume:
            downloadButton.displayState = .pause
            do {
                try OfflineManager.shared.startAssetDownload(assetId: mediaEntry.id)
            } catch {
                if let err = error as? OfflineManagerError {
                    presentAlert(withMessage: err.errorDescription)
                } else {
                    presentAlert(withMessage: error.localizedDescription)
                }
                downloadButton.displayState = .error
            }
        case .pause:
            downloadButton.displayState = .resume
            try? OfflineManager.shared.pauseAssetDownload(assetId: mediaEntry.id)
        case .complete:
            try? OfflineManager.shared.removeAssetDownload(assetId: mediaEntry.id)
        case .error:
            downloadButton.displayState = .download
        }
    }
}

// MARK: - Error Alert

extension UIMediaDownloadTableViewCell {
    func presentAlert(withMessage message: String?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        window?.rootViewController?.present(alert, animated: true)
    }
}
