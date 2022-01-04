//
//  UserServices.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/18/21.
//

import Foundation
import FirebaseFirestore

//we write the networking code into a single class/module
class UserService {
    
    static func createProfile(userID: String, userName: String, checking: @escaping (PhotoUser?) -> Void){
        
        //create a dictionary for profile data
        let profile = ["username":userName]
        
        //get a reference to fireStore
        let db = Firestore.firestore()
        //create a document for the userId
        db.collection("users").document(userID).setData(profile) { (error) in
            if error == nil {
                //profile was created successfully
                //create an user
                let u = PhotoUser()
                u.userId = userID
                u.username = userName
                //return an user for storing it locally later
                checking(u)
            }
            else {
                //somthing went wrong
                //return nil
                checking(nil)
                
            }
        }
        
    }
    
    
                            //given the possible return of this func is photoUser or nil, the parameter for the closure method should be PhotoUser?
    static func retrieveProfile(for UserID: String, cmplt: @escaping (PhotoUser?) -> Void) {
        
        //get a reference to fireStore
        let db = Firestore.firestore()
        
        //check for a profile, given the user id
        db.collection("users").document(UserID).getDocument { (snapShot, error) in
            
            if error == nil && snapShot != nil {
                
                //if the profile exist and is found, create a new photo user
                if let profile = snapShot?.data() {
                    
                    let u = PhotoUser()
                    u.userId = snapShot!.documentID
                    u.username = profile["username"] as? String
                    //return the user
                    //passed the return to the closure method, which label is completion
                    cmplt(u)
                    
                }
                else {
                // if the profile is not found, no profile
                //return nil
                    cmplt(nil)
                }
                
            }
            
        }
        
    }
    
}
