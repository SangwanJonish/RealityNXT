//
//  HomeVC.swift
//  JanSahayak
//
//  Created by Jonish Sangwan on 29/12/20.
//  Copyright © 2020 Jonish Sangwan. All rights reserved.
//

import Foundation
import UIKit

let BaseURL = "http://13.60.35.111:81/api/"

let googleApiKey = "AIzaSyCP2pEIkDd8QwvnxmoWxxa72h3Aojk-YKg"

// MARK:- Developer's Helpers
let IS_LOG_ENABLED = true
let IS_DEV_MODE = false

let BLUE_COLOR = UIColor(red:0.391, green:0.304, blue:0.598, alpha:1.000)
let GREEN_COLOR = UIColor(red:0.008, green:0.698, blue:0.565, alpha:1.000)
let GRAY_COLOR = UIColor(displayP3Red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
let purple_COLOR = UIColor(red:0.391, green:0.304, blue:0.598, alpha:1.000)

let gradiantFirstColor = UIColor(displayP3Red: 239.0/255.0, green: 124.0/255.0, blue: 0.0/255.0, alpha: 1.0)
let gradiantSecondColor = UIColor(displayP3Red: 77.0/255.0, green: 77.0/255.0, blue: 97.0/255.0, alpha: 1.0)

let lightColor = UIColor(named: "lightOrange")
let orangeColor = UIColor(named: "OrangeColor")
let yellowColor = UIColor(named: "ThemeColor5")
let GreenColor = UIColor(named: "ThemeColor6")

// MARK:- Variables
let DEVICE_WIDTH = UIScreen.main.bounds.width
let DEVICE_HEIGHT = UIScreen.main.bounds.height
let IS_IPHONE_X = (max(DEVICE_WIDTH, DEVICE_HEIGHT) == 812.0)
let IS_IPHONE_4or5orSE = (min(DEVICE_WIDTH, DEVICE_HEIGHT) == 320.0)
let IS_IPHONE_6or7or8 = (min(DEVICE_WIDTH, DEVICE_HEIGHT) == 375.0)
let IS_IPHONE_6Por7Por8P = (min(DEVICE_WIDTH, DEVICE_HEIGHT) == 414.0)

struct API {
    static let loginApi = "Login/"
    static let countryMaster = "CountrycodeMaster"
    static let verifyUser = "VerifyUser/"
    static let registerUser = "UpdateInformation?"
    static let guestUser = "GuestUserRegistration?"
    static let socialLogin = "UserRegistrationbySocialMedia?"
    static let checkUserExit = "checkUserExsit?Mobile="
    static let getPropertyBasicDetail = "Property/GetBasicDetail"
    static let getPropertyOwnership = "Property/GetPropertyOwnership"
    
    static let postUserBasicDetail = "Property/PostPropertyBasicdetail?"
    static let postPropertyImage = "Property/PostPropertyImage"
    static let deletePropertyImage = "Property/DeleteFile?Id="
}

struct BookingPopUpFrames {
    
    static var navigationBarHeight : CGFloat {
        return  UIDevice.current.hasNotch ? CGFloat(88) : CGFloat(64)
    }
    static var statusBarHeight : CGFloat {
        return  UIDevice.current.hasNotch ? CGFloat(44) : CGFloat(20)
    }
    
    static  var navigationTopPadding = CGFloat(10)
    static let WidthPopUp = UIScreen.main.bounds.size.width*94/100
    static let XPopUp = UIScreen.main.bounds.size.width*3/100
    static let WidthFull = UIScreen.main.bounds.size.width
    static let PaddingX = 13
    static var paddingX : CGFloat {
        return  UIDevice.current.hasNotch ? CGFloat(150) : CGFloat(130)
    }
    
    static var paddingTop : CGFloat {
        return  UIDevice.current.hasNotch ? CGFloat(90) : CGFloat(70)
    }
    
    static var paddingXDropOffLocation : CGFloat {
        return  UIDevice.current.hasNotch ? CGFloat(155) : CGFloat(135)
    }
    static var paddingXPickUpLocation : CGFloat {
        return  UIDevice.current.hasNotch ? CGFloat(215) : CGFloat(200)
    }
}

struct APP_MESSAGES {
    static  let noInternetMessage = "You are not connected to the network. Please check your connection and try again."
    static let errorMessage = "Opps something went wrong, Please try again later."
    static let technicalIssueMessage = "We are facing some technical issue. Please try again later."
    static let comingSoon = "Coming Soon."
    static let noTokenFound = "Token is missing in api."
    static let profileupdatedSuccessfully = "Your profile has been updated successfully."
    static let passowdResetSuccessfully = "Password reset successfully"
    static let resendOtp = "OTP has been resent successfully."
}


enum SOCIAL_LOGIN:String { 
    case fb = "facebook"
    case google = "google"
}

struct CustomFont{
    static let regular13 = UIFont(name: "Poppins-Regular", size: 13.0)
    static let regular15 = UIFont(name: "Poppins-Regular", size: 15.0)
    static let medium13 = UIFont(name: "Poppins-Medium", size: 13.0)
    static let medium15 = UIFont(name: "Poppins-Medium", size: 15.0)
    static let bold13 = UIFont(name: "Poppins-Bold", size: 13.0)
    static let bold15 = UIFont(name: "Poppins-Bold", size: 15.0)
}

let WENT_WRONG = "Something went wrong."
let GOOGLE_CLIENT_ID = "612952759277-n02qjf6j73b35v3gksong68133mcdkgv.apps.googleusercontent.com"
let GOOGLE_API_KEY = "AIzaSyD-e--vbYa6C0uFgH9WbYG0ehyifWre4YQ"
