//
//  CameraViewController.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/16/21.
//

import UIKit

class CameraViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        label.alpha = 0
        
        progressView.alpha = 0
        progressView.progress = 0
        
        doneButton.alpha = 0
        
    }
    
    func savePhoto(image: UIImage){
        PhotoService.savePhoto(image: image) { (ptc) in
            
            DispatchQueue.main.async {
                //update the progress bar
                self.progressView.alpha = 1
                self.progressView.progress = Float(ptc)
                
                //update the label
                let roundedPtc = Int(ptc*100)
                self.label.text = "\(roundedPtc) %"
                self.label.alpha = 1
                
                //check if it's done
                if ptc == 1 {
                    self.label.text = "Upload completed!"
                    self.doneButton.alpha = 1
                }
            }
        }
    }


    @IBAction func doneButtonTapped(_ sender: Any) {
        //get reference to the main tapBarVC
        let tabBarVC = self.tabBarController as? MainTabBarViewController
        
        guard tabBarVC != nil else {
            return
        }
        //go to feed
        tabBarVC!.goToFeed()
    }
    
}
