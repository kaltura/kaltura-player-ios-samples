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
//    case pkMediaPlayer
    
    var description: String {
        switch self {
        case .basic: return "Basic Sample"
//        case .pkMediaPlayer: return "Using PKMediaPlayer"
        }
    }
}

class MainTableViewController: UITableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMedias" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                if let mediasTableViewController = segue.destination as? MediasTableViewController {
                    let menuItem = MenuItem(rawValue: indexPath.row)
                    switch menuItem {
                    case .basic:
                        mediasTableViewController.playerType = .Custom
//                    case .pkMediaPlayer:
//                        mediasTableViewController.playerType = .PlayKitUI
                    case .none:
                        break
                    }
                }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
