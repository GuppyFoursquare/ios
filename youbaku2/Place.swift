//
//  Place.swift
//  youbaku2
//
//  Created by ULAKBIM on 23/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class Place{
    
    var plc_id: Int
    var plc_name: NSString
    var plc_header_image: NSString
    var plc_email: NSString
    var plc_contact: NSString
    var plc_website: NSString
    var plc_intime: NSString
    var plc_outtime: NSString
    var plc_Hours: NSString
    var plc_country_id: Int
    var plc_state_id: Int
    var plc_city: NSString
    var plc_address: NSString
    var plc_meta_description: NSString
    var plc_keywords: NSString
    var plc_zip: NSString
    var plc_latitude: NSString
    var plc_longitude: NSString
    var plc_menu: NSString
    var plc_info_title: NSString
    var plc_info: NSString
    var plc_is_active: NSString
    var plc_is_delete: NSString
    var feature_id: NSString
    var feature_title: NSString
    var cat_parent_id: NSString
    var pcat_name: NSString
    var plc_gallery_media: NSString
    var plc_country_name: NSString
    var plc_state_name: NSString
    var plc_avg_rating: NSString
    var rating: NSString
    
    /*
    cat.plc_id = appDict["plc_id"].intValue
    cat.plc_name = appDict["plc_name"].stringValue
    cat.plc_header_image = appDict["plc_header_image"].stringValue
    cat.plc_address = appDict["plc_address"].stringValue
    cat.rating = appDict["rating"].stringValue
*/
    init(id:String, name:String, image:String, address:String, rating:String){
        self.plc_id = id.toInt()!
        self.plc_name = name
        self.plc_header_image = image
        self.plc_email = ""
        self.plc_contact = ""
        self.plc_website = ""
        self.plc_intime = ""
        self.plc_outtime = ""
        self.plc_Hours = ""
        self.plc_country_id = -1
        self.plc_state_id = -1
        self.plc_city = ""
        self.plc_address = address
        self.plc_meta_description = ""
        self.plc_keywords = ""
        self.plc_zip = ""
        self.plc_latitude = ""
        self.plc_longitude = ""
        self.plc_menu = ""
        self.plc_info_title = ""
        self.plc_info = ""
        self.plc_is_active = ""
        self.plc_is_delete = ""
        self.feature_id = ""
        self.feature_title = ""
        self.cat_parent_id = ""
        self.pcat_name = ""
        self.plc_gallery_media = ""
        self.plc_country_name = ""
        self.plc_state_name = ""
        self.plc_avg_rating = ""
        self.rating = rating
    }
    init(){
        self.plc_id = -1
        self.plc_name = ""
        self.plc_header_image = ""
        self.plc_email = ""
        self.plc_contact = ""
        self.plc_website = ""
        self.plc_intime = ""
        self.plc_outtime = ""
        self.plc_Hours = ""
        self.plc_country_id = -1
        self.plc_state_id = -1
        self.plc_city = ""
        self.plc_address = ""
        self.plc_meta_description = ""
        self.plc_keywords = ""
        self.plc_zip = ""
        self.plc_latitude = ""
        self.plc_longitude = ""
        self.plc_menu = ""
        self.plc_info_title = ""
        self.plc_info = ""
        self.plc_is_active = ""
        self.plc_is_delete = ""
        self.feature_id = ""
        self.feature_title = ""
        self.cat_parent_id = ""
        self.pcat_name = ""
        self.plc_gallery_media = ""
        self.plc_country_name = ""
        self.plc_state_name = ""
        self.plc_avg_rating = ""
        self.rating = ""
    }
    
}
