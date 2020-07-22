//
//  MediasTableViewController.swift
//  OTTSample
//
//  Created by Nilit Danan on 5/3/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit
import KalturaPlayer

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
                let pkMediaEntry = OfflineManager.shared.getLocalPlaybackEntry(assetId: videos[indexPath.row].media.assetId)
                if let mediaEntry = pkMediaEntry {
                    if let drmStatus = OfflineManager.shared.getDRMStatus(assetId: mediaEntry.id), drmStatus.isValid() == false {
                        OfflineManager.shared.renewAssetDRMLicense(mediaOptions: videos[indexPath.row].media.mediaOptions())
                        var message = ""
                        if let drmStatus = OfflineManager.shared.getDRMStatus(assetId: mediaEntry.id), drmStatus.isValid() == false {
                            message = "The DRM License was not renewed, can't play locally."
                        }
                        else {
                            message = "The DRM License was renewed, click again."
                        }
                        
                        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
        
        return indexPath
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "UIMediaHeaderTableViewCell")
        return headerCell?.frame.height ?? 45.0
    }
}

// MARK: - OfflineManagerDelegate

extension MediasTableViewController: OfflineManagerDelegate {

    func item(id: String, didDownloadData totalBytesDownloaded: Int64, totalBytesEstimated: Int64?) {
        if let index = self.videos.firstIndex(where: { $0.media.assetId == id }) {
            let progressValue = OfflineManager.shared.getAssetInfo(assetId: id)?.progress ?? 0.0
            DispatchQueue.main.async {
                let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! DownloadMediaTableViewCell
                cell.updateProgress(progressValue)
            }
        }
    }
    
    func item(id: String, didChangeToState newState: AssetDownloadState, error: Error?) {
        if let index = self.videos.firstIndex(where: { $0.media.assetId == id }) {
            if newState == .completed {
                OfflineManager.shared.renewAssetDRMLicense(mediaOptions: videos[index].media.mediaOptions())
            }
            DispatchQueue.main.async {
                let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! DownloadMediaTableViewCell
                cell.updateDownloadState(newState)
            }
        }
    }
}
