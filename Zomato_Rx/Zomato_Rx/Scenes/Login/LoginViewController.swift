//
//  LoginViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/14/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: AnimatedField!
    @IBOutlet weak var passwordTextField: AnimatedField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var continueWithSignUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupAnimatedTextField()
    }

    private func config() {
        setNavigationBarWithoutBottomLine()
        hideKeyboardWhenTap()

        // LoginButton
        loginButton.isEnabled = false
        loginButton.alpha = 0.3

        guard let image = R.image.icBackButton() else { return }
        addBackButton(with: image)
    }
}
