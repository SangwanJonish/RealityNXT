//
//  Login.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 07/06/24.
//

import UIKit
import ObjectMapper

class Login: Codable {

}

class GenericResponseModel: Mappable {
    
    var status: Int?
    var message: String?
    var data: String?
    var propertyId: Int?
    
    public init() {
        
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
        propertyId <- map["data"]
    }
    
}

class SocialEntryModel: Mappable {
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        
    }
    
    var name: String?
    var email: String?
    var phone_number: String?
    var type: String?
    var oauth_id: String?
    var oauth_token: String?
    
    init() {
    }
}

class CountriesResponse: Mappable {
    
    var status: Int?
    var message: String?
    var countries: [Countries]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        countries <- map["data"]
        status <- map["status"]
        message <- map["message"]
    }
}

class Countries: Mappable {
    
    var countryName: String?
    var code: String?
    var url: String?
    
    public init() {
        
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        countryName <- map["countryName"]
        code <- map["code"]
        url <- map["url"]
    }
    
}

class VerifyResponseModel: Mappable {
    
    var status: Int?
    var message: String?
    var data: [User]?
    
    public init() {
        
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
    
}


class User: Mappable,Codable {
    
    var id: Int?
    var name: String?
    var mobile: String?
    var mobileVerified: Int?
    var email: String?
    var emailVerified: Int?
    var roleId: Int?
    var deviceType: String?
    var deviceId: String?
    var fbToken: String?
    var jwtToken: String?
    var active: Int?
    
    public init() {
        
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        mobile <- map["mobile"]
        mobileVerified <- map["mobileVerified"]
        email <- map["email"]
        emailVerified <- map["emailVerified"]
        roleId <- map["roleId"]
        deviceType <- map["deviceType"]
        deviceId <- map["deviceId"]
        fbToken <- map["fbToken"]
        jwtToken <- map["jwtToken"]
        active <- map["active"]
    }
    
}
