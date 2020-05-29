//
//  UITableView+Extension.swift
//  mvvm-architect
//
//  Created by Nguyen Duc Huy B on 5/11/20.
//  Copyright © 2020 sun. All rights reserved.
//

public protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}

extension UITableView {
    func register<T: UITableViewCell>(_ aClass: T.Type) {
        register(aClass, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func registerNib<T: UITableViewCell>(_: T.Type) {
        register(UINib(nibName: T.reuseIdentifier, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(_: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("`\(T.reuseIdentifier)` is not registed")
        }
        return cell
    }
}
