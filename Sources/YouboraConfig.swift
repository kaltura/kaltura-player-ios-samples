//
//  YouboraConfig.swift
//  Pods
//
//  Created by Nilit Danan on 5/8/18.
//

import YouboraLib

struct YouboraConfig: Decodable {
    let accountCode: String
    
    let username: String?
    let userEmail: String?
    let userAnonymousId: String?
    let userType: String?
    let obfuscateIP: Bool?
    let userObfuscateIp: Bool?
    
    var httpSecure: Bool? = true
    let contentCDN: String?
    let autoDetectBackground: Bool?
    let isOffline: Bool?
    
    let media: Media?
    let content: Content?
    let ads: Ads?
    let properties: Properties?
    
    let contentCustomDimensions: ContentCustomDimensions?
    let extraParams: ExtraParams?
    let houseHoldId: String?
    let isAutoStart: Bool?
    let isEnabled: Bool?
    let isForceInit: Bool?
    let appName: String?
    let app: App?
    let parse: Parse?
    let device: Device?
    let network: Network?
    let errors: Errors?
    
    func options() -> YBOptions {
        let options = YBOptions()
        
        options.accountCode = accountCode
        
        options.username = username
        options.userEmail = userEmail
        options.anonymousUser = userAnonymousId
        options.userType = userType
        
        if let obfuscateIP = obfuscateIP {
            options.userObfuscateIp = NSNumber(booleanLiteral: obfuscateIP)
        }
        
        if let userObfuscateIp = userObfuscateIp {
            options.userObfuscateIp = NSNumber(booleanLiteral: userObfuscateIp)
        }
        
        options.enabled = isEnabled ?? true
        
        options.httpSecure = httpSecure ?? true
        options.forceInit = isForceInit ?? false
        
        if let parse = parse {
            options.parseResource = parse.parseManifest ?? false
            options.parseCdnNode = parse.parseCdnNode ?? false
            options.cdnSwitchHeader = parse.parseCdnSwitchHeader ?? false
            
            if let cdnTTL = parse.parseCdnTTL { options.cdnTTL = TimeInterval(cdnTTL) }
            if let parseCdnNameHeader = parse.parseCdnNameHeader { options.parseCdnNameHeader = parseCdnNameHeader }
            
            if let parseCdnNodeList = parse.parseCdnNodeList, !parseCdnNodeList.isEmpty {
                options.parseCdnNodeList = NSMutableArray(array: parseCdnNodeList)
            }
        }
        
        options.deviceCode = nil // List of device codes http://mapi.youbora.com:8081/devices
        options.contentCdn = contentCDN // List of CDNs: http://mapi.youbora.com:8081/cdns
        
        // Legacy compatibility
        if let media = media {
            options.contentIsLive = media.isLive != nil ? NSNumber(booleanLiteral: media.isLive!) :  nil
            options.contentIsLiveNoSeek = media.isDVR != nil ? NSNumber(booleanLiteral: !(media.isDVR!)) : nil
            options.contentDuration = media.duration != nil ? NSNumber(value: media.duration!) : nil
            options.contentTitle = media.title
            options.program = media.title2
            
            if let program = media.program {
                options.program = program
            }
            
            options.contentTransactionCode = media.transactionCode
        }
        
        if let content = content {
            options.contentResource = content.contentResource
            options.contentTitle = content.contentTitle
            //options.program = content.contentTitle2
            options.program = content.contentProgram
            options.contentDuration = content.contentDuration as NSNumber?
            options.contentTransactionCode = content.contentTransactionCode
            options.contentBitrate = content.contentBitrate as NSNumber?
            options.sendTotalBytes = content.contentSendTotalBytes as NSNumber?
            options.contentStreamingProtocol = content.contentStreamingProtocol
            options.contentTransportFormat = content.contentTransportFormat
            options.contentThroughput = content.contentThroughput as NSNumber?
            options.contentRendition = content.contentRendition
            options.contentCdn = content.contentCdn
            options.contentFps = content.contentFps as NSNumber?
            
            options.contentIsLiveNoSeek = content.contentIsLiveNoSeek as NSValue?
            if let dvr = content.isDVR {
                options.contentIsLiveNoSeek = NSNumber(booleanLiteral: !dvr)
            }
            
            if let contentIsLive = content.contentIsLive {
                options.contentIsLive = NSNumber(booleanLiteral: contentIsLive)
            }
            
            options.contentPackage = content.contentPackage
            options.contentSaga = content.contentSaga
            options.contentTvShow = content.contentTvShow
            options.contentSeason = content.contentSeason
            options.contentEpisodeTitle = content.contentEpisodeTitle
            options.contentChannel = content.contentChannel
            options.contentId = content.contentId
            options.contentImdbId = content.contentImdbId
            options.contentGracenoteId = content.contentGracenoteId
            options.contentType = content.contentType
            options.contentGenre = content.contentGenre
            options.contentLanguage = content.contentLanguage
            options.contentSubtitles = content.contentSubtitles
            options.contentContractedResolution = content.contentContractedResolution
            options.contentCost = content.contentCost
            options.contentPrice = content.contentPrice
            options.contentPlaybackType = content.contentPlaybackType
            options.contentDrm = content.contentDrm
            options.contentEncodingVideoCodec = content.contentEncodingVideoCodec
            options.contentEncodingAudioCodec = content.contentEncodingAudioCodec
            //let contentEncodingCodecSettings: String?
            options.contentEncodingCodecProfile = content.contentEncodingCodecProfile
            options.contentEncodingContainerFormat = content.contentEncodingContainerFormat
        }
        
        options.adResource = nil
        options.adCampaign = ads?.campaign
        options.adTitle = ""
        
        // Legacy compatibility
        if let ads = ads, let adsExtraParams = ads.extraParams {
            options.adCustomDimension1 = adsExtraParams.param1
            options.adCustomDimension2 = adsExtraParams.param2
            options.adCustomDimension3 = adsExtraParams.param3
            options.adCustomDimension4 = adsExtraParams.param4
            options.adCustomDimension5 = adsExtraParams.param5
            options.adCustomDimension6 = adsExtraParams.param6
            options.adCustomDimension7 = adsExtraParams.param7
            options.adCustomDimension8 = adsExtraParams.param8
            options.adCustomDimension9 = adsExtraParams.param9
            options.adCustomDimension10 = adsExtraParams.param10
        }
        
        if let ads = ads {
            options.adTitle = ads.adTitle
            options.adCampaign = ads.adCampaign
            options.adProvider = ads.adProvider
            options.adResource = ads.adResource
            options.adCreativeId = ads.adCreativeId
            options.adGivenAds = ads.adGivenAds != nil ? NSNumber(value: ads.adGivenAds!) : nil
            
            if let adsCustomDimensions = ads.adCustomDimensions {
                options.adCustomDimension1 = adsCustomDimensions.adCustomDimension1
                options.adCustomDimension2 = adsCustomDimensions.adCustomDimension2
                options.adCustomDimension3 = adsCustomDimensions.adCustomDimension3
                options.adCustomDimension4 = adsCustomDimensions.adCustomDimension4
                options.adCustomDimension5 = adsCustomDimensions.adCustomDimension5
                options.adCustomDimension6 = adsCustomDimensions.adCustomDimension6
                options.adCustomDimension7 = adsCustomDimensions.adCustomDimension7
                options.adCustomDimension8 = adsCustomDimensions.adCustomDimension8
                options.adCustomDimension9 = adsCustomDimensions.adCustomDimension9
                options.adCustomDimension10 = adsCustomDimensions.adCustomDimension10
            }
        }
        
        if let properties = properties {
            options.contentMetadata = ["genre": properties.genre ?? "",
                                       "type": properties.type ?? "",
                                       "transaction_type": properties.transactionType ?? "",
                                       "year": properties.year ?? "",
                                       "cast": properties.cast ?? "",
                                       "director": properties.director ?? "",
                                       "owner": properties.owner ?? "",
                                       "parental": properties.parental ?? "",
                                       "price": properties.price ?? "",
                                       "rating": properties.rating ?? "",
                                       "audioType": properties.audioType ?? "",
                                       "audioChannels": properties.audioChannels ?? "",
                                       "device": properties.device ?? "",
                                       "quality": properties.quality ?? ""]
        }
        
        if let extraParams = extraParams {
            options.contentCustomDimension1 = extraParams.param1
            options.contentCustomDimension2 = extraParams.param2
            options.contentCustomDimension3 = extraParams.param3
            options.contentCustomDimension4 = extraParams.param4
            options.contentCustomDimension5 = extraParams.param5
            options.contentCustomDimension6 = extraParams.param6
            options.contentCustomDimension7 = extraParams.param7
            options.contentCustomDimension8 = extraParams.param8
            options.contentCustomDimension9 = extraParams.param9
            options.contentCustomDimension10 = extraParams.param10
        }
        
        if let customDimensions = contentCustomDimensions {
            options.contentCustomDimension1 = customDimensions.contentCustomDimension1
            options.contentCustomDimension2 = customDimensions.contentCustomDimension2
            options.contentCustomDimension3 = customDimensions.contentCustomDimension3
            options.contentCustomDimension4 = customDimensions.contentCustomDimension4
            options.contentCustomDimension5 = customDimensions.contentCustomDimension5
            options.contentCustomDimension6 = customDimensions.contentCustomDimension6
            options.contentCustomDimension7 = customDimensions.contentCustomDimension7
            options.contentCustomDimension8 = customDimensions.contentCustomDimension8
            options.contentCustomDimension9 = customDimensions.contentCustomDimension9
            options.contentCustomDimension10 = customDimensions.contentCustomDimension10
            options.contentCustomDimension11 = customDimensions.contentCustomDimension11
            options.contentCustomDimension12 = customDimensions.contentCustomDimension12
            options.contentCustomDimension13 = customDimensions.contentCustomDimension13
            options.contentCustomDimension14 = customDimensions.contentCustomDimension14
            options.contentCustomDimension15 = customDimensions.contentCustomDimension15
            options.contentCustomDimension16 = customDimensions.contentCustomDimension16
            options.contentCustomDimension17 = customDimensions.contentCustomDimension17
            options.contentCustomDimension18 = customDimensions.contentCustomDimension18
            options.contentCustomDimension19 = customDimensions.contentCustomDimension19
            options.contentCustomDimension20 = customDimensions.contentCustomDimension20
        }
        
        if let appName = appName {
            options.appName = appName
        }
        
        if let app = app {
            options.appName = app.appName
            options.appReleaseVersion = app.appReleaseVersion
        }
        
        if let device = device {
            options.deviceBrand = device.deviceBrand
            options.deviceCode = device.deviceCode
            options.deviceUUID = device.deviceId
            options.deviceModel = device.deviceModel
            options.deviceOsName = device.deviceOsName
            options.deviceOsVersion = device.deviceOsVersion
            options.deviceType = device.deviceType
            
            if let deviceIsAnonymous = device.deviceIsAnonymous {
                options.deviceIsAnonymous = deviceIsAnonymous
            }
        }
        
        if let network = network {
            options.networkIP = network.networkIP
            options.networkIsp = network.networkIsp
            options.networkConnectionType = network.networkConnectionType
        }
        
        if let errors = errors {
            options.ignoreErrors = errors.errorsIgnore
            options.fatalErrors = errors.errorsFatal
            options.nonFatalErrors = errors.errorsNonFatal
        }
        
        return options
    }
    
}

