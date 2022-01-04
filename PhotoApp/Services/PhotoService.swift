//
//  PhotoService.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/19/21.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class PhotoService {
    
    static func retrievePhoto(completion: @escaping ([Photo])->Void){
        
        //get reference to fireBase
        let db = Firestore.firestore()
        
        //get all documents from the photo collection
        db.collection("photos").getDocuments { (snapshot, error) in
    
            //check for errors
            guard error == nil else{
                return
            }
            //get all the documents. what .documents return could be nil
            if let docs = snapshot?.documents {
                var photos = [Photo]()
                //loop through the documents, create a photo struct for each
                
                for doc in docs {
                    
                    let p = Photo(snapShot: doc)
                    //given the init of photo is fallible, we need check if it is nil
                    if p != nil {
                        photos.append(p!)
                        //photos.insert(p!, at: 0)
                    }
                }
                //pass the array back to caller. For this communication, we can use trailing closure
                completion(photos)
            }
            
        }
        
        
    }
    
    static func savePhoto(image: UIImage, updateProgress: @escaping(Double)->Void){
        
        //get the data representation of the UIImage
        let PhotoData = image.jpegData(compressionQuality: 0.1)
        guard PhotoData != nil else {
            //couldnt get data from UIImage
            return
        }
        
        //create a filename
        //the uuid string will gurantee the name is unique
        let fileName = UUID().uuidString
        guard Auth.auth().currentUser != nil else {
            print("No login accout")
            return
        }
        
        //get the user id of the current user
        let userId = Auth.auth().currentUser!.uid
        
        //create a firebase storage path/referencer
        //we get a rreference to certain location in storage, and store this reference into variable
        let ref = Storage.storage().reference().child("images/\(userId)/\(fileName).jpeg")
        
        //upload the data. we need the function with completion handler
        let uploadTask = ref.putData(PhotoData!, metadata: nil) { (metaData, error) in
            //chech if the upload is successfully
            if error == nil {
                //given the code has been very long, we wanna to encapsulate the rest code into another method
                //upon sucessful upload, create the database entry
                createDatabaseEntry(ref: ref)
            }
        }
        uploadTask.observe(.progress) { (TaskSnapShot) in
            let pct = Double(TaskSnapShot.progress!.completedUnitCount)/Double(TaskSnapShot.progress!.totalUnitCount)
            updateProgress(pct)
        }
        
        
    }
    
    //given the method is only used by the savePhoto method in this class, we make it private
    //the reason why we need storage reference is this is the only way we are able to get the download url
    private static func createDatabaseEntry(ref : StorageReference){
        
        //download url
        ref.downloadURL { (url, error) in
            guard error == nil else{
                return
            }
            //photoId
            let photoId = ref.fullPath
            
            let user = LocalStorageService.loadUser()
            //byUserId
            let byUserId = user!.userId
            //byUserName
            let byUserName = user!.username
            
            //set the format first via the below class
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            
            //pass the date in the dateFormatter object which will process and generate a string of date in certain format, like full
            let dataString = dateFormatter.string(from: Date())
            
            //create a dictionanry of the photo metaData
            //absoluteString represents the download url with token
            let metaData = [Constants.Photo.photoId:photoId, Constants.Photo.byUserId:byUserId!, Constants.Photo.byUserName:byUserName!, Constants.Photo.date:dataString, Constants.Photo.url:url!.absoluteString]
            
            //save the dictionary into fireBase database
            let db = Firestore.firestore()
            
            db.collection("photos").addDocument(data: metaData) { (error) in
                //check if the saving is successful
                if error == nil {
        
                }
            }
        }
       
        
    }
    
}
