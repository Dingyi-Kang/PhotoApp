//
//  Photo.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/19/21.
//

import Foundation
import FirebaseFirestore

struct Photo {
    var photoId:String?
    var byUserId:String?
    var byUserName:String?
    var date:String?
    var url:String?
    
    init? (snapShot: QueryDocumentSnapshot){
        
        //parse the data out
        let data = snapShot.data()
        
        let photoId = data[Constants.Photo.photoId] as? String
        let byUserId = data[Constants.Photo.byUserId] as? String
        let byUserName = data[Constants.Photo.byUserName] as? String
        let date = data[Constants.Photo.date] as? String
        let url = data[Constants.Photo.url] as? String
        
        //check for missing data
        guard photoId != nil && byUserId != nil && byUserName != nil && date != nil && url != nil else {
            return nil
        }
        
        //set our properties
        self.photoId = photoId
        self.byUserId = byUserId
        self.byUserName = byUserName
        self.date = date
        self.url = url
        
    }
    
}
