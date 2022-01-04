//
//  MainTabBarViewController.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/19/21.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //the method which is called whenever a tap is tapped on
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //select the add tap
        if item.tag == 2 {
            
            //create an action sheet
            let actionSheet = UIAlertController(title: "Add a photo", message: "Select a source", preferredStyle: .actionSheet)
            
            //check if the cemera sourceType is available
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                //create camera button
                let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
                    //display the UIImagePickerViewController set to camera mode
                    self.showImagePickerController(for: .camera)
                }
                actionSheet.addAction(cameraButton)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let libraryButton = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                    //display the UIIMagePicckerViewController set to the photo library mode
                    self.showImagePickerController(for: .photoLibrary)
                }
                actionSheet.addAction(libraryButton)
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)//the handler is reflected in the sytle: .cancel
            actionSheet.addAction(cancelButton)
            
            //display the actionSheet
            present(actionSheet, animated: true, completion: nil)
            
        }
    }
    
    func showImagePickerController(for mode: UIImagePickerController.SourceType){
        
        let imagePicker  = UIImagePickerController()
        imagePicker.sourceType = mode
        //for communication like we wanna get notified if user select photo(s) in the piccker controller, we need to set delegat and confirm to the protocol
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension MainTabBarViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    //this func will be called if cancel is chosed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss the image picker
        dismiss(animated: true, completion: nil)
    }
    
    //this func will be called if photo/image is chosed
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //get a reference to the selected photo
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //check the selected image isn't nil
        if let selectedImage = selectedImage {
            //upload photo
            //get access to the VC associated with selected tab in the main tab bar VC. that is why it is under self. cuz it is one property of mainTabBarVC
            let tabVC = self.selectedViewController as? CameraViewController
            //if the tabVC/the reference is not nil, we save photo throught the VC
            if let tabVC = tabVC{
                tabVC.savePhoto(image: selectedImage)
            }
            
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func goToFeed(){
        
        //switch the tab to the first one
        //given this is within the class of the mainTabBarVC which is a subclass of TabBarVC which has properties like selectedIndex, selectedVC
        selectedIndex = 0
    }
    
}
