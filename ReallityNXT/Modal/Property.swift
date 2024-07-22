//
//  Property.swift
//  ReallityNXT
//
//  Created by Jonish Sangwan on 02/07/24.
//

import UIKit
import ObjectMapper
import Foundation

class Property: Mappable {
    
    
    var status: Int?
    var message: String?
    var data: PropertyInfo?
    
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

class PropertyInfo: Mappable{
    
    var propertyBasicInfo: PropertyBasicInfo?
    var opropertyCategories: [Propertytype]?
    
    public init() {
        
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        propertyBasicInfo <- map["propertyBasicInfo"]
        opropertyCategories <- map["opropertyCategories"]
    }
}

class PropertyBasicInfo: Mappable {
    
    
    var id: Int?
    var refNo: String?
    var category: String?
    var type: String?
    var kind: String?
    var images: [String]?
    
    public init() {
        
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        refNo <- map["refNo"]
        category <- map["category"]
        type <- map["type"]
        kind <- map["kind"]
        images <- map["images"]
    }
}

// MARK: - Datum
class Propertytype: Mappable {
    
    var id: Int?
    var propertyCategory: String?
    var oPropertyType: [OPropertyType]?
    var isSelected: Bool = false

    public init() {
        
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        propertyCategory <- map["property_Category"]
        oPropertyType <- map["oPropertyType"]
    }
}

// MARK: - OPropertyType
class OPropertyType: Mappable {
    var oPropertyKind: [OPropertyKind]?
    var id: Int?
    var propertyType: String?
    var category: Int?
    var isSelected: Bool = false

    public init() {
        
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        oPropertyKind <- map["oPropertyKind"]
        id <- map["id"]
        propertyType <- map["property_Type"]
        category <- map["category"]
    }
}

// MARK: - OPropertyKind
class OPropertyKind: Mappable {
    var id: Int?
    var propertyKind: String?
    var type: Int?
    var isSelected: Bool = false

    public init() {
        
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        propertyKind <- map["property_Kind"]
        type <- map["type"]
    }
}


class Ownership: Mappable {
    
    
    var status: Int?
    var message: String?
    var data: OwnershipArrays?
    
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

class OwnershipArrays: Mappable {
    var ownerTypes: [OwnerTypes]?
    var areaType: [AreaType]?
    var areaUnit: [AreaUnit]?

    public init() {
        
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        ownerTypes <- map["ownerTypes"]
        areaType <- map["areaType"]
        areaUnit <- map["areaUnit"]
    }
}

class OwnerTypes: Mappable {
    var id: Int?
    var ownership: String?
    var isSelected: Bool = false
    
    public init() {
        
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ownership <- map["ownership"]
    }
}

class AreaType: Mappable {
    var id: Int?
    var areaType: String?

    public init() {
        
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        areaType <- map["area_Type"]
    }
}

class AreaUnit: Mappable {
    var id: Int?
    var areaUnit: String?

    public init() {
        
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        areaUnit <- map["area_Unit"]
    }
}

class PropertyImages: Mappable{
    
    var propertyId: Int?
    var files: String?
    var propertyType: String?
    var picType: String?
    var uploadProgress: Double = 0.0
    var id: Int?

    public init() {
        
    }

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        propertyId <- map["PropertyId"]
        files <- map["files"]
        propertyType <- map["Property_Type"]
        picType <- map["Pic_Type"]
    }
}

extension PropertyImages{
    
   static func make(files: String,picType: String,propertyId: Int,propertyType: String) -> PropertyImages{
        let model = PropertyImages()
        model.files = files
        model.picType = picType
        model.propertyId = propertyId
        model.propertyType = propertyType
        return model
    }
}

struct PropertyImagesCodable: Codable{
    
    var propertyId: Int?
    var files: String?
    var propertyType: String?
    var picType: String?
}

class PostPropertyResponseModel: Mappable {
    
    var status: Int?
    var message: String?
    var data: PostPropertyModel?
    
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

class PostPropertyModel: Mappable {
    
    var id: Int?
    var propertyId: Int?
    
    public init() {
        
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        propertyId <- map["property_Id"]
    }
    
}


