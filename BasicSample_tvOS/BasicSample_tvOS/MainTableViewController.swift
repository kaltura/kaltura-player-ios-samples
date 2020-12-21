//
//  MainTableViewController.swift
//  BasicSample_tvOS
//
//  Created by Nilit Danan on 12/17/20.
//

import UIKit

enum MenuItem: Int, CaseIterable, CustomStringConvertible {
    case basic = 0
    case ima
    case imaDAI
    case youbora
    case youboraIMA
    case youboraIMADAI
    
    var description: String {
        switch self {
        case .basic: return "Basic Sample"
        case .ima: return "IMA Sample"
        case .imaDAI: return "IMA DAI Sample"
        case .youbora: return "Youbora Sample"
        case .youboraIMA: return "Youbora with IMA Sample"
        case .youboraIMADAI: return "Youbora with IMA DAI Sample"
        }
    }
}

class MainTableViewController: UITableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMedias" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                if let mediasTableViewController = segue.destination as? MediasTableViewController {
                    guard let menuItem = MenuItem(rawValue: indexPath.row) else { return }
                    mediasTableViewController.videoDataType = menuItem
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