struct Content: Decodable {
    let resource: String?
    let isLive: Bool?
    let isDVR: Bool?
    let title: String?
    let title2: String?
    let duration: Double?
    let transactionCode: String?
    let contentProgram: String? //contentTitle2
    let contentResource: String?
    let contentIsLive: Bool?
    let contentTitle: String?
    let contentTitle2: String?
    let contentDuration: Double?
    let contentTransactionCode: String?
    let contentBitrate: Double? //NSNumber
    let contentSendTotalBytes: Bool?
    let contentStreamingProtocol: String?
    let contentTransportFormat: String?
    let contentThroughput: Int?
    let contentRendition: String?
    let contentCdn: String?
    let contentFps: Double?
    let contentIsLiveNoSeek: Bool?
    let contentPackage: String?
    let contentSaga: String?
    let contentTvShow: String?
    let contentSeason: String?
    let contentEpisodeTitle: String?
    let contentChannel: String?
    let contentId: String?
    let contentImdbId: String?
    let contentGracenoteId: String?
    let contentType: String?
    let contentGenre: String?
    let contentLanguage: String?
    let contentSubtitles: String?
    let contentContractedResolution: String?
    let contentCost: String?
    let contentPrice: String?
    let contentPlaybackType: String?
    let contentDrm: String?
    let contentEncodingVideoCodec: String?
    let contentEncodingAudioCodec: String?
    //let contentEncodingCodecSettings: String?
    let contentEncodingCodecProfile: String?
    let contentEncodingContainerFormat: String?
}

