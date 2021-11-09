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
//    var kalturaPlayer: KalturaOTTPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        KalturaBasicPlayer.setup()
        
        KalturaOVPPlayer.setup(partnerId: 1091,
                               serverURL: "https://qa-apache-php7.dev.kaltura.com",
                               referrer: nil)
        
//        KalturaOTTPlayer.setup(partnerId: 478,
//                               serverURL: "https://rest.beeline.tv/api_v3/")
        
//        KalturaOTTPlayer.setup(partnerId: 3009,
//                               serverURL: "https://rest-us.ott.kaltura.com/v4_5/api_v3",
//                               referrer: nil)
        
//        let plyerOptions = PlayerOptions()
        let plyerOptions = PlayerOptions()
        plyerOptions.autoPlay = true
        
        let youboraPluginParams: [String: Any] = [
            "accountCode": "kalturatest"
        ]
        let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
        
        let imaConfig = IMAConfig()
        imaConfig.alwaysStartWithPreroll = true
        
        plyerOptions.pluginConfig = PluginConfig(config: [IMAPlugin.pluginName: imaConfig,
                                                          YouboraPlugin.pluginName: analyticsConfig])
        
//        plyerOptions.ks = "djJ8NDc4fAnQ0UMs1SxUeP3qfNo3nD7C2aQ1JaeMuSKWWbF4qANX33y4Xi5oKJ1IV9Dfi5UM0OgegkgNwPCKSq5zl8Jm9Tc6k3tJm0J7HiMz46f_-fYezSCzrQonOF-MW94Ml7H3iNtoVjCqJfzXNPNnK56UBcd14dxcCFU4-samNk4vDh6U_w5lI56G0dwIuTjVocc-mDoFc0e1nNxJCzEgfzH2QNT2ibsc22u2ACv-shEX_GcJOXf1ZYVc7wxLOzuafPgEfIT_aiochFoBLLix56cgaL6A0Z3qi_U47WYzfgjFVpBr1O0kpH6OaysoyvC5FTklN9JI83bspX0xCC-dmQvBZW_4qaZcm4jbQOsFvP8MMCSmXmn-D0tZJPwzzp_MAIKVK-8NYajfhyuLQI5f0czXNBUhUj6nooCXjdDkFZdxpfRKyoatVhVgqFdrmBO4SGwWdF_qTOxwJC2CSLCQyCN0UfY="
        
        
//        let player = KalturaOTTPlayer(options: plyerOptions)
        let player = KalturaOVPPlayer(options: plyerOptions)
