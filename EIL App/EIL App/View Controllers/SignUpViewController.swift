//
//  SignUpViewController.swift
//  EIL App
//
//  Created by Henry Vuong on 4/2/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController {

    // outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        // email is a first responder
        self.emailTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // signup handler
    @IBAction func signupButton(_ sender: Any) {
        
        // if the fields are not empty
        if emailTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" {
            
            if !((emailTextField.text?.contains("utexas.edu"))!) {
                Utils.showAlertController(in: self, withTitle: "Oops!", andMessage: "Please use your utexas email to sign up.", andActionTitle: "OK")
            } else if !(passwordTextField.text == confirmPasswordTextField.text) {
                Utils.showAlertController(in: self, withTitle: "Oops!", andMessage: "The passwords you entered do not match. Please try again!", andActionTitle: "OK")
            } else {
            // attempt to sign up user
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    DispatchQueue.global().async {
                        DispatchQueue.global().sync {
                            let ref: DatabaseReference = Database.database().reference()
                            let personalInfoRecord = [
                                "gender": "null",
                                "height": "0-0",
                                "weight": "0",
                                "transactions": "0",
                                "major": "null"
                            ]
                            // push the data to the server
                            ref.child("UserData").child((Auth.auth().currentUser?.uid)!).setValue(personalInfoRecord) { (error, ref) in
                                // error handling for the server response
                                if error == nil {
                                    // show success message
                                    Utils.showAlertController(in: self, withTitle: "Saved!", andMessage: "We updated your record!", andActionTitle: "OK")
                                } else {
                                    // show failure message
                                    if let description = error?.localizedDescription {
                                        
                                        Utils.showAlertController(in: self, withTitle: "Oops!", andMessage: description, andActionTitle: "An error occurred in signing you up")
                                    }
                                }
                            }
                            
                                
                            self.performSegue(withIdentifier: "signInSegue", sender: nil)
                        }
                        
                    }
                    
                    
                    
                    
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
}
