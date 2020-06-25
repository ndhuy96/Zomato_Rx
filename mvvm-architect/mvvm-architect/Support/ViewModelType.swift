//
//  ViewModelType.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy on 4/20/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
