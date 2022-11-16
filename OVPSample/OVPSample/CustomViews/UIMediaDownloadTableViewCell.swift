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
import PlayKit
import DownloadToGo

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
            if let newVideoData = videoData {
                let assetInfo = OfflineManager.shared.getAssetInfo(assetId: newVideoData.media.entryId)
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
        guard let assetInfo = OfflineManager.shared.getAssetInfo(assetId: media.entryId) else { return false }
        
        return assetInfo.state == .completed
    }
}

// MARK: - Actions

extension UIMediaDownloadTableViewCell {
    @IBAction private func downloadButtonClicked(_ sender: Any) {
        guard let videoData = videoData, let offlineSelectionOptions = videoData.offlineSelectionOptions else {
            return
        }
        
        switch downloadButton.displayState {
        case .download:
            downloadButton.displayState = .pause
            
            OfflineManager.shared.setManifestRequestAdapter(requestAdapter: KalturaPlayerDTGRequestAdapter(sessionId: "",
                                                                                                           withAppName: "https://kaltura.uts.edu.au"))
            
            OfflineManager.shared.setReferrer("https://kaltura.uts.edu.au")
            
            OfflineManager.shared.prepareAsset(mediaOptions: videoData.media.mediaOptions(),
                                               options: offlineSelectionOptions) { [weak self] (error, assetInfo, pkMediaEntry) in
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
                try OfflineManager.shared.startAssetDownload(assetId: videoData.media.entryId)
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
            try? OfflineManager.shared.pauseAssetDownload(assetId: videoData.media.entryId)
        case .complete:
            try? OfflineManager.shared.removeAssetDownload(assetId: videoData.media.entryId)
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

public class KalturaPlayerDTGRequestAdapter: DTGRequestParamsAdapter {
    
    private var applicationName: String?
    private var sessionId: String?
    
    /// Init adapter.
    ///
    /// - Parameters:
    ///   - player: The player you want to use with the request adapter
    ///   - appName: the application name, if `nil` will use the bundle identifier.
    @objc init(sessionId: String,
               withAppName appName: String){
        self.sessionId = sessionId
        self.applicationName = appName
    }
    
    
    public func adapt(_ requestParams: DownloadToGo.DTGRequestParams) -> DownloadToGo.DTGRequestParams {
        
        guard let sessionId = self.sessionId else { return requestParams }
        guard requestParams.url.path.contains("/playManifest/") else { return requestParams }
        guard var urlComponents = URLComponents(url: requestParams.url, resolvingAgainstBaseURL: false) else { return requestParams }
        // add query items to the request
        let queryItems = [
            URLQueryItem(name: "playSessionId", value: sessionId),
            URLQueryItem(name: "clientTag", value: PlayKitManager.clientTag),
            URLQueryItem(name: "referrer", value: self.applicationName == nil ? self.base64(from: Bundle.main.bundleIdentifier ?? "") : self.base64(from: self.applicationName!))
        ]
        if var urlQueryItems = urlComponents.queryItems {
            urlQueryItems += queryItems
            urlComponents.queryItems = urlQueryItems
        } else {
            urlComponents.queryItems = queryItems
        }
        // create the url
        guard let url = urlComponents.url else {
            PKLog.debug("failed to create url after appending query items")
            return requestParams
        }
        
        return DTGRequestParams(url: url, headers: requestParams.headers)
        
    }
    
    private func base64(from: String) -> String {
        return from.data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
}
