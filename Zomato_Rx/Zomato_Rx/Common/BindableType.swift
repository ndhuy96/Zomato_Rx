//
//  BindableType.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/9/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
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
