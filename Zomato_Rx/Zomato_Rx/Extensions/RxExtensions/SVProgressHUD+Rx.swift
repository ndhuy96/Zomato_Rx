//
//  SVProgressHUD+Rx.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/13/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

extension Reactive where Base: SVProgressHUD {
    public static var isAnimating: Binder<Bool> {
        return Binder(UIApplication.shared) { _, isVisible in
            if isVisible {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
}
