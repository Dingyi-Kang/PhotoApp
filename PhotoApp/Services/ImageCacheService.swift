//
//  ImageCacheService.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/20/21.
//

import Foundation
import UIKit

class ImageCacheService {
    
    static var ImageCache = [String:UIImage]()
    
    static func saveImage(url:String, image:UIImage?){
        
        //check again nil
        guard image != nil else {
           return
        }
        
        //save image
        ImageCache[url] = image!
    }
    
    static func getImage(url:String) -> UIImage? {
        //if the url not exist in the cache, it will return nil
        return ImageCache[url]
    }
    
}
