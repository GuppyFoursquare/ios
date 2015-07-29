//
//  HalfSizePresentationController.swift
//  youbaku2
//
//  Created by ULAKBIM on 22/07/15.
//  Copyright (c) 2015 Beraat. All rights reserved.
//

import UIKit

class HalfSizePresentationController: UIPresentationController {
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return CGRect(x: 0, y: 200, width: containerView.bounds.width, height: containerView.bounds.height/2)
    }
}
