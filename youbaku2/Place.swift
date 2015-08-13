//
//  Place.swift
//  youbaku2
//
//  Created by ULAKBIM on 23/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class Place{
    var coordinate : CLLocationCoordinate2D?
    var plc_id: Int
    var plc_name: String
    var plc_header_image: String
    var plc_email: String
    var plc_contact: String
    var plc_website: String
    var plc_intime: String
    var plc_outtime: String
    var plc_Hours: String
    var plc_country_id: Int
    var plc_state_id: Int
    var plc_city: String
    var plc_address: String
    var plc_meta_description: String
    var plc_keywords: String
    var plc_zip: String
    var plc_latitude: String
    var plc_longitude: String
    var plc_menu: String
    var plc_info_title: String
    var plc_info: String
    var plc_is_active: String
    var plc_is_delete: String
    var feature_id: String
    var feature_title: String
    var cat_parent_id: String
    var pcat_name: String
    var plc_gallery_media: String
    var plc_country_name: String
    var plc_state_name: String
    var rating_avg: Float
    var rating_count: Int
    var rating: String
    var plc_is_open: String
    var plc_distance: Float = -1.0
    /*
    cat.plc_id = appDict["plc_id"].intValue
    cat.plc_name = appDict["plc_name"].stringValue
    cat.plc_header_image = appDict["plc_header_image"].stringValue
    cat.plc_address = appDict["plc_address"].stringValue
    cat.rating = appDict["rating"].stringValue
*/
    init(id:String, name:String, image:AnyObject!, address:String, rating:String, rating_avg:AnyObject!, rating_count:AnyObject!, plc_latitude:AnyObject!, plc_longitude:AnyObject!, is_open:AnyObject!){
        self.plc_id = id.toInt()!
        self.plc_name = name
        if(image != nil){
            self.plc_header_image = image as! String
        }else{
            self.plc_header_image = ""
        }
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
        self.rating = rating
        if(rating_avg != nil){
            if((rating_avg as! Float) <= 0){
                self.rating_avg = 0
            }else{
                self.rating_avg = rating_avg as! Float
            }
        }else{
            self.rating_avg = 0
        }
        
        if(rating_count != nil){
            if((rating_count as! Float) <= 0){
                self.rating_count = 0
            }else{
                self.rating_count = rating_count as! Int
            }
        }else{
            self.rating_count = 0
        }
        
        if(plc_latitude != nil){
            self.plc_latitude = plc_latitude as! String
        }else{
            self.plc_latitude = ""
        }
        if(plc_longitude != nil){
            self.plc_longitude = plc_longitude as! String
        }else{
            self.plc_longitude = ""
        }
        if(is_open != nil){
            self.plc_is_open = is_open as! String
        }else{
            self.plc_is_open = "0"
        }
    }
     
    init(id:String, name:String, image:AnyObject!, address:String, rating:String, lat:String, long:String){
        self.plc_id = id.toInt()!
        self.plc_name = name
        if(image != nil){
            self.plc_header_image = image as! String
        }else{
            self.plc_header_image = ""
        }
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
        self.plc_latitude = lat
        self.plc_longitude = long
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
        self.rating = rating
        self.coordinate = CLLocationCoordinate2D(latitude: (lat as NSString).doubleValue, longitude: (long as NSString).doubleValue)
        self.rating_count = 0
        self.rating_avg = 0
        self.plc_is_open = "0"
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
        self.rating = ""
        self.rating_count = 0
        self.rating_avg = 0
        self.plc_is_open = "0"
    }
    
}
