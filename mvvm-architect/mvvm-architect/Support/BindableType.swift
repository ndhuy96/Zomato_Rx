//
//  BindableType.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 6/24/20.
//  Copyright © 2020 sun. All rights reserved.
//

public protocol BindableType: class {
    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }

    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    public func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
