//
//  InstaModel.swift
//  InstagramSwift
//
//  Created by Shawn Yapa on 2/10/15.
//  Copyright (c) 2015 Shawn Yapa. All rights reserved.
//

import UIKit

class InstaModel: NSObject {
    
    var name: String
    var caption: String
    var urlThumbnail: String
    var urlStandardResolution: String
    
    override init() {
        name = ""
        caption = ""
        urlThumbnail = ""
        urlStandardResolution = ""
        super.init()
    }
    
    class func createInstaModel (instaPhotoDictionary:NSDictionary) -> InstaModel {
        
        var instaPhotoModel = InstaModel.init()
        instaPhotoModel.name = instaPhotoDictionary.valueForKey("user")?.valueForKey("full_name") as String
        instaPhotoModel.caption = (instaPhotoDictionary.valueForKey("caption")?.valueForKey("text")) as String
        instaPhotoModel.urlThumbnail = (instaPhotoDictionary.valueForKey("images")?.valueForKey("thumbnail")?.valueForKey("url")) as String
        instaPhotoModel.urlStandardResolution = (instaPhotoDictionary.valueForKey("images")?.valueForKey("standard_resolution")?.valueForKey("url")) as String
        
        return instaPhotoModel
    }
    
    class func createInstaModels (instaPhotos:[NSDictionary]) -> [InstaModel] {
        
        var instaModels = [InstaModel]()
        for instaPhotoDictionary in instaPhotos {
            var instaModel = InstaModel.createInstaModel(instaPhotoDictionary)
            instaModels.append(instaModel)
        }
        
        return instaModels
    }
   
}
