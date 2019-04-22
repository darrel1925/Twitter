//
//  LoginViewController.swift
//  Twitter
//
//  Created by Kay Lab on 4/21/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print(UserDefaults.standard.object(forKey: "userLoggedIn"))
        if UserDefaults.standard.object(forKey: "userLoggedIn") != nil {
            if UserDefaults.standard.object(forKey: "userLoggedIn") as! Int == 1 {
            self.performSegue(withIdentifier: "loginToHome" , sender: self)
            }
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let loginURL = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: loginURL, success: {
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            print(UserDefaults.standard.object(forKey: "userLoggedIn")!)
            self.performSegue(withIdentifier: "loginToHome" , sender: self)
        }, failure: { (Error) in
            print("Could Not Log In")
        })
    }
}
