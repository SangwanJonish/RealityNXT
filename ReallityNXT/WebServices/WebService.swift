//
//  WebService.swift
//  MySafetyBot
//
//  Created by Megamind Innovations  on 06/07/20.
//  Copyright © 2020 Megamind Innovations . All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

typealias failure = (_ error: Error?) -> Void
typealias uploadProgress = (_ process: Double?) -> Void

final class WebService {
    
    private static var sharedInstance: WebService?
    class var shared : WebService {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = WebService()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    class func destroySharedManager() {
        sharedInstance = nil
    }
    
    //let appSettings = AppSettings.shared

    
//    func registerUser(_ data: EntryModel, success: @escaping (Authentication?) -> (), failure: @escaping failure) {
//        let url: String = BaseURL + API.checkUserExit
//        var parameters = data.toJSON()
//        parameters["plan"] = Constants.SubscriptionPlan.free
//        if let invitedBy = appSettings.getInvitedBy() {
//            parameters["refered_by"] = invitedBy
//        } else {
//            parameters["refered_by"] = ""
//        }
//
//        ApiManagers.post(url, params: parameters, headers: ApiManagers.getHeader()) { (authorization:Authentication?) in
//            if let statusCode = authorization?.status{
//                if statusCode == "200" {
//                    success(authorization)
//                }
//                else if statusCode == "402"{
//                    self.appSettings.saveInvitedBy(nil)
//                    self.appSettings.saveSignupDate(Date())
//                    if let message = authorization?.message {
//                        failure(message + "402")
//                    }
//                }
//                else{
//                    if let message = authorization?.message {
//                        failure(message)
//                    } else {
//                        failure("Some error occured.")
//                    }
//                }
//            }
//        } failure: { (error) in
//            failure(error)
//        }
//    }
    
    func loginApi(data:[String: Any],success: @escaping (GenericResponseModel?) -> (), failure: @escaping failure) {
        let number = data["phone"] as? String
        let url: String =  API.loginApi + /number
        
        ApiManagers.get(url, params: nil, headers: ApiManagers.getHeader()) { (response:GenericResponseModel?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response)
                } else {
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            } else {
                failure(APP_MESSAGES.errorMessage)
            }
        } failure: { (error) in
            failure(error)
        }
    }
    
