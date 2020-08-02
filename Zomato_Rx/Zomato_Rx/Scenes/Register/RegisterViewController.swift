//
//  RegisterViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/20/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class RegisterViewController: UIViewController {
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: AnimatedField!
    @IBOutlet weak var emailTextField: AnimatedField!
    @IBOutlet weak var passwordTextField: AnimatedField!
    @IBOutlet weak var repasswordTextField: AnimatedField!
    @IBOutlet weak var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupAnimatedTextField()
    }

    private func config() {
        guard let navController = navigationController else { return }
        navController.navigationBar.shadowImage = UIImage()
        hideKeyboardWhenTap()

        // RegisterButton
        registerButton.isEnabled = false
        registerButton.alpha = 0.3
    }
}
