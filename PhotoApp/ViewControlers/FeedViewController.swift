//
//  FeedViewController.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/16/21.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //add to pull to refresh
        addRefreshControll()
        
        //use the photoService to retrive the photo data
        //after retriving, we run the closure code
        PhotoService.retrievePhoto { (photos) in
            self.photos = photos
            self.tableView.reloadData()
            
        }
    }
    
    func addRefreshControll(){
        //create refresh controll
        let refreshControll = UIRefreshControl()
        //set target. self refers this VC
        refreshControll.addTarget(self, action: #selector(refreshFeed(refreshCtrl:)), for: .valueChanged)
        //add to table view
        self.tableView.addSubview(refreshControll)
    }
    
    //also, pass the controll to the function itself, so that we can stop the refressh control
    @objc func refreshFeed(refreshCtrl:UIRefreshControl){
        //call the photoService to reload and update the data related to photos
        PhotoService.retrievePhoto { (photos) in
            self.photos = photos
            self.tableView.reloadData()
            //stop the spinner
            DispatchQueue.main.async {
              refreshCtrl.endRefreshing()
            }
           
        }
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.storyBoard.photoCellId, for: indexPath) as? PhotoViewCell
        
        let photo = photos[indexPath.row]
        
        cell?.configureDisplayingOfPhoto(photo: photo)
        
        return cell!
        
    }
    
    
    
}
