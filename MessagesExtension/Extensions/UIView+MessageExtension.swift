//
//  UIView+MessageExtension.swift
//  TicTacToeSample
//
//  Created by Prianka Liz Kariat on 7/15/16.
//  Copyright © 2016 Prianka Liz Kariat. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func takeSnapshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main().scale)
        
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    } 
}
