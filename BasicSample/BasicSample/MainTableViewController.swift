//
//  MainTableViewController.swift
//  BasicSample
//
//  Created by Nilit Danan on 2/3/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import UIKit

enum MenuItem: Int, CaseIterable, CustomStringConvertible {
    case basic = 0
    case ima
    case imaDAI
    case youbora
    case youboraIMA
    case youboraIMADAI
    case offline
    
    var description: String {
        switch self {
        case .basic: return "Basic Sample"
        case .ima: return "IMA Sample"
        case .imaDAI: return "IMA DAI Sample"
        case .youbora: return "Youbora Sample"
        case .youboraIMA: return "Youbora with IMA Sample"
        case .youboraIMADAI: return "Youbora with IMA DAI Sample"
        case .offline: return "Offline Sample"
        }
    }
}

protocol MediasView {
    var videoDataType: MenuItem { get set }
}

class UIPlaylistHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var playlistSwitch: UISwitch!
    
    func shouldShowAsPlaylist() -> Bool {
        return playlistSwitch.isOn
    }
}

class MainTableViewController: UITableViewController {
    
    var headerTableViewCell: UIPlaylistHeaderTableViewCell?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let menuItem = MenuItem(rawValue: indexPath.row) else { return }
            if var mediasView = segue.destination as? MediasView {
                mediasView.videoDataType = menuItem
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuItem.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let menuItem = MenuItem(rawValue: indexPath.row)
        cell.textLabel?.text = menuItem?.description
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headerTableViewCell == nil {
            headerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UIPlaylistHeaderTableViewCell") as? UIPlaylistHeaderTableViewCell
        }
        return headerTableViewCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let playlistTableViewCell = headerTableViewCell,  playlistTableViewCell.shouldShowAsPlaylist() {
            let menuItem = MenuItem(rawValue: indexPath.row)
            if menuItem == .offline {
                let alert = UIAlertController(title: nil, message: "Offline not implemented in playlist", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "ShowPlaylist", sender: indexPath);
            }
        } else {
            self.performSegue(withIdentifier: "ShowMedias", sender: indexPath);
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "UIPlaylistHeaderTableViewCell")
        return headerCell?.frame.height ?? 45.0
    }
}
