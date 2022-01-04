//
//  PhotoViewCell.swift
//  PhotoApp
//
//  Created by OSU App Center on 6/20/21.
//

import UIKit

class PhotoViewCell: UITableViewCell {

    var photo:Photo?
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configureDisplayingOfPhoto(photo:Photo){
        
        //Given the cell is reuable, we need to set it to default in the start
        self.photoImageView.image = nil
        self.userNameLabel.text = ""
        self.dateLabel.text = ""
        
        //begin to configure
        self.photo = photo
        //set the username
        userNameLabel.text = photo.byUserName
        //set the date
        dateLabel.text = photo.date
        
        //download the image
        guard photo.url != nil else {
            return
        }
        
        //check if the image is in cache. get it if exist
        if let image = ImageCacheService.getImage(url: photo.url!){
            DispatchQueue.main.async {
                self.photoImageView.image = image
            }
            return
        }
        
        //if the URL returns a non-nil URL object
        if let url = URL(string: photo.url!){
            
            //use url session to download the image asychronously
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                
                if error == nil && data != nil {
                    //download url image and save it into cache immediately
                    let image = UIImage(data: data!)
                    ImageCacheService.saveImage(url: url.absoluteString, image: image)
                    
                    //check if the image data we downloaded match the photo this cell is currently supposed to display
                    //if not match, we abandon current task by returning
                    if url.absoluteString != self.photo!.url! {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.photoImageView.image = image
                    }
                    
                }

            }
            dataTask.resume()
            
        }
        
    }
    
}
