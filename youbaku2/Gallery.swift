//
//  Gallery.swift
//  youbaku2
//
//  Created by ULAKBIM on 30/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class Gallery:NSObject {
    var plc_gallery_media = ""
    var plc_gallery_is_video = -1
    var plc_gallery_seq = -1
    var plc_is_cover_image = -1
    var plc_gallery_is_active = -1
    init(media:String, isVideo:Int, seq:Int, isCover:Int, isActive:Int){
        self.plc_gallery_media = media
        self.plc_gallery_is_video = isVideo
        self.plc_gallery_seq = seq
        self.plc_is_cover_image = isCover
        self.plc_gallery_is_active = isActive
    }
}
