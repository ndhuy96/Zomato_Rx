//
//  AnimatedField+Extension.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy B on 8/18/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

// swiftlint:disable force_unwrapping
extension AnimatedField {
    func setFormat<T: AnimatedFieldDelegate & AnimatedFieldDataSource>(type: AnimatedFieldType, placeHolder: String, vc: T?) {
        // AnimatedFieldFormat
        var format = AnimatedFieldFormat()
        format.titleFont = UIFont(name: R.font.okraLight.fontName, size: 12)!
        format.alertFont = UIFont(name: R.font.okraMedium.fontName, size: 12)!
        format.textFont = UIFont(name: R.font.okraLight.fontName, size: 14)!
        format.alertColor = .red
        format.alertFieldActive = false
        format.titleAlwaysVisible = true
        self.format = format
        self.placeholder = placeHolder
        self.type = type
        
        if let vc = vc {
            self.delegate = vc
            self.dataSource = vc
        }
        
        switch type {
        case .password(6, 30):
            self.isSecure = true
            self.showVisibleButton = true
        default:
            break
        }
    }
}
