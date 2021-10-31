//
//  ViewController.swift
//  PlaylistsSample
//
//  Created by Sergii Chausov on 31.08.2021.
//

import UIKit
import KalturaPlayer
import PlayKit

private let cellID = "PlaylistCellID"

class PlaylistViewController: UIViewController {
    
    @IBOutlet weak var playerView: KalturaPlayerView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var playNext: UIButton!
    @IBOutlet weak var playPrev: UIButton!
    
    @IBOutlet weak var playListTableView: UITableView!
    
//    var kalturaPlayer: KalturaBasicPlayer?
//    var kalturaOVPPlayer: KalturaOVPPlayer?
    var kalturaPlayer: KalturaOVPPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        KalturaBasicPlayer.setup()
        
        KalturaOVPPlayer.setup(partnerId: 1091,
                               serverURL: "https://qa-apache-php7.dev.kaltura.com",
                               referrer: nil)
        
//        let plyerOptions = PlayerOptions()
        let ovpPlayerOptions = PlayerOptions()
        let player = KalturaOVPPlayer(options: ovpPlayerOptions)
//        let player = KalturaBasicPlayer(options: plyerOptions)
        kalturaPlayer = player
        player.view = playerView
        
        self.playListTableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: cellID)
        
        player.addObserver(self, events: [KPPlayerEvent.playheadUpdate]) { [weak self] event in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.seekBar.value = Float(player.currentTime / player.duration)
            }
        }
        
        registerPlaybackEvents()
        checkIfMediasAvailable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let playlistOptions = OVPPlaylistOptions()
        playlistOptions.playlistId = "0_wckoqjnn"
        kalturaPlayer?.loadPlaylist(options: playlistOptions) { [weak self] (error) in
            guard let self = self else { return }

            self.playlistNameLabel.text = self.kalturaPlayer?.playlistController?.playlist.name
            self.playListTableView.reloadData()

            self.playNextAction(self)
            self.checkIfMediasAvailable()
        }
        
        /*
        var mediaOptions: [OVPMediaOptions] = []
        
        mediaOptions.append(OVPMediaOptions().set(entryId: "0_ttfy4uu0"))
        mediaOptions.append(OVPMediaOptions().set(entryId: "0_01iwbdrn"))
        mediaOptions.append(OVPMediaOptions().set(entryId: "0_1l9q18gy"))
        
        kalturaPlayer?.loadPlaylistByEntryIds(options: mediaOptions, callback: { [weak self] (error) in
            guard let self = self else { return }
            
            self.playlistNameLabel.text = self.kalturaPlayer?.playlistController?.playlist.name
            self.playListTableView.reloadData()
            
            self.playNextAction(self)
        })
        */
        /*
        let playlist: PKPlaylist = PKPlaylist("ID",
                                              name: "Basic Playlist",
                                              thumbnailUrl: nil,
                                              medias: BasicVideoData().getBasicVideos())
        
        kalturaPlayer?.setPlaylist(playlist)
        
        self.playlistNameLabel.text = self.kalturaPlayer?.playlistController?.playlist.name
        self.playListTableView.reloadData()
        
        self.playNextAction(self)
        */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        kalturaPlayer?.pause()
        kalturaPlayer?.removeObserver(self, events: KPPlayerEvent.allEventTypes)
        kalturaPlayer?.removeObserver(self, events: KPAdEvent.allEventTypes)
    }
    
    private func registerPlaybackEvents() {
        guard let player = self.kalturaPlayer else { return }
        
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
                    
                case is KPPlayerEvent.CanPlay:
                    self.playPauseButton.isHighlighted = false
                    self.checkIfMediasAvailable()
                    
                case is KPPlayerEvent.Seeking: break
                case is KPPlayerEvent.Seeked: break
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        guard let player = self.kalturaPlayer else { return }
        
        if player.isPlaying || player.rate > 0 {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @IBAction func seekAction(_ slider: UISlider) {
        guard let player = self.kalturaPlayer else { return }
        player.currentTime = TimeInterval(player.duration * Double(slider.value))
    }
    
    @IBAction func playNextAction(_ sender: Any) {
        kalturaPlayer?.playlistController?.playNext()
    }
    
    @IBAction func playPrevAction(_ sender: Any) {
        kalturaPlayer?.playlistController?.playPrev()
    }
    
    @IBAction func repeatAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        kalturaPlayer?.playlistController?.loop = sender.isSelected
        self.checkIfMediasAvailable()
    }
    
    @IBAction func shuffleAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func checkIfMediasAvailable() {
        guard let controller = kalturaPlayer?.playlistController else {
            self.playNext.isEnabled = false
            self.playPrev.isEnabled = false
            return
        }
        self.playNext.isEnabled = controller.isNextItemAvailable()
        self.playPrev.isEnabled = controller.isPreviousItemAvailable()
    }
    
}


extension PlaylistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        kalturaPlayer?.playlistController?.playItem(index: indexPath.item)
    }
    
}

extension PlaylistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let playlist = kalturaPlayer?.playlistController?.playlist,
              let items = playlist.medias else {
            return 0
        }
        
        return items.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        if let playlist = kalturaPlayer?.playlistController?.playlist,
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