    func getCountries(success: @escaping ([Countries]?) -> (), failure: @escaping failure) {
        let url: String = API.countryMaster
        
        ApiManagers.get(url, params: nil, headers: ApiManagers.getHeader()) { (response:CountriesResponse?) in
            print(response?.toJSON())
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response?.countries)
                } else {
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            } else {
                failure(APP_MESSAGES.errorMessage)
            }
        } failure: { (error) in
            failure(error)
        }
    }
    
    func verifyOtp(data:[String: Any],success: @escaping (VerifyResponseModel?) -> (), failure: @escaping failure) {
        let otp = data["otp"] as? String
        let mobile = data["mobile"] as? String
        let deviceType = data["deviceType"] as? String
        let deviceId = data["deviceId"] as? String
        let fbToken = data["fbToken"] as? String
        let url: String = API.verifyUser + /otp + "?Mobile_Email=\(mobile ?? "")&DeviceType=\(/deviceType)&DeviceId=\(/deviceId)&FbToken=\(/fbToken)"
    
        ApiManagers.post(url, params: nil, headers: ApiManagers.getHeader()) { (response:VerifyResponseModel?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response)
                }else if statusCode == 400 {
                    success(response)
                }
                else{
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            }
            else{
                failure(APP_MESSAGES.errorMessage)
            }
            
        } failure: { (error) in
            failure(error)
        }
    }
    
    func apiForBasicDetailUI(success: @escaping (PropertyInfo?) -> (), failure: @escaping failure) {
    
        let url: String = API.getPropertyBasicDetail
    
        ApiManagers.post(url, params: nil, headers: ApiManagers.getHeader()) { (response:Property?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response?.data)
                }
                else{
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            }
            else{
                failure(APP_MESSAGES.errorMessage)
            }
            
        } failure: { (error) in
            failure(error)
        }
    }
    
    func apiForPhotosAndPriceUI(success: @escaping (OwnershipArrays?) -> (), failure: @escaping failure) {
    
        let url: String = API.getPropertyOwnership + "?SubCategoryId=1"
    
        ApiManagers.post(url, params: nil, headers: ApiManagers.getHeader()) { (response:Ownership?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response?.data)
                }
                else{
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            }
            else{
                failure(APP_MESSAGES.errorMessage)
            }
            
        } failure: { (error) in
            failure(error)
        }
    }
    
    func checkUserAlreadyExit(data:[String: Any],success: @escaping (VerifyResponseModel?) -> (), failure: @escaping failure) {
        let mobile = data["mobile"] as? String

        let url: String = API.checkUserExit + "\(mobile ?? "")"
    
        ApiManagers.post(url, params: nil, headers: ApiManagers.getHeader()) { (response:VerifyResponseModel?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response)
                }else if statusCode == 400 {
                    success(response)
                }
                else{
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            }
            else{
                failure(APP_MESSAGES.errorMessage)
            }
            
        } failure: { (error) in
            failure(error)
        }
    }
    
    func postUserBasicDetail(data:[String: Any],success: @escaping (String?) -> (), failure: @escaping failure) {
        
        let id = data["id"] as? Int
        let category = data["category"] as? Int
        let type = data["type"] as? Int
        let kind = data["kind"] as? Int
        let userId = data["userId"] as? Int
        
        let url: String = API.postUserBasicDetail + "PorpertyId=\(/id)&Category=\(/category)&Type=\(/type)&Kind=\(/kind)&UserId=\(/userId)&User_type=iOS"
    
        ApiManagers.post(url, params: nil, headers: ApiManagers.getHeader()) { (response:GenericResponseModel?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response?.message)
                }
                else{
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            }
            else{
                failure(APP_MESSAGES.errorMessage)
            }
            
        } failure: { (error) in
            failure(error)
        }
    }
    
    func guestUserRegistration(data:[String: Any],success: @escaping (VerifyResponseModel?) -> (), failure: @escaping failure) {
        let deviceType = data["deviceType"] as? String
        let deviceId = data["deviceId"] as? String
        let fbToken = data["fbToken"] as? String
        let roleId = data["roleId"] as? String
        let url: String = API.guestUser + "DeviceType=\(/deviceType)&DeviceId=\(/deviceId)&FbToken=\(/fbToken)&RoleId=\(/roleId)"
    
        ApiManagers.post(url, params: nil, headers: ApiManagers.getHeader()) { (response:VerifyResponseModel?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response)
                }
                else if statusCode == 400{
                    success(response)
                }
                else{
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            }
            else{
                failure(APP_MESSAGES.errorMessage)
            }
            
        } failure: { (error) in
            failure(error)
        }
    }
    
    func socialRegistration(data:[String: Any],success: @escaping (User?) -> (), failure: @escaping failure) {
        let deviceType = data["deviceType"] as? String
        let deviceId = data["deviceId"] as? String
        let fbToken = data["fbToken"] as? String
        let name = data["name"] as? String
        let id = data["id"] as? Int
        let email = data["email"] as? String
        let mobile = data["mobile"] as? String
        let roleId = data["roleId"] as? String
        let url: String = API.socialLogin + "Id=\(/id)&Name=\(/name)&Email=\(/email)&Mobile=\(/mobile)&DeviceType=\(/deviceType)&DeviceId=\(/deviceId)&FbToken=\(/fbToken)&RoleId=\(/roleId)"
    
        ApiManagers.post(url, params: nil, headers: ApiManagers.getHeader()) { (response:VerifyResponseModel?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response?.data?.first)
                }
                else if statusCode == 402{
                    if let message = response?.message {
                        failure(message + "402")
                    }
                }
                else{
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            }
            else{
                failure(APP_MESSAGES.errorMessage)
            }
            
        } failure: { (error) in
            failure(error)
        }
    }
    
    func updateUser(data:[String: Any],success: @escaping (User?) -> (), failure: @escaping failure) {
        let name = data["name"] as? String
        let id = data["id"] as? Int
        let email = data["email"] as? String
        let mobile = data["mobile"] as? String
        let roleId = data["roleId"] as? String
        let url: String = API.registerUser + "Id=\(/id)&Name=\(/name)&Email=\(/email)&Mobile=\(/mobile)&RoleId=\(/roleId)"

        ApiManagers.post(url, params: nil, headers: ApiManagers.getHeader()) { (response:VerifyResponseModel?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response?.data?.first)
                }
                else if statusCode == 402{
                    if let message = response?.message {
                        failure(message + "402")
                    }
                }
                else{
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            }
            else{
                failure(APP_MESSAGES.errorMessage)
            }
            
        } failure: { (error) in
            failure(error)
        }
    }
    
    func deletePropertyImages(_ id: Int,success: @escaping (User?) -> (), failure: @escaping failure) {

        let url: String = API.deletePropertyImage + "\(id)"

        ApiManagers.post(url, params: nil, headers: ApiManagers.getHeader()) { (response:VerifyResponseModel?) in
            if let statusCode = response?.status{
                if statusCode == 200 {
                    success(response?.data?.first)
                }
                else if statusCode == 402{
                    if let message = response?.message {
                        failure(message + "402")
                    }
                }
                else{
                    if let message = response?.message {
                        failure(message)
                    } else {
                        failure("Some error occured.")
                    }
                }
            }
            else{
                failure(APP_MESSAGES.errorMessage)
            }
            
        } failure: { (error) in
            failure(error)
        }
    }
    
    func postPropertyImages(_ data: PropertyImages, success: @escaping (PostPropertyResponseModel?) -> (), failure: @escaping failure,uploadProgress: @escaping uploadProgress) {
        let url: String = BaseURL + API.postPropertyImage
        let parameters = data.toJSON()
        let headers: HTTPHeaders = ApiManagers.getHeader()
       //print(parameters)
        print(headers)
        AF.upload(multipartFormData: { (multipartFormData) in
            // import image to request
            for (key, value) in parameters {
                if key == "files" {
                    if let temp = value as? String {
                        if let dataDecoded : Data = Data(base64Encoded: temp, options: .ignoreUnknownCharacters){
                            let decodedimage = UIImage(data: dataDecoded)
                            multipartFormData.append((decodedimage!.jpegData(compressionQuality: 0.1)!), withName: key, fileName: "file.jpeg", mimeType: "image/jpeg")
                        }
                    }
                }else if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
            }
        }, to: url, method: .post, headers: headers)
        .response { response in
            if let data = response.data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let genericResponse = Mapper<PostPropertyResponseModel>().map(JSONObject: json)
                    print(genericResponse?.toJSON())
                    if let statusCode = genericResponse?.status,
                       statusCode == 200 {
                        switch response.result {
                        case .success( _):
                            success(genericResponse)
                        case .failure(let error):
                            failure(error)
                        }
                    } else {
                        if let message = genericResponse?.message {
                            failure(message)
                        } else {
                            failure("Some error occured.")
                        }
                    }
                }
                catch let err{
                    failure(err)
                } 
            } else {
                failure("Some error occured.")
            }
        }
        .uploadProgress { progress in
            print("Upload progress: \(progress.fractionCompleted)")
            uploadProgress(progress.fractionCompleted)
            // Update UI to show upload progress
        }
    }
}





