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
        // NameTextField
        nameTextField.setFormat(type: .username(6, 30),
                                placeHolder: "Name",
                                vc: self)
        _ = nameTextField.becomeFirstResponder()

        // EmailTextField
        emailTextField.setFormat(type: .email,
                                 placeHolder: "Email",
                                 vc: self)

        // PasswordTextField
        passwordTextField.setFormat(type: .password(6, 30),
                                    placeHolder: "New password (min 6, max 30)",
                                    vc: self)

        // RepasswordTextField
        repasswordTextField.setFormat(type: .password(6, 30),
                                      placeHolder: "Repeat password",
                                      vc: self)
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
            return AuthError.invalidEmail.message
        } else if animatedField == passwordTextField {
            return AuthError.invalidPassword.message
        } else if animatedField == repasswordTextField {
            return AuthError.invalidRepassword.message
        }
        return nil
    }
}
