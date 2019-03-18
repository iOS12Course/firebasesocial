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
    @IBAction func googleSigninTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
    }
    
}