struct Media: Decodable {
    let resource: String?
    let isLive: Bool?
    let isDVR: Bool?
    let title: String?
    let title2: String?
    let program: String?
    let duration: Double?
    let transactionCode: String?
}

struct Ads: Decodable {
    let adBreaksTime: [Int]?
    let campaign: String?
    let adCampaign: String?
    let adCreativeId: String?
    let adExpectedBreaks: Int?
    let adGivenBreaks: Int?
    let adProvider: String?
    let adResource: String?
    let adTitle: String?
    let extraParams: ExtraParams?
    let adCustomDimensions: AdCustomDimensions?
    let adGivenAds: Int?
    //let adExpectedPattern: [String: AnyHashable]?
    //let adMetadata: [String: AnyHashable]?
}

//typealias ContentMetadata = Properties

struct Properties: Decodable {
    let genre: String?
    let type: String?
    let transactionType: String?
    let year: String?
    let cast: String?
    let director: String?
    let owner: String?
    let parental: String?
    let price: String?
    let rating: String?
    let audioType: String?
    let audioChannels: String?
    let device: String?
    let quality: String?
}

struct AdCustomDimensions: Decodable {
    let adCustomDimension1: String?
    let adCustomDimension2: String?
    let adCustomDimension3: String?
    let adCustomDimension4: String?
    let adCustomDimension5: String?
    let adCustomDimension6: String?
    let adCustomDimension7: String?
    let adCustomDimension8: String?
    let adCustomDimension9: String?
    let adCustomDimension10: String?
}

