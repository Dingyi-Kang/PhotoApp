//
//  CreateProfileViewController.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/16/21.
//

import UIKit
import FirebaseAuth

class CreateProfileViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func confirmTapped(_ sender: Any) {
        
        //check there is a user logged in
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        //get the username
        //check it against with whitespace, new lines, illegal characters, etc
        //note: this username returned could be nil, hence we need to check
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if username == nil || username == "" {
            //show an error message
            return
        }
        //call the user services to create the profile
        UserService.createProfile(userID: Auth.auth().currentUser!.uid, userName: username!) { (user) in
            
            //check if it was created successfully
            //if so, go to the tab bar view controller
            if user != nil {
                LocalStorageService.saveUser(userId: user!.userId!, username: user!.username!)
                let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.storyBoard.mainTabBarController)
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()
            }
            
            //if not, display error
            else {
                //show error
            }
            
        }
        
    }
    
    
    

}
