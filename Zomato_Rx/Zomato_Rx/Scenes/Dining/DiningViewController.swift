//
//  DiningViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy B on 5/29/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import FBSDKLoginKit
import Firebase
import GoogleSignIn

final class DiningViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func handleSignOutButtonTapped(_: Any) {
        showAlert(message: "Do you want to sign out of Zomato?", okMessage: "Sign Out") { [weak self] in
            self?.signOut()
            return
        }
    }

    deinit {
        Log.debug(message: "DiningViewController deinit")
    }

    private func signOut() {
        guard Auth.auth().currentUser != nil,
            UserDefaultsManager.shared.get(.loggedIn) else {
            return
        }
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            LoginManager().logOut()
            UserDefaultsManager.shared.set(.loggedIn, value: false)
            App.shared.backToHomeScreen()
        } catch let signOutError as NSError {
            Log.debug(message: "Error signing out: \(signOutError)")
        }
    }
}
