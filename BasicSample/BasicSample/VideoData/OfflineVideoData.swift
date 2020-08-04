//
//  OfflineVideoData.swift
//  BasicSample
//
//  Created by Nilit Danan on 7/5/20.
//  Copyright © 2020 Kaltura Inc. All rights reserved.
//

import KalturaPlayer
import PlayKit

extension VideoData {
    
    static func getOfflineVideos() -> [VideoData] {
        var videos: [VideoData] = []
                        
        let defaultOfflineSelectionOptions = OfflineSelectionOptions()
            .setMinVideoHeight(300)
            .setMinVideoBitrate(.avc1, 3_000_000)
            .setMinVideoBitrate(.hevc, 5_000_000)
            .setPreferredVideoCodecs([.hevc, .avc1])
            .setPreferredAudioCodecs([.ac3, .mp4a])
            .setAllTextLanguages()
            .setAllAudioLanguages()
        
        defaultOfflineSelectionOptions.allowInefficientCodecs = true

        videos.append(VideoData(title: "KalturaMedia 1_vl96wf1o",
                                mediaEntry: PKMediaEntry("1_vl96wf1o",
                                                         sources: [PKMediaSource("1_vl96wf1o",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/2215841/sp/221584100/playManifest/entryId/1_vl96wf1o/format/applehttp/protocol/https/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "AES-128 multi-key",
                                mediaEntry: PKMediaEntry("AES-128 multi-key",
                                                         sources: [PKMediaSource("AES-128 multi-key",
                                                                                 contentUrl: URL(string: "https://noamtamim.com/random/hls/test-enc-aes/multi.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "Eran multi audio - 0_7s8q41df",
                                mediaEntry: PKMediaEntry("0_7s8q41df",
                                                         sources: [PKMediaSource("0_7s8q41df",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/2035982/sp/203598200/playManifest/entryId/0_7s8q41df/format/applehttp/protocol/https/name/a.m3u8?deliveryProfileId=4712"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "Trailer - 0_ksthpwh8",
                                mediaEntry: PKMediaEntry("0_ksthpwh8",
                                                         sources: [PKMediaSource("0_ksthpwh8",
                                                                                 contentUrl: URL(string: "http://cdnbakmi.kaltura.com/p/1758922/sp/175892200/playManifest/entryId/0_ksthpwh8/format/applehttp/tags/ipad/protocol/http/f/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "Bunny",
                                mediaEntry: PKMediaEntry("bunny",
                                                         sources: [PKMediaSource("bunny",
                                                                                 contentUrl: URL(string: "https://noamtamim.com/hls-bunny/index.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        videos.append(VideoData(title: "FairPlay DRM",
                                mediaEntry: PKMediaEntry("1_i18rihuv",
                                                         sources: [PKMediaSource("1_i18rihuv",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/2222401/sp/2222401/playManifest/entryId/1_i18rihuv/flavorIds/1_nwoofqvr,1_3z75wwxi,1_exjt5le8,1_uvb3fyqs/deliveryProfileId/8642/protocol/https/format/applehttp/a.m3u8"),
                                                                                 mimeType: nil,
                                                                                 drmData: [FairPlayDRMParams(licenseUri: "https://udrmv3.kaltura.com/fps/license?custom_data=eyJjYV9zeXN0ZW0iOiJPVlAiLCJ1c2VyX3Rva2VuIjoiZGpKOE1qSXlNalF3TVh4S0piNmxBa3Y1d0l2NVN2dXJSU3MteGQ0VmtGQ3FlMWNhWGlzUG1YQmFjb2EwcGtsbmhfd3JjOFN5LU5laWhIQUxxRE04am9XWlNudjRqMldnUVdESVhKcGw1MXFIcm5GRVE5cmhWQ2RHc2c9PSIsImFjY291bnRfaWQiOiIyMjIyNDAxIiwiY29udGVudF9pZCI6IjFfaTE4cmlodXYiLCJmaWxlcyI6IjFfbndvb2ZxdnIsMV8zejc1d3d4aSwxX2V4anQ1bGU4LDFfdXZiM2Z5cXMifQ%3D%3D&signature=EBEsK0EWEGxsBWjpcqATQUxbAyE%3D",
                                                                                                             base64EncodedCertificate: "MIIFETCCA/mgAwIBAgIISWLo8KcYfPMwDQYJKoZIhvcNAQEFBQAwfzELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MTMwMQYDVQQDDCpBcHBsZSBLZXkgU2VydmljZXMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMjAxMTY0NTQ0WhcNMTgwMjAxMTY0NTQ0WjCBijELMAkGA1UEBhMCVVMxKDAmBgNVBAoMH1ZJQUNPTSAxOCBNRURJQSBQUklWQVRFIExJTUlURUQxEzARBgNVBAsMClE5QU5HR0w4TTYxPDA6BgNVBAMMM0ZhaXJQbGF5IFN0cmVhbWluZzogVklBQ09NIDE4IE1FRElBIFBSSVZBVEUgTElNSVRFRDCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA2YmfdPWM86+te7Bbt4Ic6FexXwMeL+8AmExIj8jAaNxhKbfVFnUnuXzHOajGC7XDbXxsFbPqnErqjw0BqUoZhs+WVMy+0X4AGqHk7uRpZ4RLYganel+fqitL9rz9w3p41x8JfLV+lAej+BEN7zNeqQ2IsC4BxkViu1gA6K22uGsCAwEAAaOCAgcwggIDMB0GA1UdDgQWBBQK+Gmarl2PO3jtLP6A6TZeihOL3DAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFGPkR1TLhXFZRiyDrMxEMWRnAyy+MIHiBgNVHSAEgdowgdcwgdQGCSqGSIb3Y2QFATCBxjCBwwYIKwYBBQUHAgIwgbYMgbNSZWxpYW5jZSBvbiB0aGlzIGNlcnRpZmljYXRlIGJ5IGFueSBwYXJ0eSBhc3N1bWVzIGFjY2VwdGFuY2Ugb2YgdGhlIHRoZW4gYXBwbGljYWJsZSBzdGFuZGFyZCB0ZXJtcyBhbmQgY29uZGl0aW9ucyBvZiB1c2UsIGNlcnRpZmljYXRlIHBvbGljeSBhbmQgY2VydGlmaWNhdGlvbiBwcmFjdGljZSBzdGF0ZW1lbnRzLjA1BgNVHR8ELjAsMCqgKKAmhiRodHRwOi8vY3JsLmFwcGxlLmNvbS9rZXlzZXJ2aWNlcy5jcmwwDgYDVR0PAQH/BAQDAgUgMEgGCyqGSIb3Y2QGDQEDAQH/BDYBZ2diOGN5bXpsb21vdXFqb3p0aHg5aXB6dDJ0bThrcGdqOGNwZGlsbGVhMWI1aG9saWlyaW8wPQYLKoZIhvdjZAYNAQQBAf8EKwF5aHZlYXgzaDB2Nno5dXBqcjRsNWVyNm9hMXBtam9zYXF6ZXdnZXFkaTUwDQYJKoZIhvcNAQEFBQADggEBAIaTVzuOpZhHHUMGd47XeIo08E+Wb5jgE2HPsd8P/aHwVcR+9627QkuAnebftasV/h3FElahzBXRbK52qIZ/UU9nRLCqqKwX33eS2TiaAzOoMAL9cTUmEa2SMSzzAehb7lYPC73Y4VQFttbNidHZHawGp/844ipBS7Iumas8kT8G6ZmIBIevWiggd+D5gLdqXpOFI2XsoAipuxW6NKnnlKnuX6aNReqzKO0DmQPDHO2d7pbd3wAz5zJmxDLpRQfn7iJKupoYGqBs2r45OFyM14HUWaC0+VSh2PaZKwnSS8XXo4zcT/MfEcmP0tL9NaDfsvIWnScMxHUUTNNsZIp3QXA=")],
                                                                                 mediaFormat: .unknown)],
                                                         duration: -1),
                                offlineSelectionOptions: defaultOfflineSelectionOptions))
        
        let offlineSelectionOptionsSelectedLanguages = OfflineSelectionOptions()
            .setTextLanguages(["en", "ru"])
            .setAudioLanguages(["en"])
        
        videos.append(VideoData(title: "QA multi/multi - Selected Languages",
                                mediaEntry: PKMediaEntry("0_mskmqcit",
                                                         sources: [PKMediaSource("0_mskmqcit",
                                                                                 contentUrl: URL(string: "http://cdntesting.qa.mkaltura.com/p/1091/sp/109100/playManifest/entryId/0_mskmqcit/flavorIds/0_et3i1dux,0_pa4k1rn9/format/applehttp/protocol/http/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedLanguages))
        
        let offlineSelectionOptionsSelectedBitrate = OfflineSelectionOptions()
            .setMinVideoBitrate(.avc1, 800_000)
            .setMinVideoBitrate(.hevc, 600_000)
        
        videos.append(VideoData(title: "hevc- - Selected Video Bitrate",
                                mediaEntry: PKMediaEntry("1_w9zx2eti",
                                                         sources: [PKMediaSource("1_w9zx2eti",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/0/playManifest/entryId/0_axrfacp3/format/applehttp/protocol/https/flavorParamIds/2390161,2390171,2390181,2390201,487091,487081,487071,487061/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedBitrate))
        
        let offlineSelectionOptionsSelectedBitrateAllowInefficientCodecs = OfflineSelectionOptions()
            .setMinVideoBitrate(.avc1, 800_000)
            .setMinVideoBitrate(.hevc, 600_000)
        
        offlineSelectionOptionsSelectedBitrateAllowInefficientCodecs.allowInefficientCodecs = true
        
        videos.append(VideoData(title: "hevc+ - Selected Video Bitrate",
                                mediaEntry: PKMediaEntry("1_w9zx2eti+",
                                                         sources: [PKMediaSource("1_w9zx2eti+",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/0/playManifest/entryId/0_axrfacp3/format/applehttp/protocol/https/flavorParamIds/2390161,2390171,2390181,2390201,487091,487081,487071,487061/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedBitrate))
        
        let offlineSelectionOptionsSelectedCodecsAllowInefficientCodecsNoHevc = OfflineSelectionOptions()
            .setPreferredVideoCodecs([.avc1])
        
        offlineSelectionOptionsSelectedCodecsAllowInefficientCodecsNoHevc.allowInefficientCodecs = true
        
        videos.append(VideoData(title: "hevc+ but no hevc - Selected Video Bitrate",
                                mediaEntry: PKMediaEntry("1_w9zx2eti+-",
                                                         sources: [PKMediaSource("1_w9zx2eti+-",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/0/playManifest/entryId/0_axrfacp3/format/applehttp/protocol/https/flavorParamIds/2390161,2390171,2390181,2390201,487091,487081,487071,487061/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedCodecsAllowInefficientCodecsNoHevc))
        
        let offlineSelectionOptionsSelectedVideoHeight = OfflineSelectionOptions()
            .setMinVideoHeight(360)
        
        videos.append(VideoData(title: "Kaltura 360p - Selected Video Height",
                                mediaEntry: PKMediaEntry("1_sf5ovm7u",
                                                         sources: [PKMediaSource("1_sf5ovm7u",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/243342/sp/24334200/playManifest/entryId/1_sf5ovm7u/format/applehttp/protocol/https/name/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedVideoHeight))
        
        let offlineSelectionOptionsSelectedVideoHeight2 = OfflineSelectionOptions()
            .setMinVideoHeight(720)
        
        videos.append(VideoData(title: "Kaltura 720p - Selected Video Height",
                                mediaEntry: PKMediaEntry("1_sf5ovm7u-720p",
                                                         sources: [PKMediaSource("1_sf5ovm7u-720p",
                                                                                 contentUrl: URL(string: "https://cdnapisec.kaltura.com/p/243342/sp/24334200/playManifest/entryId/1_sf5ovm7u/format/applehttp/protocol/https/name/a.m3u8"),
                                                                                 mediaFormat: .hls)],
                                                         duration: -1),
                                offlineSelectionOptions: offlineSelectionOptionsSelectedVideoHeight2))
        
        return videos
    }
}
