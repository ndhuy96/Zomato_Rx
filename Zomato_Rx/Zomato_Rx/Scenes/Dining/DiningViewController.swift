//
//  DiningViewController.swift
//  Zomato_Rx
//
//  Created by Nguyen Duc Huy B on 5/29/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import Firebase

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

    private func signOut() {
        do {
            try Auth.auth().signOut()
            UserDefaultsManager.shared.set(.loggedIn, value: false)
            App.shared.backToHomeScreen()
        } catch let signOutError as NSError {
            Log.debug(message: "Error signing out: \(signOutError)")
        }
    }
}
