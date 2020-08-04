//
//  UIViewController+Extension.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 7/7/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func showAlert(message: String, okMessage: String = "OK", cancelMessage: String = "Cancel", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okMessage, style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: cancelMessage, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func hideKeyboardWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
