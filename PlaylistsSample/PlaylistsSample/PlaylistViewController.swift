//
//  ViewController.swift
//  PlaylistsSample
//
//  Created by Sergii Chausov on 31.08.2021.
//

import UIKit
import KalturaPlayer
import PlayKit
import PlayKit_IMA
import PlayKitYoubora

private let cellID = "PlaylistCellID"

enum PlaylistType {
    case basic
    case ott
    case ovp
    case ovpId
}

class PlaylistViewController: UIViewController {
    
    var playlistType: PlaylistType = .basic
    var pluginsEnabled: Bool = true
    
    var adTags: [String] = IMAAdTags().getAdTagsCollection()
    
    @IBOutlet weak var playerView: KalturaPlayerView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var playNext: UIButton!
    @IBOutlet weak var playPrev: UIButton!
    
    @IBOutlet weak var playListTableView: UITableView!
    
    /*
     This is just sor sample uses.
     Try to use exact type you need in your App: KalturaBasicPlayer, KalturaOVPPlayer or KalturaOTTPlayer
     */
    var player: KalturaPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playListTableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: cellID)
        
        setupPlayer()
        initializePlayer()
        
        registerPlaybackEvents()
        registerPlaylistControllerEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadPlayList()
        checkIfMediasAvailable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterPlayerEvents()
    }
    
    //
    
    func setupPlayer() {
        
        switch self.playlistType {
        case .basic:
            KalturaBasicPlayer.setup()
        case .ott:
            KalturaOTTPlayer.setup(partnerId: 3009,
                                   serverURL: "https://rest-us.ott.kaltura.com/v4_5/api_v3",
                                   referrer: nil)
            
//            KalturaOTTPlayer.bypassConfigFetching(partnerId: 0,
//                                                  ovpPartnerId: 0,
//                                                  analyticsUrl: "https://analytics.kaltura.com",
//                                                  ovpServiceUrl: "https://rest.beeline.tv/api_v3",
//                                                  uiConfId: 0)
        case .ovp:
            KalturaOVPPlayer.setup(partnerId: 1091,
                                   serverURL: "https://qa-apache-php7.dev.kaltura.com",
                                   referrer: nil)
        case .ovpId:
            KalturaOVPPlayer.setup(partnerId: 1091,
                                   serverURL: "https://qa-apache-php7.dev.kaltura.com",
                                   referrer: nil)
        }
    }
    
    func initializePlayer() {
        
        switch self.playlistType {
        case .basic:
            player = KalturaBasicPlayer(options: self.getPlayerOptions())
        case .ott:
            player = KalturaOTTPlayer(options: self.getPlayerOptions())
        case .ovp:
            player = KalturaOVPPlayer(options: self.getPlayerOptions())
        case .ovpId:
            player = KalturaOVPPlayer(options: self.getPlayerOptions())
        }
        
        player?.view = playerView
    }
    
    func getPlayerOptions() -> PlayerOptions {
        let plyerOptions = PlayerOptions()
        plyerOptions.autoPlay = true
        
        //plyerOptions.ks = ""
        
        if self.pluginsEnabled == true {
            
            let youboraPluginParams: [String: Any] = [
                "accountCode": "kalturatest"
            ]
            let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
            
            let imaConfig = IMAConfig()
            
            plyerOptions.pluginConfig = PluginConfig(config: [IMAPlugin.pluginName: imaConfig,
                                                              YouboraPlugin.pluginName: analyticsConfig])
        }
        
        return plyerOptions
    }
    
    func loadBasicPlaylist() {
        guard let player = self.player as? KalturaBasicPlayer else { return }
        
        let playlist: PKPlaylist = PKPlaylist(id: nil,
                                              name: "Basic Playlist",
                                              thumbnailUrl: nil,
                                              medias: BasicVideoData().getBasicVideos())
        
        player.setPlaylist(playlist)
        
        handlePlaylist()
    }
    
    func loadOttPlaylist() {
        guard let player = self.player as? KalturaOTTPlayer else { return }
        
        var mediaOptions: [OTTMediaOptions] = []
        
//        mediaOptions.append(OTTMediaOptions().set(assetId: "681795").set(assetReferenceType: .media))
//        mediaOptions.append(OTTMediaOptions().set(assetId: "681771").set(assetReferenceType: .media))
//        mediaOptions.append(OTTMediaOptions().set(assetId: "681766").set(assetReferenceType: .media))
//        mediaOptions.append(OTTMediaOptions().set(assetId: "849804").set(assetReferenceType: .media))
        
        mediaOptions.append(OTTMediaOptions().set(assetId: "548575").set(assetReferenceType: .media).set(networkProtocol: "http"))
        mediaOptions.append(OTTMediaOptions().set(assetId: "548570").set(assetReferenceType: .media).set(networkProtocol: "http"))
        mediaOptions.append(OTTMediaOptions().set(assetId: "548576").set(assetReferenceType: .media).set(networkProtocol: "http"))
        
        player.loadPlaylist(options: mediaOptions, callback: { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Loading playlist error: " + error.localizedDescription)
            }
            self.handlePlaylist()
        })
    }
    
    func loadOvpPlaylist() {
        guard let player = self.player as? KalturaOVPPlayer else { return }
        
        var mediaOptions: [OVPMediaOptions] = []
        
        mediaOptions.append(OVPMediaOptions().set(entryId: "0_ttfy4uu0"))
        mediaOptions.append(OVPMediaOptions().set(entryId: "0_01iwbdrn"))
        mediaOptions.append(OVPMediaOptions().set(entryId: "0_1l9q18gy"))
        mediaOptions.append(OVPMediaOptions().set(entryId: "0_1l9q18gy"))
        mediaOptions.append(OVPMediaOptions().set(entryId: "0_1l9q18gy"))
        
        player.loadPlaylist(options: mediaOptions, callback: { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Loading playlist error: " + error.localizedDescription)
            }
            self.handlePlaylist()
        })
    }
    
    func loadPlaylistWithOvpId() {
        guard let player = self.player as? KalturaOVPPlayer else { return }
        
        let playlistOptions = OVPPlaylistOptions()
        playlistOptions.playlistId = "0_wckoqjnn"
        
        player.loadPlaylistById(options: playlistOptions) { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                print("Loading playlist error: " + error.localizedDescription)
            }
            self.handlePlaylist()
        }
    }
    
    func handlePlaylist() {
        
        if let playlistController = self.player?.playlistController {
            
            playlistController.delegate = self
            
            self.playlistNameLabel.text = playlistController.playlist.name
            self.playListTableView.reloadData()
            
            self.playNextAction(self)
            
            checkIfMediasAvailable()
        }
    }
    
    func loadPlayList() {
        switch self.playlistType {
        case .basic: self.loadBasicPlaylist()
        case .ott: self.loadOttPlaylist()
        case .ovp: self.loadOvpPlaylist()
        case .ovpId: self.loadPlaylistWithOvpId()
        }
    }
    
    func registerPlaylistControllerEvents() {
        guard let player = self.player else { return }
        
        player.addObserver(self, events: [KPPlaylistEvent.playListCurrentPlayingItemChanged]) { [weak self] event in
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                if let playlistController = self.player?.playlistController {
                    self.playListTableView.selectRow(at: IndexPath(item: playlistController.currentMediaIndex, section: 0),
                                                     animated: true,
                                                     scrollPosition: .top)
                }
            }
        }
    }
    
    func registerPlaybackEvents() {
        guard let player = self.player else { return }
        
        player.addObserver(self, events: [KPPlayerEvent.playheadUpdate]) { [weak self] event in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.seekBar.value = Float(player.currentTime / player.duration)
            }
        }
        
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
    
    func unregisterPlayerEvents() {
        player?.pause()
        player?.removeObserver(self, events: KPPlaylistEvent.allEventTypes)
        player?.removeObserver(self, events: KPPlayerEvent.allEventTypes)
        player?.removeObserver(self, events: KPAdEvent.allEventTypes)
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        guard let player = self.player else { return }
        
        if player.isPlaying || player.rate > 0 {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @IBAction func seekAction(_ slider: UISlider) {
        guard let player = self.player else { return }
        player.currentTime = TimeInterval(player.duration * Double(slider.value))
    }
    
    @IBAction func playNextAction(_ sender: Any) {
        player?.playlistController?.playNext()
    }
    
    @IBAction func playPrevAction(_ sender: Any) {
        player?.playlistController?.playPrev()
    }
    
    @IBAction func repeatAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        player?.playlistController?.loop = sender.isSelected
        self.checkIfMediasAvailable()
    }
    
    @IBAction func shuffleAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func reloadPlayList(_ sender: Any) {
        self.loadPlayList()
    }
    
    func checkIfMediasAvailable() {
        guard let controller = player?.playlistController else {
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
        player?.playlistController?.playItem(index: indexPath.item)
    }
    
}

extension PlaylistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let playlist = player?.playlistController?.playlist,
              let items = playlist.medias else {
                  return 0
              }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        if let playlist = player?.playlistController?.playlist,
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

extension PlaylistViewController: PlaylistControllerDelegate {
    
    func playlistController(_ controller: PlaylistController, needsUpdatePluginConfigForMediaItemAtIndex mediaItemIndex: Int) -> Bool {
        return pluginsEnabled
    }
    
    func playlistController(_ controller: PlaylistController, pluginConfigForMediaItemAtIndex mediaItemIndex: Int) -> PluginConfig {
        
        let youboraPluginParams: [String: Any] = [
            "accountCode": "kalturatest",
            "contentCustomDimensions": [
                "contentCustomDimension1": controller.playlist.id,
                "contentCustomDimension2": "Playlist Item: \(mediaItemIndex)",
                "contentCustomDimension3": controller.playlist.medias?[mediaItemIndex].id
            ]
        ]
        let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
        
        let imaConfig = IMAConfig()
        imaConfig.alwaysStartWithPreroll = true
        imaConfig.adTagUrl = adTags.randomElement() ?? ""
        
        return PluginConfig(config: [IMAPlugin.pluginName: imaConfig,
                                     YouboraPlugin.pluginName: analyticsConfig])
    }
    
}

