//
//  MediasTableViewController.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/5/20.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initVideos()
    }
    
    func initVideos() {
        // Sending a free form Media
        videos.append(VideoData(title: "Sintel - Free Form Media - Defaults",
                                freeFormMedia: FreeFormMedia(id: "sintel",
                                                             contentUrl: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8")))
        
        videos.append(VideoData(title: "Sintel - Free Form Media - autoPlay false",
                                freeFormMedia: FreeFormMedia(id: "sintel",
                                                             contentUrl: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"),
                                autoPlay: false))
        
        videos.append(VideoData(title: "Sintel - Free Form Media - startPosition 30",
                                freeFormMedia: FreeFormMedia(id: "sintel",
                                                             contentUrl: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"),
                                startTime: 30.0))
        
        videos.append(VideoData(title: "Free Form Media - error",
                                freeFormMedia: FreeFormMedia(id: "1_tzhsuqij",
                                                             contentUrl: "http://cdnapi.kaltura.com/p/1774581/sp/177458100/playManifest/entryId/1_tzhsuqij1/format/applehttp/tags/ipad/protocol/http/f/a.m3u8")))
        
        videos.append(VideoData(title: "Kaltura Live with DVR - auto play",
                                freeFormMedia: FreeFormMedia(id: "0_nwkp7jtx",
                                                             contentUrl: "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_nwkp7jtx/protocol/http/format/applehttp/flavorIds/0_iju7j519,0_98mlrldo,0_5hts3h5r,0_n6n76xp9/a.m3u8",
                                                             mediaType: .live),
                                autoPlay: true))
        
        // Sending a MediaEntry
        let contentURL = URL(string: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8")
        let entryId = "KalturaMedia"
        let source = PKMediaSource(entryId, contentUrl: contentURL, mediaFormat: .hls)
        let sources: Array = [source]
        let mediaEntry = PKMediaEntry(entryId, sources: sources, duration: -1)
        videos.append(VideoData(title: "KalturaMedia - MediaEntry - Defaults", mediaEntry: mediaEntry))
        
        videos.append(VideoData(title: "KalturaMedia - MediaEntry - autoPlay false", mediaEntry: mediaEntry, autoPlay: false))
        
        videos.append(VideoData(title: "KalturaMedia - MediaEntry - startPosition 10", mediaEntry: mediaEntry, startTime: 10.0))
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
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "UIMediaHeaderTableViewCell")
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playerViewController: PlayerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: playerType.storyboardID()) as? PlayerViewController else { return }
        
        playerViewController.videoData = videos[indexPath.row]
        playerViewController.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(playerViewController, animated: true, completion: {
            
        })
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "UIMediaHeaderTableViewCell")
        return headerCell?.frame.height ?? 45.0
    }
}
