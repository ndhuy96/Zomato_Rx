//
//  UIViewController+Rx.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/21/20.
//  Copyright © 2020 sun. All rights reserved.
//

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLoad)).mapToVoid()
        return ControlEvent(events: source)
    }

    var viewWillAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillAppear(_:))).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
