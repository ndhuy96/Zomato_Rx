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
        // EmailTextField
        emailTextField.setFormat(type: .email,
                                 placeHolder: "Email",
                                 vc: self)
        _ = emailTextField.becomeFirstResponder()

        // PasswordTextField
        passwordTextField.setFormat(type: .password(6, 30),
                                    placeHolder: "Password",
                                    vc: self)
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
