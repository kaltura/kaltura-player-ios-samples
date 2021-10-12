//
//  ViewController.swift
//  PlaylistsSample
//
//  Created by Sergii Chausov on 31.08.2021.
//

import UIKit
import KalturaPlayer

private let cellID = "PlaylistCellID"

class ViewController: UIViewController {

    @IBOutlet weak var playerView: KalturaPlayerView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var playNext: UIButton!
    @IBOutlet weak var playPrev: UIButton!
    
    @IBOutlet weak var playListTapleView: UITableView!
    
    var kalturaOVPPlayer: KalturaOVPPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KalturaOVPPlayer.setup(partnerId: 1091,
                               serverURL: "https://qa-apache-php7.dev.kaltura.com",
                               referrer: nil)
        
        let ovpPlayerOptions = PlayerOptions()
        let player = KalturaOVPPlayer(options: ovpPlayerOptions)
        kalturaOVPPlayer = player
        player.view = playerView
        
        self.playListTapleView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: cellID)
        
        player.addObserver(self, events: [KPPlayerEvent.playheadUpdate]) { [weak self] event in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.seekBar.value = Float(player.currentTime / player.duration)
            }
        }
        
        registerPlaybackEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let playlistOptions = OVPPlaylistOptions()
        playlistOptions.playlistId = "0_wckoqjnn"
        kalturaOVPPlayer?.loadPlaylist(options: playlistOptions) { [weak self] (error) in
            guard let self = self else { return }
            
            self.playlistNameLabel.text = self.kalturaOVPPlayer?.playlistController?.playlist.name
            self.playListTapleView.reloadData()
            
            self.playNextAction(self)
        }
    }
    
    private func registerPlaybackEvents() {
        guard let player = self.kalturaOVPPlayer else { return }
        
        player.addObserver(self, events: [KPPlayerEvent.play,
                                          KPPlayerEvent.playing,
                                          KPPlayerEvent.pause,
                                          KPPlayerEvent.canPlay,
                                          KPPlayerEvent.seeking,
                                          KPPlayerEvent.seeked]) { [weak self] event in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch event {
                case is KPPlayerEvent.Play:
                    self.playPauseButton.isHighlighted = true
                case is KPPlayerEvent.Playing:
                    self.playPauseButton.isHighlighted = true
                case is KPPlayerEvent.Pause:
                    self.playPauseButton.isHighlighted = false
                case is KPPlayerEvent.CanPlay: break
                case is KPPlayerEvent.Seeking: break
                case is KPPlayerEvent.Seeked: break
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        guard let player = self.kalturaOVPPlayer else { return }
        
        if player.isPlaying || player.rate > 0 {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @IBAction func seekAction(_ slider: UISlider) {
        guard let player = self.kalturaOVPPlayer else { return }
        player.currentTime = TimeInterval(player.duration * Double(slider.value))
    }
    
    @IBAction func playNextAction(_ sender: Any) {
        kalturaOVPPlayer?.playlistController?.playNext()
    }
    
    @IBAction func playPrevAction(_ sender: Any) {
        kalturaOVPPlayer?.playlistController?.playPrev()
    }
    
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        kalturaOVPPlayer?.playlistController?.playItem(index: indexPath.item)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let playlist = kalturaOVPPlayer?.playlistController?.playlist,
              let items = playlist.medias else {
            return 0
        }
        
        return items.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        if let playlist = kalturaOVPPlayer?.playlistController?.playlist,
           let item = playlist.medias?[indexPath.item] {
            
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "Duration: \(item.duration)"
            
            if let thumbnailUrl = item.thumbnailUrl, let url = URL(string: thumbnailUrl) {
                
                do {
                    let data = try Data(contentsOf: url)
                     cell.imageView?.image = UIImage(data: data)
                } catch {
                    print(error)
                }
            }
        }
        
        return cell
    }
    
}
