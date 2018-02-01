//
//  ViewController.swift
//  Teamster
//
//  Created by Anthony Magner on 1/1/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import UIKit
import Firebase

import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    

    @IBOutlet weak var imageBackground: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageBackground.alpha = 0
        buttonLogin.alpha = 0
        labelTitle.alpha = 0
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*UIView.animate(withDuration: 1.0, animations: {

            }, completion: true)*/
        
        UIView.animate(withDuration: 1.0, animations: {
            self.imageBackground.alpha = 0.8
        }) { (true) in
            //
            UIView.animate(withDuration: 0.7, animations: {
                self.labelTitle.alpha = 1.0
            }, completion: { (true) in
                UIView.animate(withDuration: 0.7, animations: {
                    self.buttonLogin.alpha = 1.0
                }, completion: { (true) in
                    
                })
            })
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

