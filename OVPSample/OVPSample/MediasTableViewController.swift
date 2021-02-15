//
//  MediasTableViewController.swift
//  OVPSample
//
//  Created by Nilit Danan on 7/30/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import Foundation

import UIKit
import KalturaPlayer
import GoogleCast

protocol MediaTableViewCell: UITableViewCell {
    var videoData: VideoData? { get set }
}

protocol DownloadMediaTableViewCell: MediaTableViewCell {
    func updateProgress(_ value: Float)
    func updateDownloadState(_ state: AssetDownloadState)
    func canPlayDownloadedMedia() -> Bool
}

class UIMediaHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var changeMediaSwitch: UISwitch!
    
    func shouldDestroyPlayer() -> Bool {
        return !changeMediaSwitch.isOn
    }
}

class MediasTableViewController: UITableViewController {
    
    var videos: [VideoData] = []
    var playerType: PlayerType = .Custom
    var videoDataType: MenuItem = .basic
    
    var playerViewController: PlayerViewController?
    var headerTableViewCell: UIMediaHeaderTableViewCell?
    
    // For Google Chrome Cast
    private var castButton: GCKUICastButton!
    private var castSelectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        switch videoDataType {
        case .basic:
            videos = VideoData.getBasicVideos()
        case .ima:
            videos = VideoData.getIMAVideos()
        case .imaDAI:
            videos = VideoData.getIMADAIVideos()
        case .youbora:
            videos = VideoData.getYouboraVideos()
        case .youboraIMA:
            videos = VideoData.getYouboraIMAVideos()
        case .youboraIMADAI:
            videos = VideoData.getYouboraIMADAIVideos()
        case .offline:
            videos = VideoData.getOfflineVideos()
            OfflineManager.shared.offlineManagerDelegate = self
        }
        
        // For Google Chrome Cast
        addCastButton()
    }

    deinit {
        switch videoDataType {
        case .offline:
            OfflineManager.shared.offlineManagerDelegate = nil
        default:
            break
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MediaTableViewCell
        
        switch videoDataType {
        case .offline:
            cell = tableView.dequeueReusableCell(withIdentifier: "UIMediaDownloadTableViewCell", for: indexPath) as! MediaTableViewCell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "UIMediaTableViewCell", for: indexPath) as! MediaTableViewCell
        }
        
        cell.videoData = videos[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headerTableViewCell == nil {
            headerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UIMediaHeaderTableViewCell") as? UIMediaHeaderTableViewCell
        }
        return headerTableViewCell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if videoDataType == .offline {
            if let cell = tableView.cellForRow(at: indexPath) as? DownloadMediaTableViewCell, cell.canPlayDownloadedMedia() {
                let media = videos[indexPath.row].media
                if OfflineManager.shared.getLocalPlaybackEntry(assetId: media.entryId) != nil {
                    // In case the DRM media's license has expired, renew it.
                    if let drmStatus = OfflineManager.shared.getDRMStatus(assetId: media.entryId), drmStatus.isValid() == false {
                        OfflineManager.shared.renewAssetDRMLicense(mediaOptions: media.mediaOptions()) { (error) in
                            // Decide what to do with the error depending on the error.
                            var message = ""
                            if let drmStatus = OfflineManager.shared.getDRMStatus(assetId: media.entryId), drmStatus.isValid() == false {
                                message = "The DRM License was not renewed, can't play locally."
                            }
                            else {
                                message = "The DRM License was renewed, click again."
                            }
                            
                            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                        
                        // If the DRM Status is invalid, deny selection.
                        return nil
                    }
                } else {
                    // If we don't have the local media, deny selection.
                    return nil
                }
            } else {
                // If the media haven't completed the download, deny selection.
                return nil
            }
        }
        
        return indexPath
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if GoogleCastManager.sharedInstance.isConnected() {
            // For Google Chrome Cast
            if castSelectedIndexPath != indexPath {
                GoogleCastManager.sharedInstance.cast(videoData: videos[indexPath.row])
                castSelectedIndexPath = indexPath
            }
            
            GoogleCastManager.sharedInstance.showExpandedControl()
        } else {
            if playerViewController == nil || headerTableViewCell?.shouldDestroyPlayer() == true {
                playerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: playerType.storyboardID()) as? PlayerViewController
            }
            
            guard let playerVC = playerViewController else { return }
            
            playerVC.videoData = videos[indexPath.row]
            if videoDataType == .offline {
                playerVC.shouldPlayLocally = true
            }

            playerVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(playerVC, animated: true, completion: {

            })
            
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "UIMediaHeaderTableViewCell")
        return headerCell?.frame.height ?? 45.0
    }
}

// MARK: - OfflineManagerDelegate

extension MediasTableViewController: OfflineManagerDelegate {

    func item(id: String, didDownloadData totalBytesDownloaded: Int64, totalBytesEstimated: Int64, completedFraction: Float) {
        if let index = self.videos.firstIndex(where: { $0.media.entryId == id }) {
            DispatchQueue.main.async {
                guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DownloadMediaTableViewCell else { return }
                cell.updateProgress(completedFraction)
            }
        }
    }

    func item(id: String, didChangeToState newState: AssetDownloadState, error: Error?) {
        if let index = self.videos.firstIndex(where: { $0.media.entryId == id }) {
            if newState == .completed {
                // In case the DRM media was paused for too long and the license has expired, renew it.
                if let drmStatus = OfflineManager.shared.getDRMStatus(assetId: videos[index].media.entryId), drmStatus.isValid() == false {
                    OfflineManager.shared.renewAssetDRMLicense(mediaOptions: videos[index].media.mediaOptions()) { (error) in
                        // Decide what to do with the error depending on the error.
                    }
                }
            }
            DispatchQueue.main.async {
                guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DownloadMediaTableViewCell else { return }
                cell.updateDownloadState(newState)
            }
        }
    }
}

// MARK: - Google Chrome Cast

extension MediasTableViewController {
    
    func addCastButton() {
        castButton = GCKUICastButton(frame: CGRect(x: CGFloat(0),
                                                   y: CGFloat(0),
                                                   width: CGFloat(24),
                                                   height: CGFloat(24)))
        
        castButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
    }
}
