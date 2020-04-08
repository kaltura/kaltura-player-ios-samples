//
//  MediasTableViewController.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit
import PlayKit

class MediasTableViewController: UITableViewController {
    
    var videos: [VideoData] = []
    var playerType: PlayerType = .Custom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initVideos()
    }
    
    func initVideos() {
        videos.append(VideoData(title: "Sintel - Free Form Media - Defaults", freeFormMedia: FreeFormMedia(id: "sintel", contentUrl: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8")))
        
        videos.append(VideoData(title: "Sintel - Free Form Media - autoPlay false", freeFormMedia: FreeFormMedia(id: "sintel", contentUrl: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"), autoPlay: false))
        
        videos.append(VideoData(title: "Sintel - Free Form Media - startPosition 30", freeFormMedia: FreeFormMedia(id: "sintel", contentUrl: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"), startTime: 30.0))
        
        // New Media
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playerViewController: PlayerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: playerType.storyboardID()) as? PlayerViewController else { return }
        
        playerViewController.videoData = videos[indexPath.row]
        playerViewController.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(playerViewController, animated: true, completion: {
            
        })
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
