//
//  SignInViewController.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/12/21.
//

import UIKit
//note: import fireBaseUI instead of firebase
import FirebaseUI

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func LogInAction(_ sender: Any) {
        
        //create a fireBase AuthUI object
        //get the default AuthUI from the library provided by fireBase
        //note the return value of the defaultAuthUI() is nil
        let authUI = FUIAuth.defaultAuthUI()
        
        //check it is not nil
        if let authUI = authUI {
            
            //set self as delegate for the authUI. for the communication
            authUI.delegate = self
            
            //set sign in providers, namely what type of verification signIn method
            authUI.providers = [FUIEmailAuth()]
            //get the pre-built UI view controller provided by fireBaseUI
            let authViewController = authUI.authViewController()
            //present it
            present(authViewController, animated: true, completion: nil)
        }
        
    }
    
    
    
}


extension SignInViewController: FUIAuthDelegate {
    
    //part of the protocol of the FUIAuth
    //it will be called, after the user is authentificaed (after typing email and correct password).
    //Then it will return and pass the the AuthDataResult to this function
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        guard error == nil else {
            return}
        
        //authDataResult contains the FIR user structure/nil in fireBase
        if let user = authDataResult?.user {
        
            //check on the dataBase side if user has a profile based on the uid of FIR user class/struct
            //by passing closure into the service method, we dont need to use delegate for comm any more
            //it will conitue to run the closure code after method return and pass the return to the closure
            //hence, there is no need for nominate delegate to notify after finish and return anymore
            UserService.retrieveProfile(for: user.uid) { (theUser) in
                
                //if not, go to create profile VC
                if theUser == nil {
                    self.performSegue(withIdentifier: Constants.storyBoard.createProfileSegue, sender: self)
                }
               
                //if yes, go to the tab bar View controller
                else{
                    // if so, go to tab bar view controller
                    LocalStorageService.saveUser(userId: theUser!.userId!, username: theUser!.username!)
                    
                    //create an instance of tar bar VC
                    if let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.storyBoard.mainTabBarController){
                        //!!!set it as the root of the window: that is the way we sets the bar controller the thing the user see
                        //that is the way we jump to certain window
                        self.view.window?.rootViewController = tabBarVC
                        self.view.window?.makeKeyAndVisible()
                    }
                    
                    
                    
                    
                }
            }
            
           
        }
        
    }
    
}

