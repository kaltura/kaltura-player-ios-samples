# Kaltura Player iOS Samples

Include ```pod 'KalturaPlayer'``` in your Podfile.

## Basic Player

#### Create a KalturaBasicPlayer

```swift
var kalturaBasicPlayer: KalturaBasicPlayer! // Created in the viewDidLoad

override func viewDidLoad() {
	super.viewDidLoad()
	
	let basicPlayerOptions = BasicPlayerOptions(id: <id>, contentUrl: <contentUrl>)
	kalturaBasicPlayer = KalturaBasicPlayer(basicPlayerOptions: basicPlayerOptions)
}
```

In order to create a basic player you need to provide it with player options.  
The `BasicPlayerOptions` is initialized with the media `id` and `contentUrl`.  
The `BasicPlayerOptions` can be set with the `mediaFormat` and with `drmData` if needed, these are not mandatory.  

#### Pass the view to the KalturaBasicPlayer

Create a `KalturaPlayerView` in the xib or by code.  

```swift
@IBOutlet weak var kalturaPlayerView: KalturaPlayerView!

kalturaBasicPlayer.setPlayerView(kalturaPlayerView)

```

#### Register for Player Events

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

#### Prepare the player

This will prepare the player with the data provided in the `BasicPlayerOptions`

```swift
kalturaBasicPlayer.prepare()
```

#### Play

```swift
kalturaBasicPlayer.play()
```

Play on the player can be called straight after prepare, once it's ready and can play, the playback will start automatically.  
Registering to the player event `CanPlay` will enable you to know exactly when the play can be performed in case you need it controlled.