//        let player = KalturaBasicPlayer(options: plyerOptions)
        kalturaPlayer = player
        player.view = playerView
        
        self.playListTableView.register(PlaylistTableViewCell.self, forCellReuseIdentifier: cellID)
        
        
        
        registerPlaybackEvents()
        registerPlaylistControllerEvents()
        
        checkIfMediasAvailable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadPlayList()
    }
    
    func loadPlayList() {
        let playlistOptions = OVPPlaylistOptions()
        playlistOptions.playlistId = "0_wckoqjnn"
        
        kalturaPlayer?.loadPlaylistById(options: playlistOptions) { [weak self] (error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Loading playlist error: " + error.localizedDescription)
            }
            
            self.kalturaPlayer?.playlistController?.delegate = self
            
            self.playlistNameLabel.text = self.kalturaPlayer?.playlistController?.playlist.name
            self.playListTableView.reloadData()
            
            self.playNextAction(self)
            self.checkIfMediasAvailable()
        }
        
        
        //        var mediaOptions: [OVPMediaOptions] = []
        //
        //        mediaOptions.append(OVPMediaOptions().set(entryId: "0_ttfy4uu0"))
        //        mediaOptions.append(OVPMediaOptions().set(entryId: "0_01iwbdrn"))
        //        mediaOptions.append(OVPMediaOptions().set(entryId: "0_1l9q18gy"))
        
        //        let ks = "djJ8NDc4fAnQ0UMs1SxUeP3qfNo3nD7C2aQ1JaeMuSKWWbF4qANX33y4Xi5oKJ1IV9Dfi5UM0OgegkgNwPCKSq5zl8Jm9Tc6k3tJm0J7HiMz46f_-fYezSCzrQonOF-MW94Ml7H3iNtoVjCqJfzXNPNnK56UBcd14dxcCFU4-samNk4vDh6U_w5lI56G0dwIuTjVocc-mDoFc0e1nNxJCzEgfzH2QNT2ibsc22u2ACv-shEX_GcJOXf1ZYVc7wxLOzuafPgEfIT_aiochFoBLLix56cgaL6A0Z3qi_U47WYzfgjFVpBr1O0kpH6OaysoyvC5FTklN9JI83bspX0xCC-dmQvBZW_4qaZcm4jbQOsFvP8MMCSmXmn-D0tZJPwzzp_MAIKVK-8NYajfhyuLQI5f0czXNBUhUj6nooCXjdDkFZdxpfRKyoatVhVgqFdrmBO4SGwWdF_qTOxwJC2CSLCQyCN0UfY="
        //
        //        var mediaOptions: [OTTMediaOptions] = []
        //        mediaOptions.append(OTTMediaOptions().set(assetId: "681795").set(assetReferenceType: .media).set(ks: ks))
        //        mediaOptions.append(OTTMediaOptions().set(assetId: "681771").set(assetReferenceType: .media).set(ks: ks))
        //        mediaOptions.append(OTTMediaOptions().set(assetId: "681766").set(assetReferenceType: .media).set(ks: ks))
        
        //        kalturaPlayer?.loadPlaylistByEntryIds(options: mediaOptions, callback: { [weak self] (error) in
        //            guard let self = self else { return }
        //
        //            self.playlistNameLabel.text = self.kalturaPlayer?.playlistController?.playlist.name
        //            self.playListTableView.reloadData()
        //
        //            self.playNextAction(self)
        //        })
        
        /*
         // Basic
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
        kalturaPlayer?.removeObserver(self, events: KPPlaylistEvent.allEventTypes)
        kalturaPlayer?.removeObserver(self, events: KPPlayerEvent.allEventTypes)
        kalturaPlayer?.removeObserver(self, events: KPAdEvent.allEventTypes)
    }
    
    private func registerPlaylistControllerEvents() {
        guard let player = self.kalturaPlayer else { return }
        
        player.addObserver(self, events: [KPPlaylistEvent.playListCurrentPlayingItemChanged]) { [weak self] event in
            guard let self = self else { return }
            DispatchQueue.main.async {
                
                if let playlistController = self.kalturaPlayer?.playlistController {
                    self.playListTableView.selectRow(at: IndexPath(item: playlistController.currentMediaIndex, section: 0),
                                                     animated: true,
                                                     scrollPosition: .top)
                }
            }
        }
    }
    
    private func registerPlaybackEvents() {
        guard let player = self.kalturaPlayer else { return }
        
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
    
    @IBAction func reloadPlayList(_ sender: Any) {
        self.loadPlayList()
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

let IMAAdRulesTag = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&correlator="

extension PlaylistViewController: PlaylistControllerDelegate {
    
    func playlistController(_ controller: PlaylistController, needsUpdatePluginConfigForMediaItemAtIndex mediaItemIndex: Int) -> Bool {
        return true
    }
    
    func playlistController(_ controller: PlaylistController, pluginConfigForMediaItemAtIndex mediaItemIndex: Int) -> PluginConfig {
        
        let youboraPluginParams: [String: Any] = [
            "accountCode": "kalturatest",
            "contentCustomDimensions": [
                "contentCustomDimension1": controller.playlist.id,
                "contentCustomDimension2": "Playlist Item: \(mediaItemIndex)"
            ]
        ]
        let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
        
        let imaConfig = IMAConfig()
        imaConfig.alwaysStartWithPreroll = true
        imaConfig.adTagUrl = IMAAdRulesTag
        
        return PluginConfig(config: [IMAPlugin.pluginName: imaConfig,
                                     YouboraPlugin.pluginName: analyticsConfig])
    }
    
}

