//
//  MediasTableViewController.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit


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
