//
//  LoginViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy on 8/14/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

final class LoginViewController: UIViewController, BindableType {
    @IBOutlet weak var emailTextField: AnimatedField!
    @IBOutlet weak var passwordTextField: AnimatedField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var continueWithSignUpButton: UIButton!

    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupAnimatedTextField()
    }

    deinit {
        Log.debug(message: "LoginViewController deinit")
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

    func bindViewModel() {
        let input = LoginViewModel.Input(email: emailTextField.textField.rx.text.orEmpty.asDriver(),
                                         password: passwordTextField.textField.rx.text.orEmpty.asDriver(),
                                         loginTrigger: loginButton.rx.tap.asDriver(),
                                         continueWithSignUpTrigger: continueWithSignUpButton.rx.tap.asDriver())

        let output = viewModel.transform(input: input)

        output.continueWithSignUp
            .drive()
            .disposed(by: rx.disposeBag)

        output.login
            .drive()
            .disposed(by: rx.disposeBag)

        output.loading
            .drive(SVProgressHUD.rx.isAnimating)
            .disposed(by: rx.disposeBag)

        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }
                self.showAlert(message: error.localizedDescription)
            })
            .disposed(by: rx.disposeBag)
    }
}
