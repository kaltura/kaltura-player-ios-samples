# Kaltura Player iOS Samples

In case of a **Basic Player**, include ```pod 'KalturaPlayer'``` in your Podfile.  
In case of an **OTT Player**, include ```pod 'KalturaPlayer/OTT'``` in your Podfile.

To use Cocoapods please refer to [Cocoapods Guides](https://guides.cocoapods.org/).

**Follow the steps for the required player:**

- [Basic Player](#basic-player)
  - [Setup the KalturaBasicPlayer](#1-setup-the-kalturabasicplayer)
  - [Create a KalturaBasicPlayer](#2-create-a-kalturabasicplayer)
  - [Pass the view to the KalturaBasicPlayer](#3-pass-the-view-to-the-kalturabasicplayer)
  - [Register for Player Events](#4-register-for-player-events)
  - [Set the Media Entry](#5-set-the-media-entry)
  - [Prepare the player](#6-prepare-the-player)
  - [Play](#7-play)
  
- [OTT Player](#ott-player)
  - [Setup the KalturaOTTPlayer](#1-setup-the-kalturaottplayer)
  - [Create a KalturaOTTPlayer](#2-create-a-kalturaottplayer)
  - [Pass the view to the KalturaOTTPlayer](#3-pass-the-view-to-the-kalturaottplayer)
  - [Register for Player Events](#4-register-for-player-events)
  - [Create the media options](#5-create-the-media-options)
  - [Load the media](#6-load-the-media)
  - [Prepare the player](#7-prepare-the-player)
  - [Play](#8-play)
  
- [Change Media](#change-media)  
  
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
  - [Create the PluginConfig](#3-create-the-pluginconfig)
  - [Pass the PluginConfig to the PlayerOptions](#4-pass-the-pluginconfig-to-the-playeroptions)

  
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

Check the `BasicPlayerOptions` class for more info.  
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

### 4. Register for Player Events

In order to receive the events from the beginning, register to them before running prepare on the player.  

An example for the playback events in order to updated the UI on the button:

```swift
kalturaBasicPlayer.addObserver(self, events: [KPPlayerEvent.ended, KPPlayerEvent.play, KPPlayerEvent.playing, KPPlayerEvent.pause]) { [weak self] event in
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
kalturaBasicPlayer.addObserver(self, events: [KPPlayerEvent.playheadUpdate]) { [weak self] event in
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

### 5. Set the Media Entry

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

### 6. Prepare the player

**This will be done automatically** if the player options, `autoPlay` or `preload` is set too true.
Which those are the default values.

In case the `autoPlay` and `preload` are set to false, `prepare` on the player needs to be called manually.

```swift
kalturaBasicPlayer.prepare()
```

### 7. Play

**This will be done automatically** if the player options, `autoPlay` is set too true. Which is the default value.

In case the `autoPlay` is set to false, `play` on the player needs to be called manually.

```swift
kalturaBasicPlayer.play()
```

Play on the player can be called straight after prepare, once it's ready and can play, the playback will start automatically.  
Registering to the player event `CanPlay` will enable you to know exactly when the play can be performed in case you need it controlled.

## OTT Player

The OTT Player has the Kava Plugin and Phoenix Analytics Plugin embedded, therefore no additional configuration for those plugins are required.

### 1. Setup the KalturaOTTPlayer

In the AppDelegate call `setup` on the `KalturaOTTPlayer` when the app launches.

For Example:

```swift
import KalturaPlayer

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    KalturaOTTPlayer.setup(partnerId: 3009, serverURL: "https://rest-us.ott.kaltura.com/v4_5/api_v3/")
    
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
public var referrer: String?
```

### 3. Pass the view to the KalturaOTTPlayer

Create a `KalturaPlayerView` in the xib or in the code.  

```swift
@IBOutlet weak var kalturaPlayerView: KalturaPlayerView!

kalturaOTTPlayer.view = kalturaPlayerView

```

### 4. Register for Player Events

In order to receive the events from the beginning, register to them before running prepare on the player.  

An example for the playback events in order to updated the UI on the button:

```swift
kalturaOTTPlayer.addObserver(self, events: [KPPlayerEvent.ended, KPPlayerEvent.play, KPPlayerEvent.playing, KPPlayerEvent.pause]) { [weak self] event in
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
kalturaOTTPlayer.addObserver(self, events: [KPPlayerEvent.playheadUpdate]) { [weak self] event in
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

### 5. Create the media options

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

### 6. Load the media

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

### 7. Prepare the player

**This will be done automatically** if the player options, `autoPlay` or `preload` is set too true.
Which those are the default values.

In case the `autoPlay` and `preload` are set to false, `prepare` on the player needs to be called manually.

```swift
kalturaOTTPlayer.prepare()
```

### 8. Play

**This will be done automatically** if the player options, `autoPlay` is set too true. Which is the default value.

In case the `autoPlay` is set to false, `play` on the player needs to be called manually.

```swift
kalturaOTTPlayer.play()
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

- For the KalturaBasicPlayer from section [Set the Media Entry](#5-set-the-media-entry)
- For the KalturaOTTPlayer from section [Create the media options](#5-create-the-media-options)

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

- The playerOptions is sent upon creating the Kaltura Player, see section [Create a KalturaBasicPlayer](#2-create-a-kalturabasicplayer) or [Create a KalturaOTTPlayer](#2-create-a-kalturaottplayer) for the relevant player. 
- The playerOptions can be updated upon a change media flow, see section [Change Media](#change-media)

### 5. Register to the ad events

In order to receive the events from the beginning, register to them before running prepare on the player.

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

- The playerOptions is sent upon creating the Kaltura Player, see section [Create a KalturaBasicPlayer](#2-create-a-kalturabasicplayer) or [Create a KalturaOTTPlayer](#2-create-a-kalturaottplayer) for the relevant player. 
- The playerOptions can be updated upon a change media flow, see section [Change Media](#change-media)