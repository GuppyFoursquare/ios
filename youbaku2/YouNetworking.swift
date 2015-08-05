//
//  YouNetworking.swift
//  youbaku2
//
//  Created by ULAKBIM on 25/06/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
// Alamofire

import UIKit


struct YouNetworking {
    static var APIKEY = ""
    static var TOKEN = ""
    
    
    enum Router: URLRequestConvertible {
        
        static let baseURLString = "http://www.youbaku.com"
        
        case Places(String)
        
        case Categories()
        
        case Place(String)
        
        case SubCategories(String)
        
        case NearbyPlaces(String, String)
        
        case Login(String, String)
        
        case Register()

        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .Places (let cat_id):
                    let params = ["src_cat[]": cat_id, "token":"341766447c4ab254450c8b7398e3c6b9","apikey":"93e0e61f3852745d161d78e1796a7e9d"]
        

                    return ("/api/places.php?op=search&token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params as [String : String])
                    
                case .Categories():
                    let params = [:]

                    return ("/api/category.php?token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params as! [String : AnyObject])
                    
                case .Place(let place_id):
                    let params = ["plc_id": place_id,"op": "info"]

                    return ("/api/places.php?token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY+"&op=info&plc_id=" + place_id, params)
                    
                case .SubCategories(let cat_id):
                    let params = ["cat_id": cat_id]

                    return ("/api/category.php?token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY + "&cat_id="+cat_id, params)
                    
                case .NearbyPlaces(let lat, let lon):
                    
                    let params = [:]
                    
                    return ("/api/places.php?op=nearme&lat="+"40.372877"+"&lon="+"49.842825"+"&token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params as! [String : AnyObject])
                    
                case .Login(let user, let pass):
                    let params = ["name": user, "pass": pass]
                    return ("/api/auth.php?&op=login&token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params )
                    
                case .Register():
                    let params = [:]
                    return ("/api/register.php", params as! [String:AnyObject])
                    
                    
                }
                }()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
         
            let encoding = ParameterEncoding.URL
            return encoding.encode(URLRequest, parameters: parameters).0
            
            
        }
        
    }
    
    enum Router2: URLRequestConvertible {
        static let baseURLString = "http://www.youbaku.com"
        
        case Places(String)
        
        case Categories()
        
        case Place(String)
        
        case SubCategories(String)
        
        case NearbyPlaces(String, String, String)
        
        case Search([Int])
        
        case Login(String, String)
        
        case AddReview(String, Int, Int)
        
        case Logout()
        
        case Popular()
        
        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .Places (let cat_id):
                    let params = ["src_cat[]": cat_id]
                    
                    
                    return ("/api/places.php?op=search", params as [String : String])
                    
                case .Categories():
                    let params = [:]
                    
                    return ("/api/category.php", params as! [String : AnyObject])
                    
                case .Place(let place_id):
                    let params = ["plc_id": place_id,"op": "info"]
                    
                    return ("/api/places.php", params)
                    
                case .SubCategories(let cat_id):
                    let params = ["cat_id": cat_id]
                    
                    return ("/api/category.php", params)
                    
                case .NearbyPlaces(let sub_cat_id, let lat, let lon):
                    let params = ["sub_cat_id": sub_cat_id, "lat": 40.372877, "lon": 49.842825, "op": "nearme"]
                    return ("/api/places.php?token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params as! [String : AnyObject])
                case .Search(let cats):
                    var op = "op"
                    let params = ["subcat_list": cats.description, op: "search"]
                    return ("/api/places.php?token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params as [String : String])
                case .Login(let user, let pass):
                    let params = ["name": user, "pass": pass]
                    return ("/api/auth.php?op=login&token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params )
                case .AddReview(let comment, let rating, let plc_id):
                    let params = ["plc_id": plc_id, "message": comment, "score": rating]
                    return ("/api/auth.php?op=comment&token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params as! [String : AnyObject] )
                case .Logout():
                    let op = "op"
                    let params = [op:"logout"]
                    return ("/api/auth.php?token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params)
                case .Popular():
                    let params = [:]
                    return ("/api/places.php?op=search&popular=1&token=" + YouNetworking.TOKEN + "&apikey=" + YouNetworking.APIKEY, params as! [String : AnyObject])
                }
                
                }()
            let URL = NSURL(string: Router2.baseURLString)
            let URLRequest = NSMutableURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            URLRequest.HTTPMethod = "POST"
            URLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            URLRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(parameters as NSDictionary, options: nil, error: nil)
            let encoding = ParameterEncoding.JSON
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
