//
//  MediasTableViewController.swift
//  OTTSample
//
//  Created by Nilit Danan on 5/3/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit
import PlayKit

class UIMediaHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var changeMediaSwitch: UISwitch!
    
    func shouldDestroyPlayer() -> Bool {
        return !changeMediaSwitch.isOn
    }
}

class MediasTableViewController: UITableViewController {
    
    var videos: [VideoData] = []
    var playerType: PlayerType = .Custom
    
    var playerViewController: PlayerViewController?
    var headerTableViewCell: UIMediaHeaderTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initVideos()
    }
    
    func initVideos() {
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

        videos.append(VideoData(title: "548575, autoPlay-false, preload-false",
                                player: PlayerData(autoPlay: false, preload: false),
                                media: OTTMedia(assetId: "548575",
                                                assetType: .media,
                                                assetReferenceType: .media,
                                                playbackContextType: .playback,
                                                networkProtocol: "http")))
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIMediaTableViewCell", for: indexPath)
        
        cell.textLabel?.text = videos[indexPath.row].title
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headerTableViewCell == nil {
            headerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UIMediaHeaderTableViewCell") as? UIMediaHeaderTableViewCell
        }
        return headerTableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if playerViewController == nil || headerTableViewCell?.shouldDestroyPlayer() == true {
            playerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: playerType.storyboardID()) as? PlayerViewController
        }
        
        guard let playerVC = playerViewController else { return }
        
        playerVC.videoData = videos[indexPath.row]
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
