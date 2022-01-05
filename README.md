# Kaltura Player iOS Samples

In case of a **Basic Player**, include ```pod 'KalturaPlayer'``` in your Podfile.  
In case of an **OTT Player**, include ```pod 'KalturaPlayer/OTT'``` in your Podfile.  
In case of an **OVP Player**, include ```pod 'KalturaPlayer/OVP'``` in your Podfile.

To use Cocoapods please refer to [Cocoapods Guides](https://guides.cocoapods.org/).

**Follow the steps for the required player:**

- [Basic Player](#basic-player)
  - [Setup the KalturaBasicPlayer](#1-setup-the-kalturabasicplayer)
  - [Create a KalturaBasicPlayer](#2-create-a-kalturabasicplayer)
  - [Pass the view to the KalturaBasicPlayer](#3-pass-the-view-to-the-kalturabasicplayer)
  - [Set the Media Entry](#4-set-the-media-entry)
  - [Set collection of PKMediaEntry to Basic Player](#5-set-collection-of-pkmediaentry-to-basic-player)
  
- [OTT Player](#ott-player)
  - [Setup the KalturaOTTPlayer](#1-setup-the-kalturaottplayer)
  - [Create a KalturaOTTPlayer](#2-create-a-kalturaottplayer)
  - [Pass the view to the KalturaOTTPlayer](#3-pass-the-view-to-the-kalturaottplayer)
  - [Create the OTTMediaOptions](#4-create-the-ottmediaoptions)
  - [Load the OTT Media](#5-load-the-ott-media)
  - [Load OTT Playlist](#6-load-ott-playlist)

- [OVP Player](#ovp-player)
  - [Setup the KalturaOVPPlayer](#1-setup-the-kalturaovpplayer)
  - [Create a KalturaOVPPlayer](#2-create-a-kalturaovpplayer)
  - [Pass the view to the KalturaOVPPlayer](#3-pass-the-view-to-the-kalturaovpplayer)
  - [Create the OVPMediaOptions](#4-create-the-ovpmediaoptions)
  - [Load the OVP Media](#5-load-the-ovp-media)
  - [Load OVP Playlist](#6-load-ovp-playlist)
  - [Load OVP Playlist by playlist id](#7-load-ovp-playlist-by-playlist-id)
  
**Additional Actions:**

- [Register for Player Events](#register-for-player-events)

- [Prepare the Player](#prepare-the-player)

- [Play](#play)
  
- [Change Media](#change-media)

- [Offline](#offline)  
	- [Update the KalturaPlayer Pod](#1-update-the-kalturaplayer-pod)
	- [Implement the OfflineManagerDelegate](#2-implement-the-offlinemanagerdelegate)
	- [Check for the media state](#3-check-for-the-media-state)
	- [Prepare a media for download](#4-prepare-a-media-for-download)
	- [Start or resume downloading the media](#5-start-or-resume-downloading-the-media)
	- [Pause downloading the media](#6-pause-downloading-the-media)
	- [Remove the asset](#7-remove-the-asset)
	- [Get the local media and set it on the player](#8-get-the-local-media-and-set-it-on-the-player)
	- [DRM Content](#9-drm-content)
  
**Plugins:**

- [IMA Plugin](#ima-plugin)
  - [Add the IMA Pod](#1-add-the-ima-pod)
  - [Create the IMAConfig or IMADAIConfig](#2-create-the-imaconfig-or-imadaiconfig)
  - [Create the PluginConfig](#3-create-the-pluginconfig)
  - [Pass the PluginConfig to the PlayerOptions](#4-pass-the-pluginconfig-to-the-playeroptions)
  - [Register to the ad events](#5-register-to-the-ad-events)
  
- [Youbora Plugin](#youbora-plugin)
  - [Add the Youbora Pod](#1-add-the-youbora-pod)
  - [Create the AnalyticsConfig](#2-create-the-analyticsConfig)
  - [Create the PluginConfig](#3-create-the-pluginconfig-1)
  - [Pass the PluginConfig to the PlayerOptions](#4-pass-the-pluginconfig-to-the-playeroptions-1)

- [Chrome Cast Plugin](#chrome-cast-plugin)
  - [Add the Chrome Cast Pod](#1-add-the-chrome-cast-pod)
  - [Setup the Cast](#2-setup-the-cast)
  - [Add the required settings in the info plist file](#3-add-the-required-settings-in-the-info-plist-file)
  - [Add the cast button](#4-add-the-cast-button)
  - [Cast a media](#5-ast-a-media)
  
**Playlist:**
  
- [Playing Playlists](#playing-playlists)
	- [Register for Playlist Controller Events](#register-for-playlist-controller-events)
	- [Handeling Playlist Controller](#handeling-playlist-controller)
	- [How to get access for individual playlist items?](#how-to-get-access-for-individual-playlist-items)
	- [PlaylistControllerDelegate](#playlistcontrollerdelegate)
  
  
<!-- toc -->



## Basic Player

### 1. Setup the KalturaBasicPlayer

In the AppDelegate call `setup` on the `KalturaBasicPlayer` when the app launches.

For Example:

```swift
import KalturaPlayer

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    KalturaBasicPlayer.setup()
    
    return true
}
```

The `setup` will register any of Kaltura's known Plugins if they are added to the project.

### 2. Create a KalturaBasicPlayer

```swift
import KalturaPlayer

var kalturaBasicPlayer: KalturaBasicPlayer! // Created in the viewDidLoad

override func viewDidLoad() {
	super.viewDidLoad()
	
	let playerOptions = PlayerOptions()
	kalturaBasicPlayer = KalturaBasicPlayer(options: playerOptions)
}
```

Check the `PlayerOptions` class for more info.  
The available options and defaults that can be configured are:  

```swift
public var preload: Bool = true
public var autoPlay: Bool = true
public var pluginConfig: PluginConfig = PluginConfig(config: [:])
```

### 3. Pass the view to the KalturaBasicPlayer

Create a `KalturaPlayerView` in the xib or in the code.  

```swift
@IBOutlet weak var kalturaPlayerView: KalturaPlayerView!

kalturaBasicPlayer.view = kalturaPlayerView

```

### 4. Set the Media Entry

There are two available options: 
 
1. Create a PKMediaEntry and pass it to the `KalturaBasicPlayer`.

	```swift
	let contentURL = URL(string: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8")
	let entryId = "KalturaMedia"
	let source = PKMediaSource(entryId, contentUrl: contentURL, mediaFormat: .hls)
	let sources: Array = [source]
	let mediaEntry = PKMediaEntry(entryId, sources: sources, duration: -1)
	
	kalturaBasicPlayer.setMedia(mediaEntry)
	```
	
2. Use the `setupMediaEntry` function.
	
	```swift
	let contentUrl = URL(string:"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8")
	kalturaBasicPlayer.setupMediaEntry(id: "sintel", contentUrl: contentUrl)
	```
	
	Check the function for more available params.
	
**Note:** If you want to add a start time for the media, both functions accept a parameter of type `MediaOptions` which has a `startTime` property which can be set. See `MediaOptions` for more information.

### 5. Set collection of PKMediaEntry to Basic Player

1. Create a collection of PKMediaEntry:

```swift
var mediaEntries: [PKMediaEntry] = []
```
How to create an individual PKMediaEntry see section 4. [Set the Media Entry](#4-set-the-media-entry)

2. Populate `mediaEntries` collection with created medias

3. Create `PKPlaylist` with this collection and set this playlist to the player
```swift
let playlist: PKPlaylist = PKPlaylist(id: nil,
                                      name: "Basic Playlist",
                                      thumbnailUrl: nil,
                                      medias: mediaEntries)

player.setPlaylist(playlist)

// Once all set you can handle playlist here
```
2. Now you have access to player.playlistController. Please check the example of [Handeling Playlist Controller](#handeling-playlist-controller)

## OTT Player

The OTT Player has the Kava Plugin and Phoenix Analytics Plugin embedded, therefore no additional configuration for those plugins are required.

### 1. Setup the KalturaOTTPlayer

In the AppDelegate call `setup` on the `KalturaOTTPlayer` when the app launches.

For Example:

```swift
import KalturaPlayer

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    KalturaOTTPlayer.setup(partnerId: 3009, serverURL: "https://rest-us.ott.kaltura.com/v4_5/api_v3/", referrer: nil)
    
    return true
}
```

The `setup` will fetch for the configuration needed for the Kava Plugin. As well as register both Kava Plugin and Phoenix Analytics Plugin.

### 2. Create a KalturaOTTPlayer

```swift
import KalturaPlayer

var kalturaOTTPlayer: KalturaOTTPlayer! // Created in the viewDidLoad

override func viewDidLoad() {
	super.viewDidLoad()
	
	let playerOptions = PlayerOptions()
	kalturaOTTPlayer = KalturaOTTPlayer(options: playerOptions)
}
```

Check the `PlayerOptions` class for more info.  
The available options and defaults that can be configured are:  

```swift
public var preload: Bool = true
public var autoPlay: Bool = true
public var pluginConfig: PluginConfig = PluginConfig(config: [:])
public var ks: String?
```

### 3. Pass the view to the KalturaOTTPlayer

Create a `KalturaPlayerView` in the xib or in the code.  

```swift
@IBOutlet weak var kalturaPlayerView: KalturaPlayerView!

kalturaOTTPlayer.view = kalturaPlayerView

```

### 4. Create the OTTMediaOptions

This is the media details that will be passed to the player to load.

```swift
let ottMediaOptions = OTTMediaOptions()
```

Check the `OTTMediaOptions` class for more info.  
The available options that can be configured are the following:  

```swift
public var ks: String?
public var assetId: String?
public var assetType: AssetType = .unset
public var assetReferenceType: AssetReferenceType = .unset
public var formats: [String]?
public var fileIds: [String]?
public var playbackContextType: PlaybackContextType = .unset
public var networkProtocol: String?
public var urlType: String?
public var streamerType: String?
public var adapterData: [String: String]?

// MediaOptions
public var startTime: TimeInterval = .nan
```

### 5. Load the OTT Media

Pass the created media options to the `loadMedia` function and implement the callback function in order to observe if an error has occurred.

For example:

```swift
kalturaOTTPlayer.loadMedia(options: mediaOptions) { [weak self] (error) in
    guard let self = self else { return }
    if let error = error {
        let message = error.localizedDescription

        let alert = UIAlertController(title: "Media not loaded", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    } else {
        // If the autoPlay and preload was set to false, prepare will not be called automatically
        if videoData.player.autoPlay == false && videoData.player.preload == false {
            self.kalturaOTTPlayer.prepare()
        }
    }
}
```

### 6. Load OTT Playlist

1. Prepare a collection of `OTTMediaOptions`

```swift
var mediaOptions: [OTTMediaOptions] = []

mediaOptions.append(OTTMediaOptions().set(assetId: "111111").set(assetReferenceType: .media).set(networkProtocol: "http"))
mediaOptions.append(OTTMediaOptions().set(assetId: "222222").set(assetReferenceType: .media).set(networkProtocol: "http"))
mediaOptions.append(OTTMediaOptions().set(assetId: "333333").set(assetReferenceType: .media).set(networkProtocol: "http"))
```
2. Pass this collection to the player loadPlaylist method:

```swift
player.loadPlaylist(options: mediaOptions, callback: { [weak self] error in
    guard let self = self else { return }
    if let error = error {
        print("Loading playlist error: " + error.localizedDescription)
    }
    // Handle loaded playlist here
})
```
3. Now you have access to player.playlistController. Please check the example of [Handeling Playlist Controller](#handeling-playlist-controller)

## OVP Player

The OVP Player has the Kava Plugin embedded, therefore no additional configuration for the plugin is required.

### 1. Setup the KalturaOVPPlayer

In the AppDelegate call `setup` on the `KalturaOVPPlayer` when the app launches.

For Example:

```swift
import KalturaPlayer

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    KalturaOVPPlayer.setup(partnerId: 2222401)
    
    return true
}
```

The `setup` will fetch for the configuration needed for the Kava Plugin. As well as register the Kava Plugin.

### 2. Create a KalturaOVPPlayer

```swift
import KalturaPlayer

var kalturaOVPPlayer: KalturaOVPPlayer! // Created in the viewDidLoad

override func viewDidLoad() {
	super.viewDidLoad()
	
	let playerOptions = PlayerOptions()
	kalturaOVPPlayer = KalturaOVPPlayer(options: playerOptions)
}
```

Check the `PlayerOptions` class for more info.  
The available options and defaults that can be configured are:  

```swift
public var preload: Bool = true
public var autoPlay: Bool = true
public var pluginConfig: PluginConfig = PluginConfig(config: [:])
public var ks: String?
```

### 3. Pass the view to the KalturaOVPPlayer

Create a `KalturaPlayerView` in the xib or in the code.  

```swift
@IBOutlet weak var kalturaPlayerView: KalturaPlayerView!

kalturaOVPPlayer.view = kalturaPlayerView

```

### 4. Create the OVPMediaOptions

This is the media details that will be passed to the player to load.

```swift
let ovpMediaOptions = OVPMediaOptions()
```

Check the `OVPMediaOptions` class for more info.  
The available options that can be configured are the following:  

```swift
public var ks: String?
public var entryId: String?
public var referenceId: String?
public var uiconfId: NSNumber?

// MediaOptions
public var startTime: TimeInterval = .nan
```

### 5. Load the OVP Media

Pass the created media options to the `loadMedia` function and implement the callback function in order to observe if an error has occurred.

For example:

```swift
kalturaOVPPlayer.loadMedia(options: mediaOptions) { [weak self] (error) in
    guard let self = self else { return }
    if let error = error {
        let message = error.localizedDescription
        
        let alert = UIAlertController(title: "Media not loaded", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    } else {
        // If the autoPlay and preload was set to false, prepare will not be called automatically
        if videoData.player.autoPlay == false && videoData.player.preload == false {
            self.kalturaOVPPlayer.prepare()
        }
    }
}
```

### 6. Load OVP Playlist

1. Prepare a collection of `OVPMediaOptions`

```swift
var mediaOptions: [OVPMediaOptions] = []

mediaOptions.append(OVPMediaOptions().set(entryId: "0_aaaa1111"))
mediaOptions.append(OVPMediaOptions().set(entryId: "0_aaaa2222"))
mediaOptions.append(OVPMediaOptions().set(entryId: "0_aaaa3333"))
mediaOptions.append(OVPMediaOptions().set(entryId: "0_aaaa4444"))
mediaOptions.append(OVPMediaOptions().set(entryId: "0_aaaa5555"))
mediaOptions.append(OVPMediaOptions().set(entryId: "0_aaaa6666"))
```
2. Pass this collection to the player loadPlaylist method:

```swift
player.loadPlaylist(options: mediaOptions, callback: { [weak self] error in
    guard let self = self else { return }
    if let error = error {
        print("Loading playlist error: " + error.localizedDescription)
    }
    // Handle loaded playlist here
})
```
3. Now you have access to player.playlistController. Please check the example of [Handeling Playlist Controller](#handeling-playlist-controller)

### 7. Load OVP Playlist by playlist id

1. Prepare `OVPPlaylistOptions` and set playlist id:
```swift
let playlistOptions = OVPPlaylistOptions()
playlistOptions.playlistId = "0_abcd12345"
```

2. Call loadPlaylistById method in player and pass options:
```swift
player.loadPlaylistById(options: playlistOptions) { [weak self] (error) in
    guard let self = self else { return }
    if let error = error {
        print("Loading playlist error: " + error.localizedDescription)
    }
    // Handle loaded playlist here
}
```

3. Now you have access to player.playlistController. Please check the example of [Handeling Playlist Controller](#handeling-playlist-controller)

## Register for Player Events

**NOTE:** In order to receive the events from the beginning, register to them before calling `setMedia` in the BasicPlayer or calling `loadMedia` in the OTTPlayer or OVPPlayer. In case the player option is set to not auto prepare, registering can be done before calling prepare on the player.  

An example for the playback events in order to updated the UI on the button:

```swift
kalturaPlayer.addObserver(self, events: [KPPlayerEvent.ended, KPPlayerEvent.play, KPPlayerEvent.playing, KPPlayerEvent.pause]) { [weak self] event in
	guard let self = self else { return }
	    
	NSLog(event.description)
	    
	DispatchQueue.main.async {
	    switch event {
	    case is KPPlayerEvent.Ended:
	        self.playPauseButton.displayState = .replay
	    case is KPPlayerEvent.Play:
	        self.playPauseButton.displayState = .pause
	    case is KPPlayerEvent.Playing:
	        self.playPauseButton.displayState = .pause
	    case is KPPlayerEvent.Pause:
	        self.playPauseButton.displayState = .play
	    default:
	        break
	    }
	}
}
```

An example to update the progress:

```swift
kalturaPlayer.addObserver(self, events: [KPPlayerEvent.playheadUpdate]) { [weak self] event in
    guard let self = self else { return }
    guard let currentTimeNumber = event.currentTime else { return }
    DispatchQueue.main.async {
        self.mediaProgressSlider.value = Float(currentTimeNumber.doubleValue / self.kalturaPlayer.duration)
    }
}
```

**NOTE:** Don't forget to perform UI changes on the main thread.  
And don't forget to unregister when the view is not displayed.

**All available Player events:**

* canPlay
* durationChanged
* stopped
* ended
* loadedMetadata
* play
* pause
* playing
* seeking
* seeked
* replay
* tracksAvailable
* textTrackChanged
* audioTrackChanged
* videoTrackChanged
* playbackInfo
* stateChanged
* timedMetadata
* sourceSelected
* loadedTimeRanges
* playheadUpdate
* error
* errorLog
* playbackStalled

## Prepare the Player

**This will be done automatically** if the player options, `autoPlay` or `preload` is set to true. Which those are the default values.

In case the `autoPlay` and `preload` are set to false, `prepare` on the player needs to be called manually.

```swift
kalturaPlayer.prepare()
```

## Play

**This will be done automatically** if the player options, `autoPlay` is set to true. Which is the default value.

In case the `autoPlay` is set to false, `play` on the player needs to be called manually.

```swift
kalturaPlayer.play()
```

Play on the player can be called straight after prepare, once it's ready and can play, the playback will start automatically.  
Registering to the player event `CanPlay` will enable you to know exactly when the play can be performed in case you need it controlled.

## Change Media

When a change media is needed call `stop` on the player and call `updatePlayerOptions` on the relevant KalturaPlayer with the new/updated `PlayerOptions`.

```swift
kalturaPlayer.stop()
kalturaPlayer.updatePlayerOptions(playerOptions)
```

After that follow the steps:

- For the KalturaBasicPlayer from section [Set the Media Entry](#4-set-the-media-entry)
- For the KalturaOTTPlayer from section [Create the OTTMediaOptions](#4-create-the-ottmediaoptions)
- For the KalturaOVPPlayer from section [Create the OVPMediaOptions](#4-create-the-ovpmediaoptions)

## Offline

Adds the option to download and play local media. The `OfflineManager` shared instance is used in order to perform all actions.

### 1. Update the KalturaPlayer Pod

Inside your Podfile, for the specific target, add the following: 

- For the KalturaBasicPlayer:

	```swift
	pod 'KalturaPlayer/Offline'
	```
	This can replace the `pod 'KalturaPlayer'`
	
- For the KalturaOTTPlayer:

	```swift
	pod 'KalturaPlayer/Offline_OTT'
	```
	This can replace the `pod 'KalturaPlayer/OTT'`
	
- For the KalturaOVPPlayer:

	```swift
	pod 'KalturaPlayer/Offline_OVP'
	```
	This can replace the `pod 'KalturaPlayer/OVP'`
	
Then perform `pod update` in the terminal.  
See Cocoapods Guide for the [difference between pod install and pod update](https://guides.cocoapods.org/using/pod-install-vs-update.html).

Add the `KalturaPlayer` to the relevant file if it doesn't already exist.

```swift
import KalturaPlayer
```

**NOTE:** The setup function on the KalturaPlayer which is called in the AppDelegate, will perform the needed initialization, and will start any media that was downloading before the application was closed.

### 2. Implement the OfflineManagerDelegate

In the desired class that will take care of the download updates, set it as the OfflineManager's delegate.

Add the following:

```swift
OfflineManager.shared.offlineManagerDelegate = self
```

**Note:** Don't forget to remove itself.

```swift
OfflineManager.shared.offlineManagerDelegate = nil
```

Set the class to implement it's functions:

```swift
extension MediasTableViewController: OfflineManagerDelegate {

    func item(id: String, didDownloadData totalBytesDownloaded: Int64, totalBytesEstimated: Int64, completedFraction: Float) {
        if let index = self.videos.firstIndex(where: { $0.media.id == id }) {
            DispatchQueue.main.async {
                guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DownloadMediaTableViewCell else { return }
                cell.updateProgress(completedFraction)
            }
        }
    }
    
    func item(id: String, didChangeToState newState: AssetDownloadState, error: Error?) {
        if let index = self.videos.firstIndex(where: { $0.media.id == id }) {
            if newState == .completed {
                // Download is completed, do something.
            }
            DispatchQueue.main.async {
                guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? DownloadMediaTableViewCell else { return }
                cell.updateDownloadState(newState)
            }
        }
    }
}
```

### 3. Check for the media state

In order to update the view once shown with the relevant data regarding the download process, call the `getAssetInfo` function. The `AssetInfo` will include the required data in order to update the UI.

```swift
let assetInfo = OfflineManager.shared.getAssetInfo(assetId: assetId)
```

The `AssetInfo` object includes the following:
	
```swift
public var itemId: String               // The asset's id.
public var state: AssetDownloadState    // The asset's state. See `AssetDownloadState` for more info.
public var estimatedSize: Int64         // The asset's estimated size.
public var downloadedSize: Int64        // The asset's downloaded size.
public var progress: Float              // The asset's progress. A value between 0 and 1.
```

The `AssetDownloadState` represents the asset's download state.
 
Available Values:

* new
* prepared
* started
* paused
* completed
* failed
* outOfSpace

### 4. Prepare a media for download

In order to start downloading a media, a call to `prepareAsset` is required.

- Create an `OfflineSelectionOptions`. 

	For example:

	```swift
	let offlineSelectionOptions = OfflineSelectionOptions()
	    .setMinVideoHeight(300)
	    .setMinVideoBitrate(.avc1, 3_000_000)
	    .setMinVideoBitrate(.hevc, 5_000_000)
	    .setPreferredVideoCodecs([.hevc, .avc1])
	    .setPreferredAudioCodecs([.ac3, .mp4a])
	    .setAllTextLanguages()
	    .setAllAudioLanguages()
	```

**For a PKMediaEntry download** the `prepareAsset` function requires two parameters: `PKMediaEntry` and `OfflineSelectionOptions`.

- Create a PKMediaEntry

	```swift
	let contentURL = URL(string: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8")
	let entryId = "KalturaMedia"
	let source = PKMediaSource(entryId, contentUrl: contentURL, mediaFormat: .hls)
	let sources: Array = [source]
	let pkMediaEntry = PKMediaEntry(entryId, sources: sources, duration: -1)
	```

- Call the `prepareAsset` function

	```swift
	OfflineManager.shared.prepareAsset(mediaEntry: pkMediaEntry, options: offlineSelectionOptions) { (error, assetInfo) in
	    // In case an assetInfo was returned and there is no error, 
	    // a call to start the download can be performed.
	}
	```

**For an OTT Media download** there is an additional function for the `prepareAsset` that requires the following two parameters: `OTTMediaOptions` and `OfflineSelectionOptions`.


- Create the `OTTMediaOptions`, follow the [Create the OTTMediaOptions](#4-create-the-ottmediaoptions) section.

- Call the `prepareAsset` function

	```swift
	OfflineManager.shared.prepareAsset(mediaOptions: ottMediaOptions,
	                                   options: offlineSelectionOptions) { (error, assetInfo, pkMediaEntry)  in
	    // In case an assetInfo was returned and there is no error, 
	    // a call to start the download can be performed.
	}
	```

**For an OVP Media download** there is an additional function for the `prepareAsset` that requires the following two parameters: `OVPMediaOptions` and `OfflineSelectionOptions`.

- Create the `OVPMediaOptions`, follow the [Create the OVPMediaOptions](#4-create-the-ovpmediaoptions) section.

- Call the `prepareAsset` function

	```swift
	OfflineManager.shared.prepareAsset(mediaOptions: ovpMediaOptions,
	                                   options: offlineSelectionOptions) { (error, assetInfo, pkMediaEntry)  in
	    // In case an assetInfo was returned and there is no error, 
	    // a call to start the download can be performed.
	}
	```	
	
### 5. Start or resume downloading the media

In order to start downloading the asset call `startAssetDownload`:

```swift
try? OfflineManager.shared.startAssetDownload(assetId: id)
```	

An error can be thrown, see the documentation for more information.

### 6. Pause downloading the media

In order to pause downloading the asset call `pauseAssetDownload`:

```swift
try? OfflineManager.shared.pauseAssetDownload(assetId: id)
```

An error can be thrown, see the documentation for more information.

### 7. Remove the asset

In order to remove the downloaded asset with all it’s data, call `removeAssetDownload`:

```swift
try? OfflineManager.shared.removeAssetDownload(assetId: id)
```

An error can be thrown, see the documentation for more information.

### 8. Get the local media and set it on the player

In order to retrieve the local media, call `getLocalPlaybackEntry`, if the `PKMediaEntry` was retrieved call `setMedia` on the relevant KalturaPlayer.

```swift
if let localMediaEntry = OfflineManager.shared.getLocalPlaybackEntry(assetId: mediaEntry.id) {
    kalturaPlayer.setMedia(localMediaEntry, options: mediaOptions)
}
```

The player can now be used as usual.

### 9. DRM Content

For DRM content, additional actions are need.

- Get the DRM Status. See the `DRMStatus` for more information.
- Renew the asset DRM license.

In order to get the DRM status of the asset, call `getDRMStatus`:

```swift
let drmStatus = OfflineManager.shared.getDRMStatus(assetId: id)
```

A call to `isValid`, on the drmStatus, can determine if the license is still valid and the media can be played, otherwise a call to `renewAssetDRMLicense` is needed.

```swift
if drmStatus.isValid() == false {
    // Renewal is needed.
}
```

In order to renew the license, a call to `renewAssetDRMLicense` is needed.

```swift
OfflineManager.shared.renewAssetDRMLicense(mediaEntry: pkMediaEntry) { (error) in
    // Decide what to do with the error depending on the error.
}
```

**For OTT** there is an additional function that requires the `OTTMediaOptions`.

```swift
OfflineManager.shared.renewAssetDRMLicense(mediaOptions: ottMediaOptions) { (error) in
    // Decide what to do with the error depending on the error.
}
```

**For OVP** there is an additional function that requires the `OVPMediaOptions`.

```swift
OfflineManager.shared.renewAssetDRMLicense(mediaOptions: ovpMediaOptions) { (error) in
    // Decide what to do with the error depending on the error.
}
```

## IMA Plugin

Add Google's IMA (Interactive Media Ads) or IMA DAI (Dynamic Ad Insertion)

### 1. Add the IMA Pod

Inside your Podfile, for the specific target, add the following:  

```swift
pod 'PlayKit_IMA'
```

Then perform `pod update` or `pod update PlayKit_IMA` in the terminal.  
See Cocoapods Guide for the [difference between pod install and pod update](https://guides.cocoapods.org/using/pod-install-vs-update.html).

Add the `PlayKit_IMA` to the relevant file.

```swift
import PlayKit_IMA
```

### 2. Create the IMAConfig or IMADAIConfig

- For IMA:  
	Create the IMAConfig and set the `adTagUrl` or the `adsResponse`.  
	Refer to the `IMAConfig` class for all available settings.

	```swift
	let imaConfig = IMAConfig()
	imaConfig.adTagUrl = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="
	```

- For IMA DAI:

	Set the required configuration.  
	Refer to the `IMADAIConfig` class for all available settings.  
	The IMA DAI stream samples can be found in their [docs](https://developers.google.com/interactive-media-ads/docs/sdks/ios/dai/streams).
	
	Sample for a VOD media:

	```swift
    let imaDAIConfig = IMADAIConfig()
    imaDAIConfig.assetTitle = "Tears of Steel"
    imaDAIConfig.assetKey = nil
    imaDAIConfig.contentSourceId = "2528370"
    imaDAIConfig.videoId = "tears-of-steel"
    imaDAIConfig.streamType = .vod
	```
	
	Sample for a Live media:
	
	```swift
	let imaDAIConfig = IMADAIConfig()
	imaDAIConfig.assetTitle = "Big Buck Bunny"
	imaDAIConfig.assetKey = "sN_IYUG8STe1ZzhIIE_ksA"
	imaDAIConfig.contentSourceId = nil
	imaDAIConfig.videoId = nil
	imaDAIConfig.streamType = .live
	```


### 3. Create the PluginConfig

Pass the created config to the `PluginConfig`

- For IMA: 

	```swift
	let pluginConfig = PluginConfig(config: [IMAPlugin.pluginName : imaConfig])
	```
	
- For IMA DAI:

	```swift
	let pluginConfig = PluginConfig(config: [IMADAIPlugin.pluginName : imaDAIConfig])
	```

### 4. Pass the PluginConfig to the PlayerOptions

Set the player options with the plugin config created.

```swift
playerOptions.pluginConfig = pluginConfig
```

Two options to consider:  

- The playerOptions is sent upon creating the Kaltura Player, see section [Create a KalturaBasicPlayer](#2-create-a-kalturabasicplayer) or [Create a KalturaOTTPlayer](#2-create-a-kalturaottplayer) or [Create a KalturaOVPPlayer](#2-create-a-kalturaovpplayer) for the relevant player. 
- The playerOptions can be updated upon a change media flow, see section [Change Media](#change-media)

### 5. Register to the ad events

In order to receive the events from the beginning, register to them before prepare is performed on the player.

```swift
private func registerAdEvents() {
    kalturaPlayer.addObserver(self, events: [KPAdEvent.adLoaded, KPAdEvent.adPaused, KPAdEvent.adResumed, KPAdEvent.adStarted, KPAdEvent.adComplete, KPAdEvent.allAdsCompleted]) { [weak self] adEvent in
        guard let self = self else { return }
        
        DispatchQueue.main.async {
            switch adEvent {
            case is KPAdEvent.AdLoaded:
                self.adsLoaded = true
            case is KPAdEvent.AdPaused:
                self.playPauseButton.displayState = .play
            case is KPAdEvent.AdResumed:
                 self.activityIndicator.stopAnimating()
                self.playPauseButton.displayState = .pause
            case is KPAdEvent.AdStarted:
                 self.activityIndicator.stopAnimating()
                self.playPauseButton.displayState = .pause
                 self.mediaProgressSlider.isEnabled = false
            case is KPAdEvent.AdComplete:
                self.mediaProgressSlider.isEnabled = true
            case is KPAdEvent.AllAdsCompleted:
                self.allAdsCompleted = true
                // In case of a post-roll the media has ended
                if self.mediaEnded {
                    self.playPauseButton.displayState = .replay
                    self.showPlayerControllers(true)
                }
            default:
                break
            }
        }
    }
}
```

**NOTE:** Don't forget to perform UI changes on the main thread.  
And don't forget to unregister when the view is not displayed.

**All available Ad events:**

* streamLoaded // DAI
* streamStarted // DAI
* adBreakReady
* adBreakStarted // DAI
* adBreakEnded // DAI
* adPeriodStarted // DAI
* adPeriodEnded // DAI
* allAdsCompleted
* adComplete
* adClicked
* adFirstQuartile
* adLoaded
* adLog
* adMidpoint
* adPaused
* adResumed
* adSkipped
* adStarted
* adTapped
* adThirdQuartile
* adDidProgressToTime
* adDidRequestContentPause /// Ad requested the content to pause (before ad starts playing)
* adDidRequestContentResume /// Ad requested content resume (when finished playing ads or when error occurs and playback needs to continue)
* webOpenerEvent
* adWebOpenerWillOpenExternalBrowser
* adWebOpenerWillOpenInAppBrowser
* adWebOpenerDidOpenInAppBrowser
* adWebOpenerWillCloseInAppBrowser
* adWebOpenerDidCloseInAppBrowser
* adCuePointsUpdate
* adStartedBuffering /// Sent when an ad started buffering
* adPlaybackReady /// Sent when ad finished buffering and ready for playback  
* requestTimedOut /// Sent when the ads request timed out.
* adsRequested /// delivered when ads request was sent.
* error /// Sent when an error occurs.


## Youbora Plugin

### 1. Add the Youbora Pod

Inside your Podfile, for the specific target, add the following:  

```swift
pod 'PlayKitYoubora'
```

Then perform `pod update` or `pod update PlayKitYoubora` in the terminal.  
See Cocoapods Guide for the [difference between pod install and pod update](https://guides.cocoapods.org/using/pod-install-vs-update.html).

Add the `PlayKitYoubora` to the relevant file.

```swift
import PlayKitYoubora
```

### 2. Create the AnalyticsConfig

The account code is mandatory, make sure to put the correct one.  
See all available params in the `YouboraConfig` struct.
        
```swift
let youboraPluginParams: [String: Any] = [
    "accountCode": "kalturatest"
]
let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
```

### 3. Create the PluginConfig

Pass the created config to the `PluginConfig`

```swift
let pluginConfig = PluginConfig(config: [YouboraPlugin.pluginName: analyticsConfig])
```

### 4. Pass the PluginConfig to the PlayerOptions

Set the player options with the plugin config created.

```swift
playerOptions.pluginConfig = pluginConfig
```

Two options to consider:  

- The playerOptions is sent upon creating the Kaltura Player, see section [Create a KalturaBasicPlayer](#2-create-a-kalturabasicplayer) or [Create a KalturaOTTPlayer](#2-create-a-kalturaottplayer) or [Create a KalturaOVPPlayer](#2-create-a-kalturaovpplayer) for the relevant player. 
- The playerOptions can be updated upon a change media flow, see section [Change Media](#change-media)


## Chrome Cast Plugin

**NOTE:** Currently supporting only OTT and OVP providers.

### 1. Add the Chrome Cast Pod

Inside your Podfile, for the specific target, add the following:  

```swift
pod 'PlayKitGoogleCast'
```

Then perform `pod update` or `pod update PlayKitGoogleCast` in the terminal.  
See Cocoapods Guide for the [difference between pod install and pod update](https://guides.cocoapods.org/using/pod-install-vs-update.html).

Add the `PlayKitGoogleCast` and the `GoogleCast` to the relevant file.

```swift
import PlayKitGoogleCast
import GoogleCast
```

### 2. Setup the Cast

In the AppDelegate, need to set up the Application Id.  
Recommended to create a manager in order to control all needed actions and setups, see OTTSample and OVPSample.

Setup for example:  

```swift
// Set your receiver application ID.
let options = GCKCastOptions(discoveryCriteria: GCKDiscoveryCriteria(applicationID: applicationId))
options.physicalVolumeButtonsWillControlDeviceVolume = true

// Following code enables CastConnect
let launchOptions = GCKLaunchOptions()
launchOptions.androidReceiverCompatible = true
options.launchOptions = launchOptions

GCKCastContext.setSharedInstanceWith(options)
GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true

// Theme the cast button using UIAppearance.
GCKUICastButton.appearance().tintColor = UIColor.gray

setupCastLogging()

GCKCastContext.sharedInstance().sessionManager.add(self)
GCKCastContext.sharedInstance().imagePicker = self
```

See Google Chrome Cast [code-lab](https://codelabs.developers.google.com/codelabs/cast-videos-ios/#0) for more information.

### 3. Add the required settings in the info plist file

```swift
<key>NSBluetoothAlwaysUsageDescription</key>
<string>${PRODUCT_NAME} uses the bluetooth to discover Cast-enabled devices via the bluetooth.</string>
	
<key>NSBonjourServices</key>
<array>
	<string>_googlecast._tcp</string>
	<string>_(applicationID)._googlecast._tcp</string>
</array>

<key>NSLocalNetworkUsageDescription</key>
<string>${PRODUCT_NAME} uses the local network to discover Cast-enabled devices on your WiFi
network.</string>
```

### 4. Add the cast button

Add the cast button in the code or the xib.

For example:

```swift
castButton = GCKUICastButton(frame: CGRect(x: CGFloat(0),
                                           y: CGFloat(0),
                                           width: CGFloat(24),
                                           height: CGFloat(24)))

castButton.tintColor = UIColor.white
navigationItem.rightBarButtonItem = UIBarButtonItem(customView: castButton)
```

### 5. Cast a media

In order to cast a media the `GCKMediaInformation` needs to be created and passed to the remoteMediaClient to be loaded. `PlayKitGoogleCast` provides a `CAFCastBuilder` which can be set with properties from the nedia and the `GCKMediaInformation` will be generated.

Get the media information object and load it:

```swift
gckMediaInformation = try getCAFMediaInformation(from: videoData)

if let mediaInformation = gckMediaInformation {
    self.load(mediaInformation: mediaInformation, appending: false)
}
```

Create the media information via the video data:

```swift
private func getCAFMediaInformation(from videoData: VideoData) throws -> GCKMediaInformation {
    let castBuilder = CAFCastBuilder()
    
    castBuilder.set(contentId: videoData.media.assetId)
    castBuilder.set( ...
    ...
    
    let mediaInformation = try castBuilder.build()
    return mediaInformation
}
```

Load the media:

```swift
private func load(mediaInformation:GCKMediaInformation, appending: Bool) -> Void {
    guard let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient else { return }
   
    let mediaQueueItemBuilder = GCKMediaQueueItemBuilder()
    
    mediaQueueItemBuilder.mediaInformation = mediaInformation
    mediaQueueItemBuilder.autoplay = true
    mediaQueueItemBuilder.preloadTime = 0
    
    let mediaQueueItem = mediaQueueItemBuilder.build()
    
    if appending {
      let request = remoteMediaClient.queueInsert(mediaQueueItem, beforeItemWithID: kGCKMediaQueueInvalidItemID)
      request.delegate = self
    } else {
      let queueDataBuilder = GCKMediaQueueDataBuilder(queueType: .generic)
      queueDataBuilder.items = [mediaQueueItem]
      queueDataBuilder.repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off

      let mediaLoadRequestDataBuilder = GCKMediaLoadRequestDataBuilder()
      mediaLoadRequestDataBuilder.mediaInformation = mediaInformation
      mediaLoadRequestDataBuilder.queueData = queueDataBuilder.build()

      let request = remoteMediaClient.loadMedia(with: mediaLoadRequestDataBuilder.build())
      request.delegate = self
    }
}
```

## Playing Playlists

### Register for Playlist Controller Events

It is similar to [Register for Player Events](#register-for-player-events).

**NOTE:** Don't forget to perform UI changes on the main thread.  
And don't forget to unregister when the view is not displayed.

**All available Playlists Controller events:**

* playlistLoaded
* playlistStarted
* playlistEnded
* playlistCountDownStart
* playlistCountDownEnd
* playlistLoopStateChanged
* playlistAutoContinueStateChanged
* playlistError
* playlistLoadMediaError
* playlistCurrentPlayingItemChanged

### Handeling Playlist Controller

```swift
if let playlistController = self.player?.playlistController {
    // Configure PlaylistController
    
    // Set the playlist controller delegate if you need to manage plugins for each item
    // or countdown options for each item.
    playlistController.delegate = self
    
    // Also you may set some playlist controller options.
    playlistController.preloadTime = 120
    playlistController.loop = true
    
    // This is good place to handle UI updates that reuire playlist data.
    // Reload your UITableView/UIColloctionView here.
    
    // If needed start playlist playback.
    // playNext() will start it from the first item.
    self.player?.playlistController?.playNext()
}
```

### How to get access for individual playlist items?

Once playlist is loaded in the playlist controller you will have public access to `var playlist: PKPlaylist`
So basically you have to read `playlistController.playlist.medias` collection.

```swift
if let playlist = player?.playlistController?.playlist,
   let item = playlist.medias?[0] {
    
    print(item.name)
    print(item.duration)
}
```

### PlaylistControllerDelegate

To provide individual media items dedicated plugin configs or countdown options you have to set PlaylistControllerDelegate.

1. Plugin config implementation is similar to [Create the PluginConfig](#3-create-the-pluginconfig) and [Pass the PluginConfig to the PlayerOptions](#4-pass-the-pluginconfig-to-the-playeroptions).  
	With the one exeption you can provide own config for the requested media at index (check the example code).

2. Every playlist media may have specific `CountdownOptions` it will help you build countdown UI in you App if needed.   
	With [Playlists Controller events](#Register-for-Playlist-Controller-Events) `playlistCountDownStart` and `playlistCountDownEnd` you can listen for coundown updates.

```swift
extension PlaylistViewController: PlaylistControllerDelegate {
    
    func playlistController(_ controller: PlaylistController, updatePluginConfigForMediaItemAtIndex mediaItemIndex: Int) -> Bool {
        return true
    }
    
    func playlistController(_ controller: PlaylistController, pluginConfigForMediaItemAtIndex mediaItemIndex: Int) -> PluginConfig? {
        
        let youboraPluginParams: [String: Any] = [
            "accountCode": "kalturatest",
            "contentCustomDimensions": [
                "contentCustomDimension1": "Playlist ID: \(controller.playlist.id ?? "empty")",
                "contentCustomDimension2": "Playlist Item #: \(mediaItemIndex)",
                "contentCustomDimension3": "MediaEntry ID: \(controller.playlist.medias?[mediaItemIndex].id ?? "empty")",
            ]
        ]
        let analyticsConfig = AnalyticsConfig(params: youboraPluginParams)
        
        let imaConfig = IMAConfig()
        imaConfig.alwaysStartWithPreroll = true
        imaConfig.adTagUrl = "AD_TAG"
        
        return PluginConfig(config: [IMAPlugin.pluginName: imaConfig,
                                     YouboraPlugin.pluginName: analyticsConfig])
    }
    
    func playlistController(_ controller: PlaylistController, enableCountdownForMediaItemAtIndex mediaItemIndex: Int) -> Bool {
        return true
    }
    
    func playlistController(_ controller: PlaylistController, countdownOptionsForMediaItemAtIndex mediaItemIndex: Int) -> CountdownOptions? {
        
        let countdown = CountdownOptions()
        countdown.timeToShow = 240
        countdown.duration = 20
        return countdown
    }
}
```