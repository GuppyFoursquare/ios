//
//  Gallery.swift
//  youbaku2
//
//  Created by ULAKBIM on 30/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class Gallery:MWPhoto {
    var plc_gallery_media = ""
    var plc_gallery_is_video = -1
    var plc_gallery_seq = -1
    var plc_is_cover_image = -1
    var plc_gallery_is_active = -1

    init(media:String, isVideo:String, seq:String, isCover:String, isActive:String){
        self.attributedCaptionTitle = NSAttributedString(string: " ", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])

        self.plc_gallery_media = media
        self.plc_gallery_is_video = isVideo.toInt()!
        self.plc_gallery_seq = seq.toInt()!
        self.plc_is_cover_image = isCover.toInt()!
        self.plc_gallery_is_active = isActive.toInt()!
        let urlString = YouNetworking.BASEURL + "/uploads/places_images/large/" + self.plc_gallery_media
        let url = NSURL(string: urlString)
        var request = NSURLRequest(URL: url!)
        super.init(URL: url)
        /*
        SimpleCache.sharedInstance.getImage(url!, completion: { (im:UIImage?, err:NSError?) -> () in
            if(err == nil){
                super.init(image: im)
            }else{
                
            }
        })
*/
       
    }
    //var image: UIImage?
    var placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString
    let attributedCaptionSummary = NSAttributedString(string: " ", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
    let attributedCaptionCredit = NSAttributedString(string: " ", attributes: [NSForegroundColorAttributeName: UIColor.darkGrayColor()])
    
    init(image: UIImage?, attributedCaptionTitle: NSAttributedString) {
   //     self.image = image
        self.attributedCaptionTitle = attributedCaptionTitle

        super.init(image: image)
        
    }
    
    convenience init(attributedCaptionTitle: NSAttributedString) {
        self.init(image: nil, attributedCaptionTitle: attributedCaptionTitle)
    }
}
