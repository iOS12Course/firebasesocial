//
//  ViewController.swift
//  firebaseSocial
//
//  Created by Ricardo Herrera Petit on 3/18/19.
//  Copyright © 2019 Ricardo Herrera Petit. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController , GIDSignInUIDelegate {

    //Outlets
    @IBOutlet weak var userInfoLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.userInfoLbl.text = "No user logged in"
            } else {
                self.userInfoLbl.text = "Welcome user: \(user?.uid ?? "")"
            }
            
        }
    }
    
    @IBAction func googleSigninTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func customGoogleTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            logoutSocial()
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
        }
    }
    
    func logoutSocial() {
        guard let user = Auth.auth().currentUser else { return }
        for info in (user.providerData) {
            switch info.providerID {
            case GoogleAuthProviderID:
                GIDSignIn.sharedInstance()?.signOut()
                print("google")
            case TwitterAuthProviderID:
                print("twitter")
            case FacebookAuthProviderID:
                print("facebook")
            default:
                break
            }
        }
    }
    
}

