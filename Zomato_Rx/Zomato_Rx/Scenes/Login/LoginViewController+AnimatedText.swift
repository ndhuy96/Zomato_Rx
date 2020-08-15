//
//  LoginViewController+AnimatedText.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/14/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

// swiftlint:disable force_unwrapping
extension LoginViewController: AnimatedFieldDelegate {
    func setupAnimatedTextField() {
        // AnimatedFieldFormat
        var format = AnimatedFieldFormat()
        format.titleFont = UIFont(name: R.font.okraLight.fontName, size: 12)!
        format.alertFont = UIFont(name: R.font.okraMedium.fontName, size: 12)!
        format.textFont = UIFont(name: R.font.okraLight.fontName, size: 14)!
        format.alertColor = .red
        format.alertFieldActive = false
        format.titleAlwaysVisible = true

        // EmailTextField
        emailTextField.format = format
        emailTextField.placeholder = "Email"
        emailTextField.dataSource = self
        emailTextField.delegate = self
        emailTextField.type = .email
        _ = emailTextField.becomeFirstResponder()

        // PasswordTextField
        passwordTextField.format = format
        passwordTextField.placeholder = "Password"
        passwordTextField.dataSource = self
        passwordTextField.delegate = self
        passwordTextField.type = .password(6, 30)
        passwordTextField.isSecure = true
        passwordTextField.showVisibleButton = true
    }

    func animatedFieldShouldReturn(_ animatedField: AnimatedField) -> Bool {
        if animatedField == emailTextField {
            _ = passwordTextField.becomeFirstResponder()
        } else if animatedField == passwordTextField {
            _ = passwordTextField.resignFirstResponder()
        }
        return true
    }

    func animatedFieldDidEndEditing(_: AnimatedField) {
        let validEmailUser = emailTextField.isValid && passwordTextField.isValid
            && !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty
        loginButton.isEnabled = validEmailUser
        loginButton.alpha = validEmailUser ? 1.0 : 0.3
    }
}

extension LoginViewController: AnimatedFieldDataSource {
    func animatedFieldValidationError(_ animatedField: AnimatedField) -> String? {
        if animatedField == emailTextField {
            return AuthError.invalidEmail.message
        } else if animatedField == passwordTextField {
            return AuthError.invalidPassword.message
        }
        return nil
    }
}