struct ContentCustomDimensions: Decodable {
    let contentCustomDimension1: String?
    let contentCustomDimension2: String?
    let contentCustomDimension3: String?
    let contentCustomDimension4: String?
    let contentCustomDimension5: String?
    let contentCustomDimension6: String?
    let contentCustomDimension7: String?
    let contentCustomDimension8: String?
    let contentCustomDimension9: String?
    let contentCustomDimension10: String?
    let contentCustomDimension11: String?
    let contentCustomDimension12: String?
    let contentCustomDimension13: String?
    let contentCustomDimension14: String?
    let contentCustomDimension15: String?
    let contentCustomDimension16: String?
    let contentCustomDimension17: String?
    let contentCustomDimension18: String?
    let contentCustomDimension19: String?
    let contentCustomDimension20: String?
}

struct ExtraParams: Decodable {
    let param1: String?
    let param2: String?
    let param3: String?
    let param4: String?
    let param5: String?
    let param6: String?
    let param7: String?
    let param8: String?
    let param9: String?
    let param10: String?
}

struct Parse: Decodable {
    let parseManifest: Bool?
    let parseCdnNode: Bool?
    let parseCdnSwitchHeader: Bool?
    let parseCdnNodeList: [String]?
    let parseCdnNameHeader: String?
    let parseCdnTTL: Int?
}

struct App: Decodable {
    let appName: String?
    let appReleaseVersion: String?
}

struct Network: Decodable {
    let networkIP: String?
    let networkIsp: String?
    let networkConnectionType: String?
    let networkObfuscateIp: String?
    let userObfuscateIp: String?
}

struct Device: Decodable {
    let deviceBrand: String?
    let deviceCode: String?
    let deviceId: String?
    let deviceModel: String?
    let deviceOsName: String?
    let deviceOsVersion: String?
    let deviceType: String?
    let deviceIsAnonymous: Bool?
}

struct Errors: Decodable {
    let errorsIgnore: [String]?
    let errorsFatal: [String]?
    let errorsNonFatal: [String]?
}
