//
//  Category.swift
//  youbaku2
//
//  Created by ULAKBIM on 22/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class Category:NSObject {
    var cat_id = -1
    var cat_parent_id = -1
    var cat_name = ""
    var cat_image = ""
    var cat_color = ""
    var cat_is_active = -1
    var cat_is_delete = -1
    var cat_seq = -1
    var cat_created_date = NSDate()
    var cat_modified_date = NSDate()
    var sub_cats = [Category]()
    override init() {
        super.init()
    }
    /*
    if let appArray = hoge["content"].array {
        for appDict in appArray {
            var cat:Category = Category()
            cat.cat_name = appDict["cat_name"].stringValue
            cat.cat_image = appDict["cat_image"].string!
            cat.cat_id = appDict["cat_id"].intValue
            cats.append(cat)
        }
    }
}
*/
    init(id:String, name:String, image: String){
        self.cat_id = id.toInt()!
        self.cat_name = name
        self.cat_image = image
    }
}
