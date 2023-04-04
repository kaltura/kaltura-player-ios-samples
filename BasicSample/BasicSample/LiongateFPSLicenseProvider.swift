//
//  LiongateFPSLicenseProvider.swift
//  BasicSample
//
//  Created by Sergey Chausov on 26.01.2023.
//  Copyright © 2023 Kaltura Inc. All rights reserved.
//

import Foundation
import PlayKit
import AVFoundation

class LiongateFPSLicenseProvider: FairPlayLicenseProvider {
    
    struct TokenResponse: Codable {
        let token: String?
    }
    
    func getContentId(request: URLRequest) -> String? {
        // skd://fairplay-license.vudrm.tech/v2/license/DEADINAWEEKORYOURMONEYBACKY2018M
        // You may add another parsing to get DEADINAWEEKORYOURMONEYBACKY2018M
        return request.url?.lastPathComponent
    }
    
    func getLicense(spc: Data,
                    contentId: String,
                    requestParams: PlayKit.PKRequestParams,
                    callback: @escaping (Data?, TimeInterval, Error?) -> Void) {
        
        var myToken: String?
        var license: Data?
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInitiated
        
        let tokenOperation = BlockOperation {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            print("Operation 1")
            let userId = "TESTUSER"
            let pid = "mmlVU9gZHZTc"
            let apiKey = "A3Iga4BSjG3JOJ0LJY18G57LfbuqDqYq7HnRMo7o"
            
            guard let url = URL(string: "https://5h5xkjhaje.execute-api.ap-south-1.amazonaws.com/dev/v1/proxy/dialog/lg?scheme=fairplay&userid=\(userId)&pid\(pid)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data: Data?,
                                                                        response: URLResponse?,
                                                                        error: Error?) -> Void in
                print("Operation GET TOKEN")
                if let error = error {
                    print("Token request Error: " + error.localizedDescription)
                    dispatchGroup.leave()
                    return
                }
                
                do {
                    guard let data = data, data.count > 0 else {
                        print("Token request Error")
                        dispatchGroup.leave()
                        return
                    }
                    
                    let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                    
                    if let token = tokenResponse.token {
                        myToken = token
                    } else {
                        print(error)
                    }
                    
                    dispatchGroup.leave()
                } catch let error {
                    print(error)
                    dispatchGroup.leave()
                }
            }
            dataTask.resume()
            dispatchGroup.wait()
        }
        
        let licenseOperation = BlockOperation {
            let group = DispatchGroup()
            group.enter()
            print("Operation 2")
            var request = URLRequest(url: requestParams.url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            // spc provided by PlayKit.
            let body = ["token": myToken,
                        "contentId": contentId,
                        "payload": spc.base64EncodedString()
            ]
            
            do {
                let json = try JSONEncoder().encode(body)
                request.httpBody = json
            } catch {
                group.leave()
                /// TODO: Remove
                print("Error")
            }
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data: Data?,
                                                                        response: URLResponse?,
                                                                        error: Error?) -> Void in
                print("Operation GET LICENSE")
                if let error = error {
                    callback(nil, 0, FPSError.serverError(error, requestParams.url))
                    group.leave()
                    return
                }
                
                guard let data = data, data.count > 0 else {
                    callback(nil, 0, FPSError.malformedServerResponse)
                    group.leave()
                    return
                }
                
                license = data
                group.leave()
            }
            dataTask.resume()
            group.wait()
        }
        
        let processLicense = BlockOperation {
            print("Operation 3")
            print("Operation SET LICENSE")
            callback(license,
                     86400, // License expiration Time Interval
                     nil)
            return
        }
        
        queue.addOperation(tokenOperation)
        queue.addOperation(licenseOperation)
        
        licenseOperation.addDependency(tokenOperation)
        processLicense.addDependency(licenseOperation)
        queue.addOperation(processLicense)
        
        queue.waitUntilAllOperationsAreFinished()
    }
    
}
