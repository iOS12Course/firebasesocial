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
import FBSDKLoginKit
import TwitterKit

class ViewController: UIViewController , GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
   
    

    //Outlets
    @IBOutlet weak var userInfoLbl: UILabel!
    @IBOutlet weak var facebookLoginBtn: FBSDKLoginButton!
    
    @IBOutlet weak var twitterBtnView: UIView!
    //Variables
    let loginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        facebookLoginBtn.delegate = self
        facebookLoginBtn.readPermissions = ["email"]
        
        let loginTwitterBtn = TWTRLogInButton { (session, error) in
            if let error = error {
                debugPrint("Could not login twitter", error)
            }
            
            if let session = session {
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                self.firebaseLogin(credential)
            }
        }
        loginTwitterBtn.center.x = twitterBtnView.center.x
        twitterBtnView.addSubview(loginTwitterBtn)
        
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
    
    
    //Google
    @IBAction func googleSigninTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func customGoogleTapped(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    //Facebook
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            debugPrint("Failed facebook login:", error)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
        firebaseLogin(credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //Handle logout sequence. 
    }
    
    
    @IBAction func customFacebookTapped(_ sender: Any) {
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if let error = error {
                debugPrint("could not login facebook", error)
            } else if (result?.isCancelled)! {
                print("Facebook login was cancelled")
            } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseLogin(credential)
            }
        }
    }
    
    
    //Twitter
    
    @IBAction func customTwitterTapped(_ sender: Any) {
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            if let error = error {
                debugPrint("Could not login twitter", error)
            }
            
            if let session = session {
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                self.firebaseLogin(credential)
            }
        }
    }
    
    
    //Firebase
    
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
                loginManager.logOut()
            default:
                break
            }
        }
    }
    
}

