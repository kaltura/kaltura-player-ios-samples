// ===================================================================================================
// Copyright (C) 2017 Kaltura Inc.
//
// Licensed under the AGPLv3 license, unless a different license for a 
// particular library is specified in the applicable library path.
//
// You may obtain a copy of the License at
// https://www.gnu.org/licenses/agpl-3.0.html
// ===================================================================================================

import PlayKit
import YouboraLib

public class YouboraPlugin: BasePlugin, AppStateObservable {
    
    struct CustomPropertyKey {
        static let sessionId = "sessionId"
    }
    
    public override class var pluginName: String {
        return "YouboraPlugin"
    }
    
    /// The key for enabling adnalyzer in the config dictionary
    @objc public static let enableSmartAdsKey = "enableSmartAds"
    
    public static let kaltura = "kaltura"
    
    /// The youbora plugin inheriting from `YBPluginGeneric`
    /// - important: Make sure to call `playHandler()` at the start of any flow before everying
    /// (for example before pre-roll in ads) also make sure to call `endedHandler() at the end of every flow
    /// (for example when we have post-roll call it after the ad).
    /// In addition, when content ends in the middle also make sure to call `endedHandler()`
    /// otherwise youbora will wait for /stop event and you could not start new content events until /stop is received.
    private var pkYouboraPlayerAdapter: PKYouboraPlayerAdapter?
    private var pkYouboraAdsAdapter: PKYouboraAdsAdapter?
    private var ybPlugin: YBPlugin?
    
    /// The plugin's config
    var config: AnalyticsConfig {
        didSet {
            self.addCustomProperties()
        }
    }
    var youboraConfig: YouboraConfig? {
        get {
            return parseYouboraConfig(fromConfig: config)
        }
    }
    
    /************************************************************/
    // MARK: - PKPlugin
    /************************************************************/
    
    public required init(player: Player, pluginConfig: Any?, messageBus: MessageBus) throws {
        guard let config = pluginConfig as? AnalyticsConfig else {
            PKLog.error("Missing plugin config")
            throw PKPluginError.missingPluginConfig(pluginName: YouboraPlugin.pluginName)
        }
        self.config = config
        
        try super.init(player: player, pluginConfig: pluginConfig, messageBus: messageBus)
        
        // The didSet of config is not performed before the super.init, therfore it needs to be called for the first time.
        self.addCustomProperties()
        
        pkYouboraPlayerAdapter = PKYouboraPlayerAdapter(player: player, messageBus: messageBus, config: youboraConfig)
        pkYouboraAdsAdapter = PKYouboraAdsAdapter(player: player, messageBus: messageBus)
        
        PKLog.debug("Start monitoring Youbora")
        ybPlugin = YBPlugin(options: youboraConfig?.options(), andAdapter: pkYouboraPlayerAdapter)
        ybPlugin?.adsAdapter = pkYouboraAdsAdapter

        // Monitor app state changes
        AppStateSubject.shared.add(observer: self)
    }
    
    public override func onUpdateMedia(mediaConfig: MediaConfig) {
        super.onUpdateMedia(mediaConfig: mediaConfig)
        
        // In case we stopped playback in the middle call eneded handlers and reset state.
        endedHandler()
        pkYouboraPlayerAdapter?.reset()
        pkYouboraAdsAdapter?.reset()
    }
    
    public override func onUpdateConfig(pluginConfig: Any) {
        super.onUpdateConfig(pluginConfig: pluginConfig)
        
        guard let config = pluginConfig as? AnalyticsConfig else {
            PKLog.error("Wrong config, could not setup youbora manager")
            messageBus?.post(PluginEvent.Error(nsError: YouboraPluginError.failedToSetupYouboraManager.asNSError))
            return
        }
        self.config = config
        
        pkYouboraPlayerAdapter?.config = youboraConfig
        ybPlugin?.options = youboraConfig?.options() ?? YBOptions()
    }
    
    public override func destroy() {
        // We must call `endedHandler()` when destroyed so youbora will know player stopped playing content.
        endedHandler()
        stopMonitoring()
        // Remove ad observers
        messageBus?.removeObserver(self, events: [AdEvent.adCuePointsUpdate, AdEvent.allAdsCompleted])
        AppStateSubject.shared.remove(observer: self)
        super.destroy()
    }
    
    /************************************************************/
    // MARK: - App State Handling
    /************************************************************/
    
    public var observations: Set<NotificationObservation> {
        return [
            NotificationObservation(name: UIApplication.willTerminateNotification) { [weak self] in
                guard let self = self else { return }
                
                PKLog.debug("youbora plugin will terminate event received")
                // We must call `endedHandler()` when stopped so youbora will know player stopped playing content.
                self.endedHandler()
                AppStateSubject.shared.remove(observer: self)
            },
            NotificationObservation(name: UIApplication.didEnterBackgroundNotification) { [weak self] in
                guard let self = self else { return }
                
                // When entering background we should call `endedHandler()` to make sure coming back starts a new session.
                // Otherwise events could be lost (youbora only retry sending events for 5 minutes).
                self.endedHandler()
                // Reset the youbora plugin for background handling to start playing again when we return.
                let pkYouboraPlayerAdapter = self.ybPlugin?.adapter as? PKYouboraPlayerAdapter

                pkYouboraPlayerAdapter?.resetForBackground()
            }
        ]
    }
    
    /************************************************************/
    // MARK: - Private
    /************************************************************/

    private func parseYouboraConfig(fromConfig config: AnalyticsConfig) -> YouboraConfig? {
        if !JSONSerialization.isValidJSONObject(config.params) {
            PKLog.error("Config params is not a valid JSON Object")
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: config.params, options: .prettyPrinted)
            let decodedYouboraConfig = try JSONDecoder().decode(YouboraConfig.self, from: data)
            return decodedYouboraConfig
            
        } catch let error as NSError {
            PKLog.error("Couldn't parse data into YouboraConfig error: \(error)")
        }
        
        return nil
    }
    
    private func stopMonitoring() {
        PKLog.debug("Stop monitoring using Youbora")
        ybPlugin?.removeAdsAdapter()
        ybPlugin?.removeAdapter()
    }
    
    private func endedHandler() {
        ybPlugin?.adsAdapter?.fireStop()
        ybPlugin?.adapter?.fireStop()
    }
    
    private func addCustomProperties() {
        guard let player = self.player else {
            PKLog.warning("couldn't add custom properties, player instance is nil")
            return
        }
        let propertiesKey = "properties"
        if var properties = config.params[propertiesKey] as? [String: Any] {
            // if properties already exists override the custom properties only
            properties[CustomPropertyKey.sessionId] = player.sessionId
            config.params[propertiesKey] = properties
        } else {
            // If properties doesn't exist then add
            config.params[propertiesKey] = [CustomPropertyKey.sessionId: player.sessionId]
        }
    }
}
