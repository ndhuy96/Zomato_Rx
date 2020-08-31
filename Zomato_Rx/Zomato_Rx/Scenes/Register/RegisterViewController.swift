//
//  RegisterViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 6/20/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class RegisterViewController: UIViewController, BindableType {
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var continueWithLoginButton: UIButton!
    @IBOutlet weak var nameTextField: AnimatedField!
    @IBOutlet weak var emailTextField: AnimatedField!
    @IBOutlet weak var passwordTextField: AnimatedField!
    @IBOutlet weak var repasswordTextField: AnimatedField!
    @IBOutlet weak var registerButton: UIButton!

    var viewModel: RegisterViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupAnimatedTextField()
    }

    private func config() {
        setNavigationBarWithoutBottomLine()
        hideKeyboardWhenTap()

        // RegisterButton
        registerButton.isEnabled = false
        registerButton.alpha = 0.3
    }

    deinit {
        Log.debug(message: "RegisterViewController deinit")
    }

    func bindViewModel() {
        let input = RegisterViewModel.Input(username: nameTextField.textField.rx.text.orEmpty.asDriver(),
                                            email: emailTextField.textField.rx.text.orEmpty.asDriver(),
                                            password: passwordTextField.textField.rx.text.orEmpty.asDriver(),
                                            registerTrigger: registerButton.rx.tap.asDriver(),
                                            continueWithLoginTrigger: continueWithLoginButton.rx.tap.asDriver(),
                                            backTrigger: backButton.rx.tap.asDriver())

        let output = viewModel.transform(input: input)

        output.back
            .drive()
            .disposed(by: rx.disposeBag)

        output.continueWithLogin
            .drive()
            .disposed(by: rx.disposeBag)

        output.register
            .drive()
            .disposed(by: rx.disposeBag)

        output.loading
            .drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: rx.disposeBag)

        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self,
                    let error = error as? AuthError,
                    error != .cancelled else { return }
                self.showAlert(message: error.message)
            })
            .disposed(by: rx.disposeBag)
    }
}
