//
//  YouboraConfigTemplate.swift
//  PlayKitYouboraSampleTests
//
//  Created by Sergey Chausov on 28.04.2021.
//

import Foundation

class YouboraConfigTemplate {
    
    typealias Template = YouboraConfigTemplate
    
    //
    //General
    static let accountCode = "kalturatest"
    static let userObfuscateIp = true
    
    static let isAutoStart = true
    static let isEnabled = true
    static let isForceInit = true
    static let haltOnError = false
    static let enableAnalytics = true
    static let enableSmartAds = true
    static let contentCdnNode = "KALTURA"
    static let contentCdnType = "Default"
    static let sendTotalBytes = 1234
    static let networkIP = "127.0.0.1"
    static let networkConnectionType = "cellular"
    static let networkIsp = "orange"
    
    static let username = "User Name"
    static let userEmail = "aaa1@gmail.com"
    static let userAnonymousId = "AnonymousUser123"
    static let appName = "My App name"
    static let appReleaseVersion = "v1.0.0"
    static let userType = "paid"
    static let houseHoldId = "qwerty HH"
    
    static let autoDetectBackground = true
    static let isOffline = false
    static let httpSecure = true
    
    static let extraParam1 = "MyParam1"
    static let extraParam2 = "MyParam2"
    static let extraParam3 = "MyParam3"
    static let extraParam4 = "MyParam4"
    static let extraParam5 = "MyParam5"
    static let extraParam6 = "MyParam6"
    static let extraParam7 = "MyParam7"
    static let extraParam8 = "MyParam8"
    static let extraParam9 = "MyParam9"
    static let extraParam10 = "MyParam10"
    static let extraParam11 = "MyParam11"
    static let extraParam12 = "MyParam12"
    static let extraParam13 = "MyParam13"
    static let extraParam14 = "MyParam14"
    static let extraParam15 = "MyParam15"
    static let extraParam16 = "MyParam16"
    static let extraParam17 = "MyParam17"
    static let extraParam18 = "MyParam18"
    static let extraParam19 = "MyParam19"
    static let extraParam20 = "MyParam20"
    
    // Parse
    static let parseManifest = true
    static let parseCdnNode = true
    static let parseCdnSwitchHeader = true
    static let parseCdnNodeList = ["Cloudfront", "Level3", "Fastly"]
    static let parseCdnNameHeader = "x-cdn-forward-test"
    static let parseCdnTTL = 55
    
    // ADs
    static let adBreaksTime = [10, 20, 30]
    static let adCampaign = "Campaign Name 1"
    static let campaign = "Campaign Name 2"
    static let adCreativeId = "123456"
    static let adExpectedBreaks = 123
    static let adGivenBreaks = 234
    static let adProvider = "Provider name"
    static let adResource = "Some resources"
    static let adTitle = "Ad title"
    static let adGivenAds = 3
    
    static let adCustomDimension1 = "My_adCustomDimension1"
    static let adCustomDimension2 = "My_adCustomDimension2"
    static let adCustomDimension3 = "My_adCustomDimension3"
    static let adCustomDimension4 = "My_adCustomDimension4"
    static let adCustomDimension5 = "My_adCustomDimension5"
    static let adCustomDimension6 = "vadCustomDimension6"
    static let adCustomDimension7 = "My_adCustomDimension7"
    static let adCustomDimension8 = "My_adCustomDimension8"
    static let adCustomDimension9 = "My_adCustomDimension9"
    static let adCustomDimension10 = "My_adCustomDimension10"
    
    // Media
    static let resource = contentResource
    static let isLive = contentIsLive
    static let isDVR = true
    static let title = contentTitle
    static let title2 = contentTitle2
    static let duration = contentDuration
    static let transactionCode = contentTransactionCode
    
    // Content
    static let contentProgram = "Program template" //contentTitle2
    static let contentResource = "Resource template"
    static let contentIsLive = true
    static let contentTitle = "Title template"
    static let contentTitle2 = "Title2 template"
    static let contentDuration: Double = 123.5
    static let contentTransactionCode = "TransactionCode template"
    static let contentBitrate: Double = 123231.32
    static let contentSendTotalBytes: Bool = true
    static let contentStreamingProtocol = "HLS"
    static let contentTransportFormat = "HLS-TS"
    static let contentThroughput: Int = 2
    static let contentRendition = "Rendition template"
    static let contentCdn = "KALTURA"
    static let contentFps: Double = 60.0
    static let contentIsLiveNoSeek: Bool = true
    static let contentPackage = "Package template"
    static let contentSaga = "Saga template"
    static let contentTvShow = "TvShow template"
    static let contentSeason = "19"
    static let contentEpisodeTitle = "EpisodeTitle template"
    static let contentChannel = "Channel template"
    static let contentId = "ASD323DDSFA321"
    static let contentImdbId = "1234567897654"
    static let contentGracenoteId = "kdkdk488447yyfhfhf7373"
    static let contentType = "Type template"
    static let contentGenre = "Drama"
    static let contentLanguage = "EN"
    static let contentSubtitles = "DE"
    static let contentContractedResolution = "1080p"
    static let contentCost = "FREE"
    static let contentPrice = "0 USD"
    static let contentPlaybackType = "PlaybackType template"
    static let contentDrm = "FPS"
    static let contentEncodingVideoCodec = "mpeg"
    static let contentEncodingAudioCodec = "dd"
    //let contentEncodingCodecSettings: String?
    static let contentEncodingCodecProfile = "EncodingCodecProfile template"
    static let contentEncodingContainerFormat = "EncodingContainerFormat template"
    
