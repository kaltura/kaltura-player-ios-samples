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
        
        
        videos.append(VideoData(title: "CH VOD FairPlay DRM",                                freeFormMedia: FreeFormMedia(id: "2119347",                                                             contentUrl: "https://cdnapisec.kaltura.com/p/4281523/sp/428152300/playManifest/protocol/https//entryId/1_e65kefsx/format/applehttp/tags/mbr/f/a.m3u8",                                                             drmData:[FairPlayDRMParams(licenseUri: "https://udrmv3.kaltura.com/fps/license?custom_data=eyJjYV9zeXN0ZW0iOiJodHRwOi8vYXBpLmZycDEub3R0LmthbHR1cmEuY29tL2FwaV92My9zZXJ2aWNlL2Fzc2V0RmlsZS9hY3Rpb24vZ2V0Q29udGV4dD9rcz1kako4TXpJeU0zeWpkOVctSmVzV1Z1WGpJTjJZMWtMT2o1V0YwdWdNalNOYVIydmFiUTFQZmpmS0dWUjlKY0ZfLVRwamdQTTZVMmF1UzBTQWhBbDh2aFFHcHVvNnFpTUZWdTQ2Q05mN0RGMVBTMUdYSTlrV2VNSHEtU1lhdkNMZHBTRDloR1JpRWF0bkhla1RIT0NVQTFVeEJMWXZUM1lEbzBoZzlZMEp6SDNDTXZfa2duLTRmdEIzcERhQUVyNVl2Ykcxal81TVQ5QTY0Y1FodjFNanlQeVhkTHE2SUhiLXJlNmctYnN0cGtRU0hSMHlJNlRzYXFsRUlDMThtTW5RWUJKOW1mX19DSlhVaS14dS1FbnhDUHZ6aXpwbzBYeFJLc3NVQnozMkJva1FmYlAwMEk3ZlIza2dYSkdKVEs2MlpoaWNHdDB0VGluNTVXQm9LNFo5S3VFX2pWUmJ1eFhUWFQyeGpmS1F5Z253eDlHamhXNWNtdUFCRXNrTTA0UzFfUjA0dDU5U0JoWT0mY29udGV4dFR5cGU9bm9uZSZpZD0yNzM5OTM2IiwiYWNjb3VudF9pZCI6NDI4MTUyMywiY29udGVudF9pZCI6IjFfZTY1a2Vmc3hfMV9vbG5idnF0ZywxX2U2NWtlZnN4XzFfbDJycW00NDMsMV9lNjVrZWZzeF8xX3Z5bHNmMjBjLDFfZTY1a2Vmc3hfMV84NDc5dXdrdCwxX2U2NWtlZnN4XzFfY2ZoZ3VsOGYsMV9lNjVrZWZzeF8xX2M5cG5lOHBrIiwiZmlsZXMiOiIiLCJ1c2VyX3Rva2VuIjoiZGpKOE16SXlNM3lqZDlXLUplc1dWdVhqSU4yWTFrTE9qNVdGMHVnTWpTTmFSMnZhYlExUGZqZktHVlI5SmNGXy1UcGpnUE02VTJhdVMwU0FoQWw4dmhRR3B1bzZxaU1GVnU0NkNOZjdERjFQUzFHWEk5a1dlTUhxLVNZYXZDTGRwU0Q5aEdSaUVhdG5IZWtUSE9DVUExVXhCTFl2VDNZRG8waGc5WTBKekgzQ012X2tnbi00ZnRCM3BEYUFFcjVZdmJHMWpfNU1UOUE2NGNRaHYxTWp5UHlYZExxNklIYi1yZTZnLWJzdHBrUVNIUjB5STZUc2FxbEVJQzE4bU1uUVlCSjltZl9fQ0pYVWkteHUtRW54Q1B2eml6cG8wWHhSS3NzVUJ6MzJCb2tRZmJQMDBJN2ZSM2tnWEpHSlRLNjJaaGljR3QwdFRpbjU1V0JvSzRaOUt1RV9qVlJidXhYVFhUMnhqZktReWdud3g5R2poVzVjbXVBQkVza00wNFMxX1IwNHQ1OVNCaFk9IiwidWRpZCI6ImQwYmE3N2U5ZjMwZThiNDgwOTJlY2Y4ODgwNTVmOTliYTA1ZWNjZGY4ZjYwZGM2YzFhZTBhNTlhMjM5ZjBjYmEiLCJhZGRpdGlvbmFsX2Nhc19zeXN0ZW0iOjMyMjN9&signature=UzNNsNTeGyKDBAOdI5781KMr3ps%3d",                                                                                        base64EncodedCertificate: "MIIExzCCA6+gAwIBAgIIf02CaQMSNHgwDQYJKoZIhvcNAQEFBQAwfzELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MTMwMQYDVQQDDCpBcHBsZSBLZXkgU2VydmljZXMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMjEwOTI3MTAwMTQxWhcNMjMwOTI4MTAwMTQwWjBsMQswCQYDVQQGEwJDSDEZMBcGA1UECgwQQVogQ3Jvc3NtZWRpYSBBRzETMBEGA1UECwwKRTQ2WFo1OUg2MzEtMCsGA1UEAwwkRmFpclBsYXkgU3RyZWFtaW5nOiBBWiBDcm9zc21lZGlhIEFHMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDL0DRkKSK2dljv8tu+TUpyGDn1f/ReYUs5NGYfUCVWXWHvWhVGofv4IWUAv4Woejs+uvAcDP5gzhegvso+YdIwNR4T1rJRDIgA2svmDc13Ryv4GvUoEqRNR5hDE+HwFu9XnQWPt99yKMVoMQMZnLpiVSXM4ohCQWJv9GS9PHSxxQIDAQABo4IB3DCCAdgwDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBRj5EdUy4VxWUYsg6zMRDFkZwMsvjCB4gYDVR0gBIHaMIHXMIHUBgkqhkiG92NkBQEwgcYwgcMGCCsGAQUFBwICMIG2DIGzUmVsaWFuY2Ugb24gdGhpcyBjZXJ0aWZpY2F0ZSBieSBhbnkgcGFydHkgYXNzdW1lcyBhY2NlcHRhbmNlIG9mIHRoZSB0aGVuIGFwcGxpY2FibGUgc3RhbmRhcmQgdGVybXMgYW5kIGNvbmRpdGlvbnMgb2YgdXNlLCBjZXJ0aWZpY2F0ZSBwb2xpY3kgYW5kIGNlcnRpZmljYXRpb24gcHJhY3RpY2Ugc3RhdGVtZW50cy4wNQYDVR0fBC4wLDAqoCigJoYkaHR0cDovL2NybC5hcHBsZS5jb20va2V5c2VydmljZXMuY3JsMB0GA1UdDgQWBBTtS4QXdIVKbZwyc34VcnOgP5jgnTAOBgNVHQ8BAf8EBAMCBSAwMwYLKoZIhvdjZAYNAQMBAf8EIQEza3c3eXZneGI5Y2psZXI1dXBmbzJrNmFiNGFucmtsdjAnBgsqhkiG92NkBg0BBAEB/wQVAXBjaGZyNnhscWY0b2ZtcDZkeGZ0MA0GCSqGSIb3DQEBBQUAA4IBAQBqOPJJlSw0EIu9t7iyuX+YpbKhz0cJCCklCahsJHgF3w+7gpFtaeY0Rr7KVX1/xydzJELcHHE42pNfqr3s77Tz2FcnYYEXONueIl6NaIe+6gK/9RT1bOQ9I/lekUsK01nek4y2Ww5/VlU0IFHHSDWjTQFRJtTmaEF9mGgIOZX885b7jmJ1Ki0nJixJQH1RCPUElN8WAJ2aw2kw4oKCVtVFHzdrJB0LeitvFON5PT/5rERNy6aNXyVGsIkb3NxeJn9I0dsGGMRMQ0RLVuFlU5iRqdxmI+bnF7ApD/D7ZWWys0iYlCvY2QkrgDKoynZvru+mx37Ugbjyysgyn744x2lm")]),                                player: PlayerData(autoPlay: true)))
        
        videos.append(VideoData(title: "Liongate VOD FairPlay DRM",                                freeFormMedia: FreeFormMedia(id: "2119347",                                                             contentUrl: "http://li-jit-cdn-lb.lionsgateplay.com/JIT/SPA/lionsgate/DEADINAWEEKORYOURMONEYBACKY2018M/893e5b6db71f689d2d6a99850164c4b7/DEADINAWEEKORYOURMONEYBACKY2018M_fairplay.ism/DEADINAWEEKORYOURMONEYBACKY2018M_fairplay.m3u8?PID=_1owYqYOZhp2",                                                             drmData:[FairPlayDRMParams(licenseUri: "https://fairplay-license.drm.technology/license",                                                                                        base64EncodedCertificate: "MIIFAzCCA+ugAwIBAgIIUrk2M/NY/1wwDQYJKoZIhvcNAQEFBQAwfzELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MTMwMQYDVQQDDCpBcHBsZSBLZXkgU2VydmljZXMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTYwMjA4MDk1MzMyWhcNMTgwMjA4MDk1MzMyWjCBgjELMAkGA1UEBhMCVVMxJDAiBgNVBAoMG1BsYXljbyBFbnRlcnRhaW5tZW50IEZaIExMQzETMBEGA1UECwwKWjhSUlFSMlRLRTE4MDYGA1UEAwwvRmFpclBsYXkgU3RyZWFtaW5nOiBQbGF5Y28gRW50ZXJ0YWlubWVudCBGWiBMTEMwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMKdfopm7rgWT1+xWoESPQZehy8Nh5OYDTWpmiaP1pLO2+o8kVz6lAznF+4xFnX7qp9P62V+YDwd968zNTJBnkQVVQux425EYYcIKGOKP+mA8Ad6Z2l8CDLXogPZj2hFWUFjMSDqfDhBvyufxZfK9piY5dBBpmch75vzxCbvINDzAgMBAAGjggIBMIIB/TAdBgNVHQ4EFgQUNjsmra7ruyMganRzweM6cEkSQdkwDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBRj5EdUy4VxWUYsg6zMRDFkZwMsvjCB4gYDVR0gBIHaMIHXMIHUBgkqhkiG92NkBQEwgcYwgcMGCCsGAQUFBwICMIG2DIGzUmVsaWFuY2Ugb24gdGhpcyBjZXJ0aWZpY2F0ZSBieSBhbnkgcGFydHkgYXNzdW1lcyBhY2NlcHRhbmNlIG9mIHRoZSB0aGVuIGFwcGxpY2FibGUgc3RhbmRhcmQgdGVybXMgYW5kIGNvbmRpdGlvbnMgb2YgdXNlLCBjZXJ0aWZpY2F0ZSBwb2xpY3kgYW5kIGNlcnRpZmljYXRpb24gcHJhY3RpY2Ugc3RhdGVtZW50cy4wNQYDVR0fBC4wLDAqoCigJoYkaHR0cDovL2NybC5hcHBsZS5jb20va2V5c2VydmljZXMuY3JsMA4GA1UdDwEB/wQEAwIFIDBHBgsqhkiG92NkBg0BAwEB/wQ1ATR3aG92cTB4bjFzODM3eHM4Y2h1MjlzcGxibWExaHhtZWZpZG1sdzRkeGdlMnlrcDY1c2wwOAYLKoZIhvdjZAYNAQQBAf8EJgFjYzMybTRuZ3NwOWN2YTZoY2dtZ2xzZWJxczV4NXNpMnpkMjBiMA0GCSqGSIb3DQEBBQUAA4IBAQAJKBYS7fo3Fxiel34AyNiYEs25mtHByw8gxZIc0kfzTAggTbnlOAnTsy7RPLN3+9VSYkNCIgm/kgHPQMtxY0pKQg/OrioSNDzYHZ+UZerdutx4SA5dAAbJlwD3sfRv+Y7rFHtR+NRF11k9vkVw23YHjatICweljhlja2bxqCKPRpwBRjWnAmxwjYpkghomfUMFK8VenyBsw55fzbbVhtOBRnjX4rO71vXKng7eNuZ4Ffs5hVgxpd8Ce0sOGO5YmC9HzCJci+PM7v6iZItFkOU2LxIa+OrD1W8oOkIY1wEU986gxtkZs2L6VcWIwhjiDLuXX/WG7Dny+EHxV64r9Ao3")]),                                player: PlayerData(autoPlay: true)))
        
        videos.append(VideoData(title: "DAI",
                                freeFormMedia: FreeFormMedia(id: "sintel",
                                                             contentUrl: "https://dai.google.com/linear/hls/pa/event/c-rArva4ShKVIAkNfy6HUQ/stream/f3c436fc-ce72-4add-92d4-56f86d833649:BRU/master.m3u8"),
                                playlistCountdownOptions: customPlaylistCountdownOptions))
        
        videos.append(VideoData(title: "Audio",
                                freeFormMedia: FreeFormMedia(id: "sintel",
                                                             contentUrl: "https://db2.indexcom.com/bucket/ram/00/05/05.m3u8"),
                                player: PlayerData(autoPlay: false, preload: false)))
        
        videos.append(VideoData(title: "Test",
                                freeFormMedia: FreeFormMedia(id: "sintel",
                                                             contentUrl: "https://vspp.beeline.tv/bpk-tv/Service02/default/index.m3u8?platformID=1040_1&terminalID=825EB392-84CB-4C&purchaseID=20514286"),
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
