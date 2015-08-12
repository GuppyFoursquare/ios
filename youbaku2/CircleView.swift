//
//  CircleView.swift
//  youbaku2
//
//  Created by ULAKBIM on 02/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class CircleView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        var startAngle: Float = Float(2 * M_PI)
        var endAngle: Float = 0.0
        
        // Drawing code
        // Set the radius
        let strokeWidth = 1.0
        let radius = CGFloat(50)
        
        // Get the context
        var context = UIGraphicsGetCurrentContext()
        
        // Find the middle of the circle
        let center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        
        // Set the stroke color
        CGContextSetStrokeColorWithColor(context, UIColor(red: 233/255, green: 203/255, blue: 73/255, alpha: 1).CGColor)
        
        // Set the line width
        CGContextSetLineWidth(context, CGFloat(strokeWidth))
        
        // Set the fill color (if you are filling the circle)
        CGContextSetFillColorWithColor(context, UIColor(red: 233/255, green: 203/255, blue: 73/255, alpha: 1).CGColor)
        
        // Rotate the angles so that the inputted angles are intuitive like the clock face: the top is 0 (or 2π), the right is π/2, the bottom is π and the left is 3π/2.
        // In essence, this appears like a unit circle rotated π/2 anti clockwise.
        startAngle = startAngle - Float(M_PI_2)
        endAngle = endAngle - Float(M_PI_2)
        
        // Draw the arc around the circle
        CGContextAddArc(context, center.x, center.y, CGFloat(radius), CGFloat(startAngle), CGFloat(endAngle), 0)
        
        // Draw the arc
        CGContextDrawPath(context, kCGPathFillStroke) // or kCGPathFillStroke to fill and stroke the circle
    }

}
