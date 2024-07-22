//
//  HomeVC.swift
//  JanSahayak
//
//  Created by Jonish Sangwan on 29/12/20.
//  Copyright © 2020 Jonish Sangwan. All rights reserved.
//

import UIKit
import Alamofire

//class ApiManager: NSObject {
//    static let  shared:ApiManager = ApiManager()
//    func requestApi(url:String, parameters:Dictionary<String, Any>?,headers:HTTPHeaders?,method:HTTPMethod, completion: @escaping (_ result:Dictionary<String, Any>?, _ message:String) -> Void){
//        if IS_LOG_ENABLED{
//            print("url = \(url)")
//            print("parameters = \(parameters)")
//        }
//
//       /* var headers: HTTPHeaders!
//
//        if let token  = UserDefaults.standard.string(forKey: KEYS.token)  {
//            headers = [
//                "Authorization": "Bearer \(token)"
//            ]
//        }*/
//
//
//        Alamofire.request(url, method: method, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
//            if IS_LOG_ENABLED {
//                print("response = \(response)")
//            }
//
//            if response.error != nil {
//               completion(nil,WENT_WRONG)
//                // self.LoadingStop()
//                return
//            }
//
//            response.result.ifSuccess {
//                /// Success
//
//                if let dict: Dictionary<String, Any> = response.result.value as? Dictionary<String, Any> {
//                    //print(dict)
//
//                    let status = (dict["code"]) as? Int
//                    let output = (dict["output"]) as? String
//                    let statusMsg = (dict["status"]) as? String
//                    let stat = (dict["success"]) as? Bool
//                    if stat == true || status == 200 || status == 201 || status == 204 || response.result.isSuccess == true || output == "success" || statusMsg == "Successfull"{
//                        completion(dict, dict["message"] as? String ?? "")
//                        return
//
//                    }else{
//                        completion(nil, dict["message"] as? String ?? dict["reason"] as? String ?? "")
//                    }
//                }
//            }
//            response.result.ifFailure {
//                if let error = response.result.error {
//                    print(error)
//                   completion(nil,WENT_WRONG)
//
//                    return
//                }
//            }
//
//        })
//    }
//
//    func addVideo(url:String, parameters:Dictionary<String, String>, videoUrl:URL, videoName:String, thumb:UIImage, thumbName:String, completion: @escaping (_ result:Dictionary<String, Any>?, _ message:String) -> Void, uploadProgress:@escaping (_ progress:Double)->Void){
//
//        Alamofire.upload (
//            multipartFormData: { multipartFormData in
//                for (key, value) in parameters {
//                    if IS_LOG_ENABLED {
//                        print("\(key) = \(value)")
//                    }
//
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//                }
//                multipartFormData.append(videoUrl, withName: videoName , fileName: "video.mp4", mimeType: "video/mp4")
//                multipartFormData.append(thumb.jpegData(compressionQuality: 0.4) ?? Data(), withName: thumbName, fileName: "image.png", mimeType:  "image/png")
//
//        },
//            to: url,
//            headers: [:],
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload,_, _):
//                    upload.uploadProgress(closure: { (progress) in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                        uploadProgress(progress.fractionCompleted)
//                    })
//
//                    upload.responseJSON { (response) in
//
//
//                        if response.error != nil {
//                            completion(nil,APP_MESSAGES.technicalIssueMessage)
//                            // self.LoadingStop()
//                            return
//                        }
//
//                        response.result.ifSuccess {
//                            /// Success
//
//                            if let dict: Dictionary<String, Any> = response.result.value as? Dictionary<String, Any> {
//                                print(dict)
//
//                                let status = (dict["status"]) as? Int
//                                if status == 0 {
//                                    completion(dict, (dict["message"] as? String) ?? "")
//                                    return
//
//                                }else{
//                                    completion(nil,APP_MESSAGES.technicalIssueMessage)
//                                }
//                            }
//                        }
//                        response.result.ifFailure {
//                            /// Failed
//                            if let error = response.result.error {
//                                print(error)
//                                completion(nil,APP_MESSAGES.technicalIssueMessage)
//
//                                return
//                            }
//                        }
//
//                    }
//                case .failure(_):
//                    completion(nil,APP_MESSAGES.technicalIssueMessage)
//                }
//        }
//        )
//    }
//
//    func uploadFile(url:String, parameters:Dictionary<String, String>,data:Data, fileName:String, completion: @escaping (_ result:Dictionary<String, Any>?, _ message:String) -> Void, uploadProgress:@escaping (_ progress:Double)->Void) {
//
//        Alamofire.upload (
//            multipartFormData: { multipartFormData in
//                for (key, value) in parameters {
//                    if IS_LOG_ENABLED {
//                        print("\(key) = \(value)")
//                    }
//
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//                }
//                multipartFormData.append(data, withName: fileName, fileName: "test.pdf", mimeType:  "application/pdf")
//
//        },
//            to: url,
//            headers: [:],
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload,_, _):
//                    upload.uploadProgress(closure: { (progress) in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                        uploadProgress(progress.fractionCompleted)
//                    })
//                    upload.responseJSON { (response) in
//
//
//                        if response.error != nil {
//                            completion(nil,APP_MESSAGES.technicalIssueMessage)
//                            // self.LoadingStop()
//                            return
//                        }
//
//                        response.result.ifSuccess {
//                            /// Success
//
//                            if let dict: Dictionary<String, Any> = response.result.value as? Dictionary<String, Any> {
//                                print(dict)
//
//                                let status = (dict["status"]) as? Int
//                                if status == 0 {
//                                    completion(dict, (dict["message"] as? String) ?? "")
//                                    return
//
//                                }else{
//                                    completion(nil,APP_MESSAGES.technicalIssueMessage)
//                                }
//                            }
//                        }
//                        response.result.ifFailure {
//                            /// Failed
//                            if let error = response.result.error {
//                                print(error)
//                                completion(nil,APP_MESSAGES.technicalIssueMessage)
//
//                                return
//                            }
//                        }
//
//                    }
//                case .failure(_):
//                    completion(nil,APP_MESSAGES.technicalIssueMessage)
//                }
//        }
//        )
//    }
//
//
//    func uploadData(url:String, parameters:Dictionary<String, Any>,header:HTTPHeaders, completion: @escaping (_ result:Dictionary<String, Any>?, _ message:String) -> Void, uploadProgress:@escaping (_ progress:Double)->Void) {
//
//        Alamofire.upload (
//            multipartFormData: { multipartFormData in
//                for (key, value) in parameters {
//                    if IS_LOG_ENABLED {
//                        print("\(key) = \(value)")
//                    }
//
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//                }
//
//        },
//            to: url,
//            headers: header,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload,_, _):
//                    upload.uploadProgress(closure: { (progress) in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                        uploadProgress(progress.fractionCompleted)
//                    })
//                    upload.responseJSON { (response) in
//
//
//                        if response.error != nil {
//                            completion(nil,APP_MESSAGES.technicalIssueMessage)
//                            // self.LoadingStop()
//                            return
//                        }
//
//                        response.result.ifSuccess {
//                            /// Success
//
//                            if let dict: Dictionary<String, Any> = response.result.value as? Dictionary<String, Any> {
//                                print(dict)
//
//                                let status = (dict["status"]) as? Int
//                                if status == 0 {
//                                    completion(dict, (dict["message"] as? String) ?? "")
//                                    return
//
//                                }else{
//                                    completion(nil,APP_MESSAGES.technicalIssueMessage)
//                                }
//                            }
//                        }
//                        response.result.ifFailure {
//                            /// Failed
//                            if let error = response.result.error {
//                                print(error)
//                                completion(nil,APP_MESSAGES.technicalIssueMessage)
//
//                                return
//                            }
//                        }
//
//                    }
//                case .failure(_):
//                    completion(nil,APP_MESSAGES.technicalIssueMessage)
//                }
//        }
//        )
//    }
//
//    func uploadImage(url:String, parameters:Dictionary<String, String>,image:UIImage, imageName:String, completion: @escaping (_ result:Dictionary<String, Any>?, _ message:String) -> Void, uploadProgress:@escaping (_ progress:Double)->Void){
//
//        Alamofire.upload (
//            multipartFormData: { multipartFormData in
//                for (key, value) in parameters {
//                    if IS_LOG_ENABLED {
//                        print("\(key) = \(value)")
//                    }
//
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//                }
//                //multipartFormData.append(image.jpegData(compressionQuality: 0.4) ?? Data(), withName: imageName, fileName: "image.png", mimeType:  "image/png")
//
//        },
//            to: url,
//            headers: [:],
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload,_, _):
//                    upload.uploadProgress(closure: { (progress) in
//                        print("Upload Progress: \(progress.fractionCompleted)")
//                        uploadProgress(progress.fractionCompleted)
//                    })
//                    upload.responseJSON { (response) in
//
//
//                        if response.error != nil {
//                            completion(nil,APP_MESSAGES.technicalIssueMessage)
//                            // self.LoadingStop()
//                            return
//                        }
//
//                        response.result.ifSuccess {
//                            /// Success
//                            upload.uploadProgress { progress in
//
//                                print(progress.fractionCompleted)
//                            }
//                            if let dict: Dictionary<String, Any> = response.result.value as? Dictionary<String, Any> {
//                                print(dict)
//
//                                let status = (dict["staus"]) as? Int
//                                if status == 200 {
//                                    completion(dict, (dict["message"] as? String) ?? "")
//                                    return
//
//                                }else{
//                                     completion(nil,APP_MESSAGES.technicalIssueMessage)
//                                }
//                            }
//                        }
//                        response.result.ifFailure {
//                            /// Failed
//                            if let error = response.result.error {
//                                print(error)
//                                completion(nil,APP_MESSAGES.technicalIssueMessage)
//
//                                return
//                            }
//                        }
//
//                    }
//                case .failure(_):
//                    completion(nil,APP_MESSAGES.technicalIssueMessage)
//                }
//        }
//        )
//    }
//
//    func downloadFile(url:String, header:Dictionary<String , String>){
//
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileURL = documentsURL.appendingPathComponent("in.gov.transport-DRVLC-HP8920180000850")
//
//            // Check if file exists, if yes, append a timestamp to the file name
//            if FileManager.default.fileExists(atPath: fileURL.path) {
//                let timestamp = Date().timeIntervalSince1970
//                let fileName = "in.gov.transport-DRVLC-HP8920180000850_\(timestamp)"
//                let destinationURL = documentsURL.appendingPathComponent(fileName)
//                return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
//            } else {
//                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//            }
//        }
//
//        Alamofire.download(
//            url,
//            method: .get,
//            parameters: nil,
//            encoding: JSONEncoding.default,
//            headers: header,
//            to: destination).downloadProgress(closure: { (progress) in
//                print("Upload Progress: \(progress.fractionCompleted)")
//            }).response(completionHandler: { (DefaultDownloadResponse) in
//                if let error = DefaultDownloadResponse.error {
//                       print("Download failed with error: \(error)")
//                       // Handle the error as needed
//                   } else {
//                       // The download was successful
//                       if let statusCode = DefaultDownloadResponse.response?.statusCode, statusCode == 200 {
//                           print("Download successful!")
//                           // You can also handle the downloaded file here if needed
//                       }
//                   }
//            })
//    }
//}
