//
//  MediasTableViewController.swift
//  OTTSample_tvOS
//
//  Created by Nilit Danan on 12/20/20.
//

import UIKit

class UIMediaHeaderTableViewCell: UITableViewCell {
//    @IBOutlet weak var changeMedia: check!

    func shouldDestroyPlayer() -> Bool {
        return true//!changeMediaSwitch.isOn
    }
}

class MediasTableViewController: UITableViewController {
    
    var videos: [VideoData] = []
    var videoDataType: MenuItem = .basic
    
    var mediaPlayerViewController: MediaPlayerViewController?
    var headerTableViewCell: UIMediaHeaderTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        }
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
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if headerTableViewCell == nil {
//            headerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UIMediaHeaderTableViewCell") as? UIMediaHeaderTableViewCell
//        }
//        return headerTableViewCell
//    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mediaPlayerViewController == nil || headerTableViewCell?.shouldDestroyPlayer() == true {
            mediaPlayerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MediaPlayerViewController") as? MediaPlayerViewController
        }
        
        guard let playerVC = mediaPlayerViewController else { return }
        
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

