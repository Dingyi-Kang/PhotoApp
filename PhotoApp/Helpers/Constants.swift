//
//  Constants.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/18/21.
//

import Foundation


struct Constants {
    struct storyBoard {
        static let photoCellId = "PhotoCell" // this is the reusable identifier of the custom cell in the table view of feed view
        static let createProfileSegue = "goToCreateProfile"
        static let mainTabBarController = "mainTabBarController"
        static let logInViewController = "logInViewController"
    }
    
    struct LocalStorage {
        static let userIdKey = "StoredserId"
        static let userNameKey = "StoredUserName"
    }
    
    struct Photo {
        
        static let photoId = "photoId"
        static let byUserId = "byUserId"
        static let byUserName = "byUserName"
        static let date = "date"
        static let url = "url"
    }
}
