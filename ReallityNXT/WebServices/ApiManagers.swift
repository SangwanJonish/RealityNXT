//
//  ApiManager.swift
//  MyGigsters
//
//  Created by Jonish on 15/06/21.
//

import Alamofire
import UIKit
import ObjectMapper

class ApiManagers: BaseApiManager {
    
    class func getHeader()->HTTPHeaders {
        var headers = HTTPHeaders()
        headers = ["Authorization": "Bearer \(/Utility.shared.user?.jwtToken)"]
        print(headers)
        return headers
    }
    
    class func delete<T: Mappable>(_ url: String,
                                   params: [String: Any] = [:],
                                   headers: HTTPHeaders? = nil,
                                   success: @escaping (T?) -> (), failure: @escaping failure) {
        let dataRequest = self.getDataRequest(url,
                                              params: params,
                                              method: .delete,
                                              headers: headers)
        self.executeDataRequest(dataRequest, with: success,failure: failure)
        //   self.executeDataRequest(dataRequest, with: completion)
    }
    
    class func put<T: Mappable>(_ url:String,
                                params:[String:Any]? = [:],
                                header: HTTPHeaders? = nil,
                                success: @escaping (T?) -> (), failure: @escaping failure){
        
        if NetworkReachabilityManager()?.isReachable == false {
            //            completion(getNoInternetError())
            success(getNoInternetError() as? T)
            return
        }
        let dataRequest = self.getDataRequest(url, params: params ?? [:], method: .put, headers: header)
        //(url, params: params, method: .put, encoding: URLEncoding.default, headers: header)
        self.executeDataRequest(dataRequest, with: success,failure: failure)
    }
    
    class func post<T: Mappable>(_ url: String,
                                 params: [String: Any]? = [:],
                                 headers: HTTPHeaders? = nil,
                                 success: @escaping (T?) -> (), failure: @escaping failure) {
        var urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let dataRequest = self.getDataRequest(/urlString,
                                              params: params, headers: headers )
        self.executeDataRequest(dataRequest, with: success,failure: failure)
    }
    
    class func patch<T: Mappable>(_ url: String,
                                  params: [String: Any] = [:],
                                  headers: HTTPHeaders? = nil,
                                  success: @escaping (T?) -> (), failure: @escaping failure) {
        let dataRequest = self.getDataRequest(url,
                                              params: params,
                                              method: .patch)
        self.executeDataRequest(dataRequest, with: success,failure: failure)
    }
    
    
    class func get<T: Mappable>(_ url: String,
                                params: [String: Any]? = nil,
                                headers: HTTPHeaders? = nil,
                                success: @escaping (T?) -> (), failure: @escaping failure) {
        let dataRequest = self.getDataRequest(url,
                                              params: params,
                                              method: .get,
                                              encoding: URLEncoding.default,
                                              headers: headers)
        self.executeDataRequest(dataRequest, with: success,failure: failure)
    }
    
    private class func executeDataRequest<T: Mappable>(_ dataRequest: DataRequest,
                                                       with success: @escaping (T?) -> (), failure: @escaping failure) {
        if NetworkReachabilityManager()?.isReachable == false {
            // completion(getNoInternetError())
            success(getNoInternetError() as! T)
            return
        }
        dataRequest.responseObject { (response: AFDataResponse<T>) in
            switch response.result {
            case let .success(data):
                print(data.toJSON())
                success(data)
            case let .failure(error):
                failure(error)
            }
            
        }
    }
    
}

class BaseApiManager: NSObject {
    
    static let sessionManager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        return Session(configuration: configuration)
    }()
    
    class func getDataRequest(_ url: String,
                              params: [String: Any]? = nil,
                              method: HTTPMethod = .post,
                              encoding: ParameterEncoding = JSONEncoding.default,
                              headers: HTTPHeaders? = nil) -> DataRequest {
        
        print(BaseURL + url)
        let dataRequest = sessionManager.request(BaseURL + url,
                                            method: method,
                                            parameters: params,
                                            encoding: encoding,
                                            headers: headers)
//        let dataRequest = AF.request(BaseURL + url,
//                                     method: method,
//                                     parameters: params,
//                                     encoding: encoding,
//                                     headers: headers)
        
        return dataRequest
    }
}

extension BaseApiManager {
    static func getNoInternetError() -> String {
        return "No Internet Connection Available"
    }

    static func getUnknownError(with errorMessage: String) -> String {
        return "Unknown Error"
    }
}


class Connectivity {
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}
