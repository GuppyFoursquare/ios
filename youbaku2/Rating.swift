//
//  Rating.swift
//  youbaku2
//
//  Created by ULAKBIM on 02/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class Rating: NSObject {
    var place_rating_id = -1
    var place_rating_rating = -1
    var place_rating_comment = ""
    var places_rating_by = -1
    var places_rating_created_date = ""
    var places_rating_modified_date = ""
    var places_rating_is_active = -1
    var usr_first_name = ""
    var usr_last_name = ""
    var usr_username = ""
    var usr_profile_picture = ""
    
    init(id:String, rating:String, comment:String, date:String, name:String, surname:String, profilePic:String, isActive:String){
        self.place_rating_id = id.toInt()!
        self.place_rating_rating = rating.toInt()!
        self.place_rating_comment = comment
        self.places_rating_created_date = date
        self.places_rating_is_active = isActive.toInt()!
        self.usr_first_name = name
        self.usr_last_name = surname
        self.usr_profile_picture = profilePic
    }
}
