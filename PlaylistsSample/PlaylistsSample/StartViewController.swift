//
//  StartViewController.swift
//  PlaylistsSample
//
//  Created by Sergey Chausov on 11.11.2021.
//

import UIKit

class StartViewController: UIViewController {
    
    var playlistType: PlaylistType = .basic
    
    @IBOutlet weak var pluginsEnabledSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showBasic(_ sender: Any) {
        playlistType = .basic
        self.performSegue(withIdentifier: "ShowPlaylist", sender: sender)
    }
    
    @IBAction func showOtt(_ sender: Any) {
        playlistType = .ott
        self.performSegue(withIdentifier: "ShowPlaylist", sender: sender)
    }
    
    @IBAction func showOvp(_ sender: Any) {
        playlistType = .ovp
        self.performSegue(withIdentifier: "ShowPlaylist", sender: sender)
    }
    
    @IBAction func showOvpById(_ sender: Any) {
        playlistType = .ovpId
        self.performSegue(withIdentifier: "ShowPlaylist", sender: sender)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? PlaylistViewController {
            viewController.playlistType = self.playlistType
            viewController.pluginsEnabled = self.pluginsEnabledSwitch.isOn
        }
    }
    
}
