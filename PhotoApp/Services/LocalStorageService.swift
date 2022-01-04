//
//  LocalStorageService.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/18/21.
//

import Foundation

class LocalStorageService {
    
    static func saveUser(userId:String, username: String){
        
        //get reference to user default
        let defaultUser = UserDefaults.standard
        
        //save the userId and userName into defaults
        defaultUser.setValue(userId, forKey: Constants.LocalStorage.userIdKey)
        defaultUser.setValue(username, forKey: Constants.LocalStorage.userNameKey)
    }
    
    
    static func loadUser() -> PhotoUser? {
        
        let defaultUser = UserDefaults.standard
        
        //note the data returned here could be nil
        //note this function is defaultUser.value(forKey) not defaultUser.data(forKey)
        let userId = defaultUser.value(forKey: Constants.LocalStorage.userIdKey) as? String
        let userName = defaultUser.value(forKey: Constants.LocalStorage.userNameKey) as? String
        
        if userId != nil && userName != nil {
            return PhotoUser(userId: userId!, username: userName!)
        }
        else {
            return nil
        }
    }
    
    static func clearDefaultUser(){
        
        let defaultUser = UserDefaults.standard
        
        defaultUser.set(nil, forKey: Constants.LocalStorage.userIdKey)
        defaultUser.set(nil, forKey: Constants.LocalStorage.userNameKey)
        
    }
    
}
