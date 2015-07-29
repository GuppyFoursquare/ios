//
//  TabBarController.swift
//  youbaku2
//
//  Created by ULAKBIM on 26/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for item in self.tabBar.items as! [UITabBarItem] {
            if let image = item.image {
                if let selectedImage = item.selectedImage {
                    item.selectedImage = selectedImage.imageWithColor(UIColor(red: 233/255, green: 203/255, blue: 73/255, alpha: 1)).imageWithRenderingMode(.AlwaysOriginal)
                }
                //item.image = image.imageWithColor(UIColor.yellowColor()).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Add anywhere in your app
extension UIImage {
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
