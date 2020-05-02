# Kaltura Player iOS Samples

Include ```pod 'KalturaPlayer'``` in your Podfile.

## Basic Player

#### 1. Create a KalturaBasicPlayer

```swift
var kalturaBasicPlayer: KalturaBasicPlayer! // Created in the viewDidLoad

override func viewDidLoad() {
	super.viewDidLoad()
	
	let basicPlayerOptions = BasicPlayerOptions()
	kalturaBasicPlayer = KalturaBasicPlayer(basicPlayerOptions: basicPlayerOptions)
}
```

Check the BasicPlayerOptions class for more info.  
The available options and defaults that can be configured are:  

```swift
public var preload: Bool = true
public var autoPlay: Bool = true
public var startTime: TimeInterval?
public var pluginConfig: PluginConfig = PluginConfig(config: [:])
```

#### 2. Pass the view to the KalturaBasicPlayer

Create a `KalturaPlayerView` in the xib or in the code.  

```swift
@IBOutlet weak var kalturaPlayerView: KalturaPlayerView!

kalturaBasicPlayer.setPlayerView(kalturaPlayerView)

```

#### 3. Register for Player Events

In order to receive the events from the begining, register to them before running prepare on the player.  

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
	
	kalturaBasicPlayer.mediaEntry = mediaEntry
	```
	
2. Use the `setupMediaEntry` function.
	
	```swift
	let contentUrl = URL(string:"https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8")
	kalturaBasicPlayer.setupMediaEntry(id: "sintel", contentUrl: contentUrl)
	```
	
	Check the function for more available params.

#### 5. Prepare the player

**This will be done automatically** if the player options, `autoPlay` or `preload` is set to true.
Which those are the default values.

In case the `autoPlay` and `preload` are set to false, `prepare` on the player needs to be called manually.

```swift
kalturaBasicPlayer.prepare()
```

#### 6. Play

```swift
kalturaBasicPlayer.play()
```

Play on the player can be called straight after prepare, once it's ready and can play, the playback will start automatically.  
Registering to the player event `CanPlay` will enable you to know exactly when the play can be performed in case you need it controlled.
