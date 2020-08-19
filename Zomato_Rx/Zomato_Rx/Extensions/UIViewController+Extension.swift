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

    func setNavigationBarWithoutBottomLine() {
        guard let navController = navigationController else { return }
        navController.navigationBar.shadowImage = UIImage()
    }

    func addBackButton(with image: UIImage) {
        let backButton = UIButton()
        backButton.setImage(image, for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self,
                             action: #selector(backButtonClick),
                             for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton

        // Setting a custom back button disable the swipe back feature.
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    @objc
    func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }
}