    // Device
    static let deviceBrand = "deviceBrand"
    static let deviceCode = "deviceCode"
    static let deviceId = "deviceId"
    static let deviceModel = "deviceModel"
    static let deviceOsName = "deviceOsName"
    static let deviceOsVersion = "deviceOsVersion"
    static let deviceType = "deviceType"
    static let deviceIsAnonymous = false
    
    // Errors
    static let errorsIgnore = ["exception1", "exception2"]
    static let errorsFatal = ["exception3", "exception4"]
    static let errorsNonFatal = ["exception5", "exception6"]
    
    static let ybConfigParams: [String: Any] = [
        "accountCode": Template.accountCode,
        "username": Template.username,
        "userEmail": Template.userEmail,
        "userType": Template.userType, // optional any string - free / paid etc.
        "userAnonymousId": userAnonymousId,
        "userObfuscateIp": userObfuscateIp,
        "houseHoldId": Template.houseHoldId, // optional which device is used to play
        "httpSecure": Template.httpSecure, // youbora events will be sent via https
        "autoDetectBackground": autoDetectBackground,
        "isOffline": isOffline,
        "isAutoStart": isAutoStart,
        "isEnabled": isEnabled,
        "isForceInit": isForceInit,
        "parse": parse,
        "app": app,
        "extraParams": extraParameters,
        "contentCustomDimensions": customDimensions,
        "ads": ads,
        "media": media,
        "content": content,
        "device": device,
        "network": network,
        "errors": errors,
        "properties": properties
    ]
    
    static let ads: [String: Any] = [
        "adBreaksTime": Template.adBreaksTime,
        "adCampaign": Template.adCampaign,
        "campaign": Template.campaign,
        "adCreativeId": Template.adCreativeId,
        "adExpectedBreaks": Template.adExpectedBreaks,
        "adGivenBreaks": Template.adGivenBreaks,
        "adProvider": Template.adProvider,
        "adResource": Template.adResource,
        "adTitle": Template.adTitle,
        "appName": Template.appName,
        "adGivenAds": Template.adGivenAds,
        "adCustomDimensions": [
            "adCustomDimension1": Template.adCustomDimension1,
            "adCustomDimension2": Template.adCustomDimension2,
            "adCustomDimension3": Template.adCustomDimension3,
            "adCustomDimension4": Template.adCustomDimension4,
            "adCustomDimension5": Template.adCustomDimension5,
            "adCustomDimension6": Template.adCustomDimension6,
            "adCustomDimension7": Template.adCustomDimension7,
            "adCustomDimension8": Template.adCustomDimension8,
            "adCustomDimension9": Template.adCustomDimension9,
            "adCustomDimension10": Template.adCustomDimension10
        ]
    ]
    
    static let customDimensions: [String: Any] = [
        "contentCustomDimension1": Template.extraParam1,
        "contentCustomDimension2": Template.extraParam2,
        "contentCustomDimension3": Template.extraParam3,
        "contentCustomDimension4": Template.extraParam4,
        "contentCustomDimension5": Template.extraParam5,
        "contentCustomDimension6": Template.extraParam6,
        "contentCustomDimension7": Template.extraParam7,
        "contentCustomDimension8": Template.extraParam8,
        "contentCustomDimension9": Template.extraParam9,
        "contentCustomDimension10": Template.extraParam10,
        "contentCustomDimension11": Template.extraParam11,
        "contentCustomDimension12": Template.extraParam12,
        "contentCustomDimension13": Template.extraParam13,
        "contentCustomDimension14": Template.extraParam14,
        "contentCustomDimension15": Template.extraParam15,
        "contentCustomDimension16": Template.extraParam16,
        "contentCustomDimension17": Template.extraParam17,
        "contentCustomDimension18": Template.extraParam18,
        "contentCustomDimension19": Template.extraParam19,
        "contentCustomDimension20": Template.extraParam20
    ]
    
