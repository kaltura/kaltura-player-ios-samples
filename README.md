# Kaltura Player iOS Samples

In case of a **Basic Player**, include ```pod 'KalturaPlayer'``` in your Podfile.  
In case of an **OTT Player**, include ```pod 'KalturaPlayer/OTT'``` in your Podfile.

On this page:

- [Basic Player](#basic-player)
  - [1. Create a KalturaBasicPlayer](#1-create-a-kalturabasicplayer)
  - [2. Pass the view to the KalturaBasicPlayer](#2-pass-the-view-to-the-kalturabasicplayer)
  - [3. Register for Player Events](#3-register-for-player-events)
  - [4. Set the Media Entry](#4-set-the-media-entry)
  - [5. Prepare the player](#5-prepare-the-player)
  - [6. Play](#6-play)
  
- [OTT Player](#ott-player)
  - [1. Setup the KalturaOTTPlayerManager](#1-setup-the-kalturaottplayermanager)
  - [2. Create a KalturaOTTPlayer](#2-create-a-kalturaottplayer)
  - [3. Pass the view to the KalturaOTTPlayer](#3-pass-the-view-to-the-kalturaottplayer)
  - [4. Register for Player Events](#4-register-for-player-events)
  - [5. Create the media options](#5-create-the-media-options)
  - [6. Load the media](#6-load-the-media)
  - [7. Prepare the player](#7-prepare-the-player)
  - [8. Play](#8-play)
  
<!-- toc -->

## Basic Player

#### 1. Create a KalturaBasicPlayer

```swift
var kalturaBasicPlayer: KalturaBasicPlayer! // Created in the viewDidLoad

override func viewDidLoad() {
	super.viewDidLoad()
	
	let basicPlayerOptions = BasicPlayerOptions()
	kalturaBasicPlayer = KalturaBasicPlayer(options: basicPlayerOptions)
}
```

Check the `BasicPlayerOptions` class for more info.  
The available options and defaults that can be configured are:  

```swift
public var preload: Bool = true
public var autoPlay: Bool = true
public var pluginConfig: PluginConfig = PluginConfig(config: [:])
```

#### 2. Pass the view to the KalturaBasicPlayer

Create a `KalturaPlayerView` in the xib or in the code.  

```swift
@IBOutlet weak var kalturaPlayerView: KalturaPlayerView!

kalturaBasicPlayer.view = kalturaPlayerView

```

#### 3. Register for Player Events

In order to receive the events from the beginning, register to them before running prepare on the player.  

An example for the playback events in order to updated the UI on the button:

```swift
kalturaBasicPlayer.addObserver(self, events: [KPEvent.ended, KPEvent.play, KPEvent.playing, KPEvent.pause]) { [weak self] event in
	guard let self = self else { return }
	    
	NSLog(event.description)
	    
	DispatchQueue.main.async {
	    switch event {
	    case is KPEvent.Ended:
	        self.playPauseButton.displayState = .replay
	    case is KPEvent.Play:
	        self.playPauseButton.displayState = .pause
	    case is KPEvent.Playing:
	        self.playPauseButton.displayState = .pause
	    case is KPEvent.Pause:
	        self.playPauseButton.displayState = .play
	    default:
	        break
	    }
	}
}
```

An example to update the progress:

```swift
kalturaBasicPlayer.addObserver(self, events: [KPEvent.playheadUpdate]) { [weak self] event in
    guard let self = self else { return }
    let currentTime = event.currentTime ?? NSNumber(value: self.kalturaBasicPlayer.currentTime)
    DispatchQueue.main.async {
        self.mediaProgressSlider.value = Float(currentTime.doubleValue / self.kalturaBasicPlayer.duration)
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

#### 4. Set the Media Entry

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

#### 5. Prepare the player

**This will be done automatically** if the player options, `autoPlay` or `preload` is set too true.
Which those are the default values.

In case the `autoPlay` and `preload` are set to false, `prepare` on the player needs to be called manually.

```swift
kalturaBasicPlayer.prepare()
```

#### 6. Play

**This will be done automatically** if the player options, `autoPlay` is set too true. Which is the default value.

In case the `autoPlay` is set to false, `play` on the player needs to be called manually.

```swift
kalturaBasicPlayer.play()
```

Play on the player can be called straight after prepare, once it's ready and can play, the playback will start automatically.  
Registering to the player event `CanPlay` will enable you to know exactly when the play can be performed in case you need it controlled.

## OTT Player

The OTT Player has the Kava Plugin and Phoenix Analytics Plugin embedded, therefore no additional configuration for those plugins are required.

#### 1. Setup the KalturaOTTPlayerManager

In the AppDelegate call `setup` on the `KalturaOTTPlayerManager` when the app launches.

For Example:

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    KalturaOTTPlayerManager.setup(partnerId: 3009, serverURL: "https://rest-us.ott.kaltura.com/v4_5/api_v3/")
    
    return true
}
```

The `setup` will fetch for the configuration needed for the Kava Plugin. As well as register both Kava Plugin and Phoenix Analytics Plugin.

#### 2. Create a KalturaOTTPlayer

```swift
var kalturaOTTPlayer: KalturaOTTPlayer! // Created in the viewDidLoad

override func viewDidLoad() {
	super.viewDidLoad()
	
	let ottPlayerOptions = OTTPlayerOptions(ks: nil, referrer: nil)
	kalturaOTTPlayer = KalturaOTTPlayer(options: ottPlayerOptions)
}
```

Check the `OTTPlayerOptions` class for more info.  
The available options and defaults that can be configured are:  

```swift
public var preload: Bool = true
public var autoPlay: Bool = true
public var pluginConfig: PluginConfig = PluginConfig(config: [:])
```

#### 3. Pass the view to the KalturaOTTPlayer

Create a `KalturaPlayerView` in the xib or in the code.  

```swift
@IBOutlet weak var kalturaPlayerView: KalturaPlayerView!

kalturaOTTPlayer.view = kalturaPlayerView

```

#### 4. Register for Player Events

In order to receive the events from the beginning, register to them before running prepare on the player.  

An example for the playback events in order to updated the UI on the button:

```swift
kalturaOTTPlayer.addObserver(self, events: [KPEvent.ended, KPEvent.play, KPEvent.playing, KPEvent.pause]) { [weak self] event in
	guard let self = self else { return }
	    
	NSLog(event.description)
	    
	DispatchQueue.main.async {
	    switch event {
	    case is KPEvent.Ended:
	        self.playPauseButton.displayState = .replay
	    case is KPEvent.Play:
	        self.playPauseButton.displayState = .pause
	    case is KPEvent.Playing:
	        self.playPauseButton.displayState = .pause
	    case is KPEvent.Pause:
	        self.playPauseButton.displayState = .play
	    default:
	        break
	    }
	}
}
```

An example to update the progress:

```swift
kalturaOTTPlayer.addObserver(self, events: [KPEvent.playheadUpdate]) { [weak self] event in
    guard let self = self else { return }
    let currentTime = event.currentTime ?? NSNumber(value: self.kalturaOTTPlayer.currentTime)
    DispatchQueue.main.async {
        self.mediaProgressSlider.value = Float(currentTime.doubleValue / self.kalturaOTTPlayer.duration)
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

#### 5. Create the media options

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
```

#### 6. Load the media

Pass the created media options to the `loadMedia` function and implement the callback function in order to observe if an error has occurred.

For example:

```swift
kalturaOTTPlayer.loadMedia(options: ottMediaOptions) { [weak self] (error) in
    guard let self = self else { return }
    if error != nil {
        let alert = UIAlertController(title: "Media not loaded", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
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

#### 7. Prepare the player

**This will be done automatically** if the player options, `autoPlay` or `preload` is set too true.
Which those are the default values.

In case the `autoPlay` and `preload` are set to false, `prepare` on the player needs to be called manually.

```swift
kalturaOTTPlayer.prepare()
```

#### 8. Play

**This will be done automatically** if the player options, `autoPlay` is set too true. Which is the default value.

In case the `autoPlay` is set to false, `play` on the player needs to be called manually.

```swift
kalturaOTTPlayer.play()
```

Play on the player can be called straight after prepare, once it's ready and can play, the playback will start automatically.  
Registering to the player event `CanPlay` will enable you to know exactly when the play can be performed in case you need it controlled.
