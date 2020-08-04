//
//  RegisterViewController+AnimatedText.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/4/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

// swiftlint:disable force_unwrapping
extension RegisterViewController: AnimatedFieldDelegate {
    func setupAnimatedTextField() {
        // AnimatedFieldFormat
        var format = AnimatedFieldFormat()
        format.titleFont = UIFont(name: R.font.okraLight.fontName, size: 12)!
        format.alertFont = UIFont(name: R.font.okraMedium.fontName, size: 12)!
        format.textFont = UIFont(name: R.font.okraLight.fontName, size: 14)!
        format.alertColor = .red
        format.alertFieldActive = false
        format.titleAlwaysVisible = true

        // NameTextField
        nameTextField.format = format
        nameTextField.placeholder = "Name"
        nameTextField.dataSource = self
        nameTextField.delegate = self
        nameTextField.type = .username(4, 30)

        // EmailTextField
        emailTextField.format = format
        emailTextField.placeholder = "Email"
        emailTextField.dataSource = self
        emailTextField.delegate = self
        emailTextField.type = .email

        // PasswordTextField
        passwordTextField.format = format
        passwordTextField.placeholder = "New password (min 6, max 30)"
        passwordTextField.dataSource = self
        passwordTextField.delegate = self
        passwordTextField.type = .password(6, 30)
        passwordTextField.isSecure = true
        passwordTextField.showVisibleButton = true

        // RepasswordTextField
        repasswordTextField.format = format
        repasswordTextField.placeholder = "Repeat password"
        repasswordTextField.dataSource = self
        repasswordTextField.delegate = self
        repasswordTextField.type = .password(6, 30)
        repasswordTextField.isSecure = true
    }

    func animatedFieldDidBeginEditing(_ animatedField: AnimatedField) {
        if animatedField == repasswordTextField && UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            KeyboardAvoiding.avoidingView = view
        } else {
            KeyboardAvoiding.avoidingView = nil
        }
        return
    }

    func animatedFieldShouldReturn(_ animatedField: AnimatedField) -> Bool {
        if animatedField == nameTextField {
            _ = emailTextField.becomeFirstResponder()
        } else if animatedField == emailTextField {
            _ = passwordTextField.becomeFirstResponder()
        } else if animatedField == passwordTextField {
            _ = repasswordTextField.becomeFirstResponder()
        } else if animatedField == repasswordTextField {
            _ = repasswordTextField.resignFirstResponder()
        }
        return true
    }

    func animatedFieldDidEndEditing(_: AnimatedField) {
        let validEmailUser = emailTextField.isValid && nameTextField.isValid
            && passwordTextField.isValid && repasswordTextField.isValid
            && !emailTextField.text!.isEmpty && !nameTextField.text!.isEmpty
            && !passwordTextField.text!.isEmpty && !repasswordTextField.text!.isEmpty
        registerButton.isEnabled = validEmailUser
        registerButton.alpha = validEmailUser ? 1.0 : 0.3
    }

    func animatedField(_ animatedField: AnimatedField, didSecureText secure: Bool) {
        if animatedField == passwordTextField {
            repasswordTextField.secureField(secure)
        }
    }
}

extension RegisterViewController: AnimatedFieldDataSource {
    func animatedFieldLimit(_ animatedField: AnimatedField) -> Int? {
        if animatedField == nameTextField {
            return 30
        }
        return nil
    }

    func animatedFieldValidationError(_ animatedField: AnimatedField) -> String? {
        if animatedField == emailTextField {
            return SignInError.invalidEmail.message
        } else if animatedField == passwordTextField {
            return SignInError.invalidPassword.message
        } else if animatedField == repasswordTextField {
            return SignInError.invalidRepassword.message
        }
        return nil
    }
}
