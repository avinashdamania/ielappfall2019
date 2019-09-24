//
//  LoginViewController.swift
//  EIL App
//
//  Created by Henry Vuong on 4/2/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {

    // outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        
        
        
//        // - - - bounty creator - - -
//        
//        let ref = Database.database().reference()
//        
//        let id = "102389127"
//        
//        // define the personal record
//        let bounty = [
//            "building": "CGS",
//            "floor": "n/a",
//            "date": "some_date",
//            "time": "some_time",
//            "bounty_value": "some_value"
//        ]
//        
//        // push the data to the server
//        ref.child("Bounties").child(id).setValue(bounty) { (error, ref) in
//            print("done")
//        }
//        
//        // - - -
        
        
        
        
        // make the email field a first responder
        //self.emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // login handler
    @IBAction func loginButton(_ sender: Any) {
        
        // test for the input
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            // login user
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in

                // if succesfull
                if error == nil {
                    
                    // show the main screen
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    
                // error occured
                } else {
                    
                    // show error
                    if let description = error?.localizedDescription {
                        Utils.showAlertController(in: self, withTitle: "Oops!", andMessage: description, andActionTitle: "Try again")
                    }
                }
            }
        }
    }
    
    
}
