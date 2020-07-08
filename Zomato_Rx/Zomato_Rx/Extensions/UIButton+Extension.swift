//
//  UIButton+Extension.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/13/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

extension UIButton {
    func setShadow(shadowColor _: CGColor,
                   shadowOffset: CGSize = CGSize(width: 0, height: 2.0),
                   shadowOpacity: Float = 1.0,
                   shadowRadius: CGFloat = 4.0) {
        layer.masksToBounds = false
        layer.shadowColor = R.color.shadowColor()?.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius

        // Ask iOS to cache the rendered shadow so that it doesn't need to be redrawn
        layer.shouldRasterize = true
        // iOS caches the shadow at the same drawing scale as the main screen
        layer.rasterizationScale = UIScreen.main.scale
    }
}
