//
//  BasicVideoData.swift
//  BasicSample
//
//  Created by Nilit Danan on 5/27/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import PlayKit
import KalturaPlayer

extension VideoData {

    static func getBasicVideos() -> [VideoData] {
        var videos: [VideoData] = []
        
        let customPlaylistCountdownOptions = CountdownOptions()
        customPlaylistCountdownOptions.timeToShow = 30
        customPlaylistCountdownOptions.duration = 20
        
        // Sending a free form Media
        
        videos.append(VideoData(title: "Sintel - Free Form Media - Defaults",
                                freeFormMedia: FreeFormMedia(id: "sintel",
                                                             contentUrl: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"),
                                playlistCountdownOptions: customPlaylistCountdownOptions))
        
        videos.append(VideoData(title: "Sintel - Free Form Media - autoPlay false",
                                freeFormMedia: FreeFormMedia(id: "sintel",
                                                             contentUrl: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"),
                                player: PlayerData(autoPlay: false, preload: false)))
        
        videos.append(VideoData(title: "Sintel - Free Form Media - startPosition 30",
                                freeFormMedia: FreeFormMedia(id: "sintel",
                                                             contentUrl: "https://cdnapisec.kaltura.com/p/2215841/playManifest/entryId/1_w9zx2eti/format/applehttp/protocol/https/a.m3u8"),
                                startTime: 30.0))
        
        videos.append(VideoData(title: "Free Form Media - error",
                                freeFormMedia: FreeFormMedia(id: "1_tzhsuqij",
                                                             contentUrl: "http://cdnapi.kaltura.com/p/1774581/sp/177458100/playManifest/entryId/1_tzhsuqij1/format/applehttp/tags/ipad/protocol/http/f/a.m3u8")))
        
        videos.append(VideoData(title: "Kaltura Live with DVR - auto play",
                                freeFormMedia: FreeFormMedia(id: "0_nwkp7jtx",
                                                             contentUrl: "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_nwkp7jtx/protocol/http/format/applehttp/flavorIds/0_iju7j519,0_98mlrldo,0_5hts3h5r,0_n6n76xp9/a.m3u8",
                                                             mediaType: .dvrLive),
                                player: PlayerData(autoPlay: true)))
        
        videos.append(VideoData(title: "FairPlay DRM - no auto play",
                                freeFormMedia: FreeFormMedia(id: "1_i18rihuv",
                                                             contentUrl: "https://cdnapisec.kaltura.com/p/2222401/sp/2222401/playManifest/entryId/1_i18rihuv/flavorIds/1_nwoofqvr,1_3z75wwxi,1_exjt5le8,1_uvb3fyqs/deliveryProfileId/8642/protocol/https/format/applehttp/a.m3u8",
                                                             drmData:[FairPlayDRMParams(licenseUri: "https://udrmv3.kaltura.com/fps/license?custom_data=eyJjYV9zeXN0ZW0iOiJPVlAiLCJ1c2VyX3Rva2VuIjoiZGpKOE1qSXlNalF3TVh4S0piNmxBa3Y1d0l2NVN2dXJSU3MteGQ0VmtGQ3FlMWNhWGlzUG1YQmFjb2EwcGtsbmhfd3JjOFN5LU5laWhIQUxxRE04am9XWlNudjRqMldnUVdESVhKcGw1MXFIcm5GRVE5cmhWQ2RHc2c9PSIsImFjY291bnRfaWQiOiIyMjIyNDAxIiwiY29udGVudF9pZCI6IjFfaTE4cmlodXYiLCJmaWxlcyI6IjFfbndvb2ZxdnIsMV8zejc1d3d4aSwxX2V4anQ1bGU4LDFfdXZiM2Z5cXMifQ%3D%3D&signature=EBEsK0EWEGxsBWjpcqATQUxbAyE%3D",
                                                             base64EncodedCertificate: "MIIFETCCA/mgAwIBAgIISWLo8KcYfPMwDQYJKoZIhvcNAQEFBQAwfzELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MTMwMQYDVQQDDCpBcHBsZSBLZXkgU2VydmljZXMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMjAxMTY0NTQ0WhcNMTgwMjAxMTY0NTQ0WjCBijELMAkGA1UEBhMCVVMxKDAmBgNVBAoMH1ZJQUNPTSAxOCBNRURJQSBQUklWQVRFIExJTUlURUQxEzARBgNVBAsMClE5QU5HR0w4TTYxPDA6BgNVBAMMM0ZhaXJQbGF5IFN0cmVhbWluZzogVklBQ09NIDE4IE1FRElBIFBSSVZBVEUgTElNSVRFRDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA2YmfdPWM86+te7Bbt4Ic6FexXwMeL+8AmExIj8jAaNxhKbfVFnUnuXzHOajGC7XDbXxsFbPqnErqjw0BqUoZhs+WVMy+0X4AGqHk7uRpZ4RLYganel+fqitL9rz9w3p41x8JfLV+lAej+BEN7zNeqQ2IsC4BxkViu1gA6K22uGsCAwEAAaOCAgcwggIDMB0GA1UdDgQWBBQK+Gmarl2PO3jtLP6A6TZeihOL3DAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFGPkR1TLhXFZRiyDrMxEMWRnAyy+MIHiBgNVHSAEgdowgdcwgdQGCSqGSIb3Y2QFATCBxjCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA1BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vY3JsLmFwcGxlLmNvbS9rZXlzZXJ2aWNlcy5jcmwwDgYDVR0PAQH/BAQDAgUgMEgGCyqGSIb3Y2QGDQEDAQH/BDYBZ2diOGN5bXpsb21vdXFqb3p0aHg5aXB6dDJ0bThrcGdqOGNwZGlsbGVhMWI1aG9saWlyaW8wPQYLKoZIhvdjZAYNAQQBAf8EKwF5aHZlYXgzaDB2Nno5dXBqcjRsNWVyNm9hMXBtam9zYXF6ZXdnZXFkaTUwDQYJKoZIhvcNAQEFBQADggEBAIaTVzuOpZhHHUMGd47XeIo08E+Wb5jgE2HPsd8P/aHwVcR+9627QkuAnebftasV/h3FElahzBXRbK52qIZ/UU9nRLCqqKwX33eS2TiaAzOoMAL9cTUmEa2SMSzzAehb7lYPC73Y4VQFttbNidHZHawGp/844ipBS7Iumas8kT8G6ZmIBIevWiggd+D5gLdqXpOFI2XsoAipuxW6NKnnlKnuX6aNReqzKO0DmQPDHO2d7pbd3wAz5zJmxDLpRQfn7iJKupoYGqBs2r45OFyM14HUWaC0+VSh2PaZKwnSS8XXo4zcT/MfEcmP0tL9NaDfsvIWnScMxHUUTNNsZIp3QXA=")]),
                                player: PlayerData(autoPlay: false)))
        
        // Sending a MediaEntry
        
        let contentURL = URL(string: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8")
        let entryId = "1_vl96wf1o"
        let source = PKMediaSource(entryId, contentUrl: contentURL, mediaFormat: .hls)
        let sources: Array = [source]
        let mediaEntry = PKMediaEntry(entryId, sources: sources, duration: -1)
        videos.append(VideoData(title: "KalturaMedia - MediaEntry - Defaults", mediaEntry: mediaEntry))
        
        videos.append(VideoData(title: "KalturaMedia - MediaEntry - autoPlay false", mediaEntry: mediaEntry, player: PlayerData(autoPlay: false)))
        
        videos.append(VideoData(title: "KalturaMedia - MediaEntry - startPosition 10", mediaEntry: mediaEntry, startTime: 10.0))
        
        return videos
    }
}