    static let app: [String: Any] = [
        "appName": Template.appName,
        "appReleaseVersion": Template.appReleaseVersion
    ]
    
    static let parse: [String: Any] = [
        "parseManifest": Template.parseManifest,
        "parseCdnNode": Template.parseCdnNode,
        "parseCdnSwitchHeader": parseCdnSwitchHeader,
        "parseCdnNodeList": parseCdnNodeList,
        "parseCdnNameHeader": parseCdnNameHeader,
        "parseCdnTTL": parseCdnTTL
    ]
    
    static let content: [String: Any] = [
        "contentProgram": Template.contentProgram, //contentTitle2
        "contentResource": Template.contentResource,
        "contentIsLive": Template.contentIsLive,
        "contentTitle": Template.contentTitle,
        "contentTitle2": Template.contentTitle2,
        "contentDuration": Template.contentDuration,
        "contentTransactionCode": Template.contentTransactionCode,
        "contentBitrate": Template.contentBitrate,
        "contentSendTotalBytes": Template.contentSendTotalBytes,
        "contentStreamingProtocol": Template.contentStreamingProtocol,
        "contentTransportFormat": Template.contentTransportFormat,
        "contentThroughput": Template.contentThroughput,
        "contentRendition": Template.contentRendition,
        "contentCdn": Template.contentCdn,
        "contentFps": Template.contentFps,
        //"contentIsLiveNoSeek": Template.contentIsLiveNoSeek,
        "contentPackage": Template.contentPackage,
        "contentSaga": Template.contentSaga,
        "contentTvShow": Template.contentTvShow,
        "contentSeason": Template.contentSeason,
        "contentEpisodeTitle": Template.contentEpisodeTitle,
        "contentChannel": Template.contentChannel,
        "contentId": Template.contentId,
        "contentImdbId": Template.contentImdbId,
        "contentGracenoteId": Template.contentGracenoteId,
        "contentType": Template.contentType,
        "contentGenre": Template.contentGenre,
        "contentLanguage": Template.contentLanguage,
        "contentSubtitles": Template.contentSubtitles,
        "contentContractedResolution": Template.contentContractedResolution,
        "contentCost": Template.contentCost,
        "contentPrice": Template.contentPrice,
        "contentPlaybackType": Template.contentPlaybackType,
        "contentDrm": Template.contentDrm,
        "contentEncodingVideoCodec": Template.contentEncodingVideoCodec,
        "contentEncodingAudioCodec": Template.contentEncodingAudioCodec,
        //let contentEncodingCodecSettings: String?
        "contentEncodingCodecProfile": Template.contentEncodingCodecProfile,
        "contentEncodingContainerFormat": Template.contentEncodingContainerFormat,
        "isDVR": isDVR
    ]
    
    static let device: [String: Any] = [
        "deviceBrand": deviceBrand,
        "deviceCode": deviceCode,
        "deviceId": deviceId,
        "deviceModel": deviceModel,
        "deviceOsName": deviceOsName,
        "deviceOsVersion": deviceOsVersion,
        "deviceType": deviceType,
        "deviceIsAnonymous": deviceIsAnonymous
    ]
    
    static let network: [String: Any] = [
        "networkIP": networkIP,
        "networkIsp": networkIsp,
        "networkConnectionType": networkConnectionType
    ]
    
    static let errors: [String: Any] = [
        "errorsIgnore": errorsIgnore,
        "errorsFatal": errorsFatal,
        "errorsNonFatal": errorsNonFatal
    ]
    
    static let properties: [String: String] = [
        "year": "your_year",
        "cast": "your_cast",
        "director": "your_director",
        "owner": "your_owner",
        "parental": "your_parental",
        "rating": "your_rating",
        "audioChannels": "your_audio_channels",
        "device": "your_device"
    ]
    
    // Legacy support
    static let extraParameters: [String: Any] = [
        "extraParam1": Template.extraParam1,
        "extraParam2": Template.extraParam2,
        "extraParam3": Template.extraParam3,
        "extraParam4": Template.extraParam4,
        "extraParam5": Template.extraParam5,
        "extraParam6": Template.extraParam6,
        "extraParam7": Template.extraParam7,
        "extraParam8": Template.extraParam8,
        "extraParam9": Template.extraParam9,
        "extraParam10": Template.extraParam10,
        "extraParam11": Template.extraParam11,
        "extraParam12": Template.extraParam12,
        "extraParam13": Template.extraParam13,
        "extraParam14": Template.extraParam14,
        "extraParam15": Template.extraParam15,
        "extraParam16": Template.extraParam16,
        "extraParam17": Template.extraParam17,
        "extraParam18": Template.extraParam18,
        "extraParam19": Template.extraParam19,
        "extraParam20": Template.extraParam20
    ]
    
    static let media: [String: Any] = content
    
}
