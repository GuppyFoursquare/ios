//
//  YouNetworking.swift
//  youbaku2
//
//  Created by ULAKBIM on 25/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
// Alamofire

import UIKit

struct YouNetworking {
    enum Router: URLRequestConvertible {
        static let baseURLString = "http://193.140.63.162/youbaku"
        
        case Places(String)
        
        case Categories()
        
        case Place(String)
        
        case SubCategories(String)
        
        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .Places (let cat_id):
                    let params = ["sub_cat_id": cat_id, "lat": 40.372877, "lon": 49.842825, "op": "nearme"]
                    return ("/api/places.php", params as! [String : AnyObject])
                    
                case .Categories():
                    let params = [:]
                    return ("/api/category.php", params as! [String : AnyObject])
                    
                case .Place(let place_id):
                    let params = ["plc_id": place_id,"op": "info"]
                    return ("/api/places.php", params)
                    
                case .SubCategories(let cat_id):
                    let params = ["cat_id": cat_id]
                    return ("/api/category.php", params)
                    
                }
                }()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            let encoding = ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
}

extension Request {
    class func imageResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            
            return (image, nil)
        }
    }
    
    func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self {
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request, response, image as? UIImage, error)
        })
    }
}
