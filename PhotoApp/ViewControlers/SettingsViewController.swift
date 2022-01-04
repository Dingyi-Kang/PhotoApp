//
//  SettingsViewController.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/16/21.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutTapped(_ sender: Any) {
        
        //sign out with Firebase Auth
        do {
            //try to sign out user
            try Auth.auth().signOut()
            //clear the local storage
            LocalStorageService.clearDefaultUser()
            //transition to authentication flow
            let VC = self.storyboard?.instantiateViewController(identifier: Constants.storyBoard.logInViewController)
            self.view.window?.rootViewController = VC
            self.view.window?.makeKeyAndVisible()
        }
        catch {
            //couldn't sign out
        }
        
        
    }
    
}
