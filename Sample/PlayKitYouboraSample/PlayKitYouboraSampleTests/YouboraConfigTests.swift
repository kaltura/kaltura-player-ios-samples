//
//  YouboraConfigTests.swift
//  PlayKitYouboraSampleTests
//
//  Created by Sergey Chausov on 27.04.2021.
//

import XCTest
import PlayKit
@testable import PlayKitYoubora
import YouboraLib

class YouboraConfigTests: XCTestCase {
    
    var ybConfig: YouboraConfig?
    typealias ybc = YouboraConfigTemplate
    
    override func setUp() {
        
        let config = AnalyticsConfig(params: ybc.ybConfigParams)
        
        if !JSONSerialization.isValidJSONObject(config.params) {
            XCTAssertThrowsError("Config params is not a valid JSON Object")
            return
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: config.params, options: .prettyPrinted)
            let decodedYouboraConfig = try JSONDecoder().decode(YouboraConfig.self, from: data)
            self.ybConfig = decodedYouboraConfig

        } catch let error as NSError {
            XCTAssertThrowsError("Couldn't parse data into YouboraConfig error: \(error)")
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeneralOptions() throws {
        guard let config = self.ybConfig else {
            return
        }
        let options: YBOptions = config.options()
        
        XCTAssertNotNil(options.accountCode)
        XCTAssertNotNil(options.httpSecure)
        XCTAssertNotNil(options.contentCdn)
        XCTAssertNotNil(options.autoDetectBackground)
        XCTAssertNotNil(options.offline)
        
        //XCTAssertNotNil(options.houseHoldId)
        //XCTAssertNotNil(options.isAutoStart)
        XCTAssertNotNil(options.enabled)
        XCTAssertNotNil(options.forceInit)
       
        XCTAssertTrue(options.accountCode == ybc.accountCode)
        XCTAssertTrue(options.httpSecure == ybc.httpSecure)
        XCTAssertTrue(options.contentCdn == ybc.contentCdn)
        XCTAssertTrue(options.autoDetectBackground == ybc.autoDetectBackground)
        XCTAssertTrue(options.offline == ybc.isOffline)
        XCTAssertTrue(options.enabled == ybc.isEnabled)
        XCTAssertTrue(options.forceInit == ybc.isForceInit)
    }
    
    func testAppOptions() throws {
        guard let config = self.ybConfig else {
            return
        }
        
        let options: YBOptions = config.options()
        
        // Testing options related to App
        XCTAssertNotNil(options.appName)
        XCTAssertNotNil(options.appReleaseVersion)
        
        XCTAssertTrue(options.appName == ybc.appName)
        XCTAssertTrue(options.appReleaseVersion == ybc.appReleaseVersion)
    }
    
    func testUserOptions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        
        let options: YBOptions = config.options()
        
        // Testing options related to User
        XCTAssertNotNil(options.username)
        XCTAssertNotNil(options.userEmail)
        XCTAssertNotNil(options.userType)
        XCTAssertNotNil(options.anonymousUser)
        XCTAssertNotNil(options.userObfuscateIp)
        
        XCTAssertTrue(options.username == ybc.username)
        XCTAssertTrue(options.userEmail == ybc.userEmail)
        XCTAssertTrue(options.userType == ybc.userType)
        XCTAssertTrue(options.anonymousUser == ybc.userAnonymousId)
        XCTAssertTrue(options.userObfuscateIp as? Bool == ybc.userObfuscateIp)
    }
    
    func testAdsOptions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        let options: YBOptions = config.options()
        
        // Testing options related to Ads
        XCTAssertNotNil(options.adTitle)
        XCTAssertNotNil(options.adCampaign)
        XCTAssertNotNil(options.adProvider)
        XCTAssertNotNil(options.adResource)
        XCTAssertNotNil(options.adCreativeId)
        XCTAssertNotNil(options.adGivenAds)
        
