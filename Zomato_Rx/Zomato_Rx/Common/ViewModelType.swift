//
//  ViewModelType.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/19/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
