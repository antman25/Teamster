//
//  TestUserViewController.swift
//  Teamster
//
//  Created by Anthony Magner on 1/28/18.
//  Copyright © 2018 Anthony Magner. All rights reserved.
//

import UIKit
import Firebase

class TestUserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /*if let err:Error = error {
            print(err.localizedDescription)
            return
        }
        
        self.performSegue(withIdentifier: "LoginToChat", sender: nil)*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginTest1(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: "test@test.com", password: "testtest") { (user, error) in
            
            //print("error: \(error)")
            if let err:Error = error {
                print(err.localizedDescription)
                return
            }
            FirebaseHelper.loginUser(user: user)
            print("user: \(user?.uid)")
            self.performSegue(withIdentifier: "showChat", sender: nil)
        }
            
       
        
    }
    
    @IBAction func loginTest2(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: "test2@test.com", password: "testtest") { (user, error) in
            
            //print("error: \(error)")
            if let err:Error = error {
                print(err.localizedDescription)
                return
            }
            print("user: \(user?.uid)")
            self.performSegue(withIdentifier: "showChat", sender: nil)
        }
        
        
    }
    
    @IBAction func loginTest3(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: "test3@test.com", password: "testtest") { (user, error) in
            
            //print("error: \(error)")
            if let err:Error = error {
                print(err.localizedDescription)
                return
            }
            print("user: \(user?.uid)")
            self.performSegue(withIdentifier: "showChat", sender: nil)
        }
        
        
        
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        print("Logout Pressed")
        do {
            FirebaseHelper.logoutUser(user: Auth.auth().currentUser)
            try Auth.auth().signOut()
            print("Sigend out")
        } catch {
            print("Logout Error")
        }
        //guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        //appDel.window?.rootViewController = TestUserViewController()
        //print("Login VC set")
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
    }
}