        XCTAssertTrue(options.adTitle == ybc.adTitle)
        XCTAssertTrue(options.adCampaign == ybc.adCampaign)
        XCTAssertTrue(options.adProvider == ybc.adProvider)
        XCTAssertTrue(options.adResource == ybc.adResource)
        XCTAssertTrue(options.adCreativeId == ybc.adCreativeId)
        XCTAssertTrue(options.adGivenAds as? Int == ybc.adGivenAds)
    }
    
    func testAdsCustomDimensions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        let options: YBOptions = config.options()
        
        // Testing ADs custom dimensions
        XCTAssertNotNil(options.adCustomDimension1)
        XCTAssertNotNil(options.adCustomDimension2)
        XCTAssertNotNil(options.adCustomDimension3)
        XCTAssertNotNil(options.adCustomDimension4)
        XCTAssertNotNil(options.adCustomDimension5)
        XCTAssertNotNil(options.adCustomDimension6)
        XCTAssertNotNil(options.adCustomDimension7)
        XCTAssertNotNil(options.adCustomDimension8)
        XCTAssertNotNil(options.adCustomDimension9)
        XCTAssertNotNil(options.adCustomDimension10)
        
        XCTAssertTrue(options.adCustomDimension1 == ybc.adCustomDimension1)
        XCTAssertTrue(options.adCustomDimension2 == ybc.adCustomDimension2)
        XCTAssertTrue(options.adCustomDimension3 == ybc.adCustomDimension3)
        XCTAssertTrue(options.adCustomDimension4 == ybc.adCustomDimension4)
        XCTAssertTrue(options.adCustomDimension5 == ybc.adCustomDimension5)
        XCTAssertTrue(options.adCustomDimension6 == ybc.adCustomDimension6)
        XCTAssertTrue(options.adCustomDimension7 == ybc.adCustomDimension7)
        XCTAssertTrue(options.adCustomDimension8 == ybc.adCustomDimension8)
        XCTAssertTrue(options.adCustomDimension9 == ybc.adCustomDimension9)
        XCTAssertTrue(options.adCustomDimension10 == ybc.adCustomDimension10)
    }
    
    func testCustomDimensions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        let options: YBOptions = config.options()
        
        // Testing Custom Dimensions aka Extra parameters
        XCTAssertNotNil(options.contentCustomDimension1)
        XCTAssertNotNil(options.contentCustomDimension2)
        XCTAssertNotNil(options.contentCustomDimension3)
        XCTAssertNotNil(options.contentCustomDimension4)
        XCTAssertNotNil(options.contentCustomDimension5)
        XCTAssertNotNil(options.contentCustomDimension6)
        XCTAssertNotNil(options.contentCustomDimension7)
        XCTAssertNotNil(options.contentCustomDimension8)
        XCTAssertNotNil(options.contentCustomDimension9)
        XCTAssertNotNil(options.contentCustomDimension10)
        XCTAssertNotNil(options.contentCustomDimension11)
        XCTAssertNotNil(options.contentCustomDimension12)
        XCTAssertNotNil(options.contentCustomDimension13)
        XCTAssertNotNil(options.contentCustomDimension14)
        XCTAssertNotNil(options.contentCustomDimension15)
        XCTAssertNotNil(options.contentCustomDimension16)
        XCTAssertNotNil(options.contentCustomDimension17)
        XCTAssertNotNil(options.contentCustomDimension18)
        XCTAssertNotNil(options.contentCustomDimension19)
        XCTAssertNotNil(options.contentCustomDimension20)
        
        // extraParams
        XCTAssertTrue(options.contentCustomDimension1 == ybc.extraParam1)
        XCTAssertTrue(options.contentCustomDimension2 == ybc.extraParam2)
        XCTAssertTrue(options.contentCustomDimension3 == ybc.extraParam3)
        XCTAssertTrue(options.contentCustomDimension4 == ybc.extraParam4)
        XCTAssertTrue(options.contentCustomDimension5 == ybc.extraParam5)
        XCTAssertTrue(options.contentCustomDimension6 == ybc.extraParam6)
        XCTAssertTrue(options.contentCustomDimension7 == ybc.extraParam7)
        XCTAssertTrue(options.contentCustomDimension8 == ybc.extraParam8)
        XCTAssertTrue(options.contentCustomDimension9 == ybc.extraParam9)
        XCTAssertTrue(options.contentCustomDimension10 == ybc.extraParam10)
        XCTAssertTrue(options.contentCustomDimension11 == ybc.extraParam11)
        XCTAssertTrue(options.contentCustomDimension12 == ybc.extraParam12)
        XCTAssertTrue(options.contentCustomDimension13 == ybc.extraParam13)
        XCTAssertTrue(options.contentCustomDimension14 == ybc.extraParam14)
        XCTAssertTrue(options.contentCustomDimension15 == ybc.extraParam15)
        XCTAssertTrue(options.contentCustomDimension16 == ybc.extraParam16)
        XCTAssertTrue(options.contentCustomDimension17 == ybc.extraParam17)
        XCTAssertTrue(options.contentCustomDimension18 == ybc.extraParam18)
        XCTAssertTrue(options.contentCustomDimension19 == ybc.extraParam19)
        XCTAssertTrue(options.contentCustomDimension20 == ybc.extraParam20)
    }
    
    func testContentOptions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        let options: YBOptions = config.options()
        
        // Testing Content options
        XCTAssertNotNil(options.program)
        XCTAssertNotNil(options.contentResource)
        XCTAssertNotNil(options.contentIsLive)
        XCTAssertNotNil(options.contentTitle)
        XCTAssertNotNil(options.contentDuration)
        XCTAssertNotNil(options.contentTransactionCode)
        XCTAssertNotNil(options.contentBitrate)
        XCTAssertNotNil(options.sendTotalBytes)
        XCTAssertNotNil(options.contentStreamingProtocol)
        XCTAssertNotNil(options.contentTransportFormat)
        XCTAssertNotNil(options.contentThroughput)
        XCTAssertNotNil(options.contentRendition)
        XCTAssertNotNil(options.contentCdn)
        XCTAssertNotNil(options.contentFps)
        XCTAssertNotNil(options.contentIsLiveNoSeek)
        XCTAssertNotNil(options.contentPackage)
        XCTAssertNotNil(options.contentSaga)
        XCTAssertNotNil(options.contentTvShow)
        XCTAssertNotNil(options.contentSeason)
        XCTAssertNotNil(options.contentEpisodeTitle)
        XCTAssertNotNil(options.contentChannel)
        XCTAssertNotNil(options.contentId)
        XCTAssertNotNil(options.contentImdbId)
        XCTAssertNotNil(options.contentGracenoteId)
        XCTAssertNotNil(options.contentType)
        XCTAssertNotNil(options.contentGenre)
        XCTAssertNotNil(options.contentLanguage)
        XCTAssertNotNil(options.contentSubtitles)
        XCTAssertNotNil(options.contentContractedResolution)
        XCTAssertNotNil(options.contentCost)
        XCTAssertNotNil(options.contentPrice)
        XCTAssertNotNil(options.contentPlaybackType)
        XCTAssertNotNil(options.contentDrm)
        XCTAssertNotNil(options.contentEncodingVideoCodec)
        XCTAssertNotNil(options.contentEncodingAudioCodec)
        XCTAssertNotNil(options.contentEncodingCodecProfile)
        XCTAssertNotNil(options.contentEncodingContainerFormat)
        
        //
        XCTAssertTrue(options.program == ybc.contentProgram)
        XCTAssertTrue(options.contentResource == ybc.contentResource)
        XCTAssertTrue(options.contentIsLive as? Bool == ybc.contentIsLive)
        XCTAssertTrue(options.contentTitle == ybc.contentTitle)
        XCTAssertTrue(options.contentDuration as? Double == ybc.contentDuration)
        XCTAssertTrue(options.contentTransactionCode == ybc.contentTransactionCode)
        XCTAssertTrue(options.contentBitrate as? Double == ybc.contentBitrate)
        XCTAssertTrue(options.sendTotalBytes as? Bool == ybc.contentSendTotalBytes)
        XCTAssertTrue(options.contentStreamingProtocol == ybc.contentStreamingProtocol)
        XCTAssertTrue(options.contentTransportFormat == ybc.contentTransportFormat)
        XCTAssertTrue(options.contentThroughput as? Int == ybc.contentThroughput)
        XCTAssertTrue(options.contentRendition == ybc.contentRendition)
        XCTAssertTrue(options.contentCdn == ybc.contentCdn)
        XCTAssertTrue(options.contentFps as? Double == ybc.contentFps)
        XCTAssertTrue(options.contentIsLiveNoSeek as? Bool != ybc.isDVR)
        XCTAssertTrue(options.contentPackage == ybc.contentPackage)
        XCTAssertTrue(options.contentSaga == ybc.contentSaga)
        XCTAssertTrue(options.contentTvShow == ybc.contentTvShow)
        XCTAssertTrue(options.contentSeason == ybc.contentSeason)
        XCTAssertTrue(options.contentEpisodeTitle == ybc.contentEpisodeTitle)
        XCTAssertTrue(options.contentChannel == ybc.contentChannel)
        XCTAssertTrue(options.contentId == ybc.contentId)
        XCTAssertTrue(options.contentImdbId == ybc.contentImdbId)
        XCTAssertTrue(options.contentGracenoteId == ybc.contentGracenoteId)
        XCTAssertTrue(options.contentType == ybc.contentType)
        XCTAssertTrue(options.contentGenre == ybc.contentGenre)
        XCTAssertTrue(options.contentLanguage == ybc.contentLanguage)
        XCTAssertTrue(options.contentSubtitles == ybc.contentSubtitles)
        XCTAssertTrue(options.contentContractedResolution == ybc.contentContractedResolution)
        XCTAssertTrue(options.contentCost == ybc.contentCost)
        XCTAssertTrue(options.contentPrice == ybc.contentPrice)
        XCTAssertTrue(options.contentPlaybackType == ybc.contentPlaybackType)
        XCTAssertTrue(options.contentDrm == ybc.contentDrm)
        XCTAssertTrue(options.contentEncodingVideoCodec == ybc.contentEncodingVideoCodec)
        XCTAssertTrue(options.contentEncodingAudioCodec == ybc.contentEncodingAudioCodec)
        XCTAssertTrue(options.contentEncodingCodecProfile == ybc.contentEncodingCodecProfile)
        XCTAssertTrue(options.contentEncodingContainerFormat == ybc.contentEncodingContainerFormat)
    }
    
    func testParseOptions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        let options: YBOptions = config.options()
        
        // Testing Parse options
        XCTAssertNotNil(options.parseResource)
        XCTAssertNotNil(options.parseCdnNode)
        XCTAssertNotNil(options.cdnSwitchHeader)
        XCTAssertNotNil(options.cdnTTL)
        XCTAssertNotNil(options.parseCdnNameHeader)
        XCTAssertNotNil(options.parseCdnNodeList)
        
        XCTAssertTrue(options.parseResource == ybc.parseManifest)
        XCTAssertTrue(options.parseCdnNode == ybc.parseCdnNode)
        XCTAssertTrue(options.cdnSwitchHeader == ybc.parseCdnSwitchHeader)
        XCTAssertTrue(Int(options.cdnTTL)  == ybc.parseCdnTTL, "cdnTTL is: \(options.cdnTTL)")
        XCTAssertTrue(options.parseCdnNameHeader == ybc.parseCdnNameHeader)
        XCTAssertTrue(options.parseCdnNodeList?.firstObject as? String == ybc.parseCdnNodeList.first)
        XCTAssertTrue(options.parseCdnNodeList?.lastObject as? String == ybc.parseCdnNodeList.last)
    }
    
    func testErrorsOptions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        let options: YBOptions = config.options()
        
        // Testing Errors
        XCTAssertNotNil(options.ignoreErrors)
        XCTAssertNotNil(options.fatalErrors)
        XCTAssertNotNil(options.nonFatalErrors)
        
        XCTAssertTrue(options.ignoreErrors?.first == ybc.errorsIgnore.first)
        XCTAssertTrue(options.ignoreErrors?.last == ybc.errorsIgnore.last)
        XCTAssertTrue(options.fatalErrors?.first == ybc.errorsFatal.first)
        XCTAssertTrue(options.fatalErrors?.last == ybc.errorsFatal.last)
        XCTAssertTrue(options.nonFatalErrors?.first == ybc.errorsNonFatal.first)
        XCTAssertTrue(options.nonFatalErrors?.last == ybc.errorsNonFatal.last)
    }
    
    func testNetworkOptions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        let options: YBOptions = config.options()
        
        // Testing Network options
        XCTAssertNotNil(options.networkIP)
        XCTAssertNotNil(options.networkIsp)
        XCTAssertNotNil(options.networkConnectionType)
        
        XCTAssertTrue(options.networkIP == ybc.networkIP)
        XCTAssertTrue(options.networkIsp == ybc.networkIsp)
        XCTAssertTrue(options.networkConnectionType == ybc.networkConnectionType)
    }
    
    func testDeviceOptions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        let options: YBOptions = config.options()
        
        // Testing Device options
        XCTAssertNotNil(options.deviceBrand)
        XCTAssertNotNil(options.deviceCode)
        XCTAssertNotNil(options.deviceUUID)
        XCTAssertNotNil(options.deviceModel)
        XCTAssertNotNil(options.deviceOsName)
        XCTAssertNotNil(options.deviceOsVersion)
        XCTAssertNotNil(options.deviceType)
        XCTAssertNotNil(options.deviceIsAnonymous)
        
        XCTAssertTrue(options.deviceBrand == ybc.deviceBrand)
        XCTAssertTrue(options.deviceCode == ybc.deviceCode)
        XCTAssertTrue(options.deviceUUID == ybc.deviceId)
        XCTAssertTrue(options.deviceModel == ybc.deviceModel)
        XCTAssertTrue(options.deviceOsName == ybc.deviceOsName)
        XCTAssertTrue(options.deviceOsVersion == ybc.deviceOsVersion)
        XCTAssertTrue(options.deviceType == ybc.deviceType)
        XCTAssertTrue(options.deviceIsAnonymous == ybc.deviceIsAnonymous)
    }
    
    func testContentMetadataOptions() throws {
        guard let config = self.ybConfig else {
            XCTExpectFailure("YouboraConfig is missing")
            return
        }
        let options: YBOptions = config.options()
        
        // Testing Content
        XCTAssertNotNil(options.contentMetadata)
        
        XCTAssertNotNil(options.contentMetadata?["genre"])
        XCTAssertNotNil(options.contentMetadata?["type"])
        XCTAssertNotNil(options.contentMetadata?["transaction_type"])
        XCTAssertNotNil(options.contentMetadata?["year"])
        XCTAssertNotNil(options.contentMetadata?["cast"])
        XCTAssertNotNil(options.contentMetadata?["director"])
        XCTAssertNotNil(options.contentMetadata?["owner"])
        XCTAssertNotNil(options.contentMetadata?["parental"])
        XCTAssertNotNil(options.contentMetadata?["price"])
        XCTAssertNotNil(options.contentMetadata?["rating"])
        XCTAssertNotNil(options.contentMetadata?["audioType"])
        XCTAssertNotNil(options.contentMetadata?["audioChannels"])
        XCTAssertNotNil(options.contentMetadata?["device"])
        XCTAssertNotNil(options.contentMetadata?["quality"])
    }
    
}
