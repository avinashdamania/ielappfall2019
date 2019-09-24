//
//  SettingTableViewController.swift
//  EIL App
//
//  Created by Vuong, Henry on 4/5/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var segmentedCtrlGender: UISegmentedControl!
    @IBOutlet weak var txtFieldFt: UITextField!
    @IBOutlet weak var txtFieldInch: UITextField!
    @IBOutlet weak var txtFieldWeight: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtFieldMajor: UITextField!
    @IBOutlet weak var txtFieldAge: UITextField!
    
    @IBOutlet weak var globalNumTransactionsLabel: UITextView!
    
    @IBOutlet weak var aboutSectionLabel: UITextView!
    
    // properties
    private var gender: String = "Male"
    private var feet: String?
    private var inches: String?
    private var weight: String?
    private var major: String?
    private var age: String?
    private var alertController: UIAlertController?
    private var globalNumTransactions: Int?
    private var totalNumTransactions: Int?
    private var currentNumTransactions = 0
    
    // database reference
    private let ref: DatabaseReference = Database.database().reference()

    // on the controller load
    override func viewDidLoad() {
        
        // - - - add the DONE buttons to the keyboards to dismiss the keyboard - - -
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        //setting toolbar as inputAccessoryView
        self.txtFieldFt.inputAccessoryView = toolbar
        self.txtFieldInch.inputAccessoryView = toolbar
        self.txtFieldWeight.inputAccessoryView = toolbar
        self.txtFieldMajor.inputAccessoryView = toolbar
        self.txtFieldAge.inputAccessoryView = toolbar
        // - - - https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
        
        
    }
    
    // dismiss handler
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
 
        // delete the separation lines
        self.tableView.separatorStyle = .none
        
        
        
        
        
        
        ref.child("GlobalNumTransactions").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let history_records = value {
                for hr in history_records {
                    let record = hr.value as! String
                    self.globalNumTransactions = Int(record)!
                }
            }
        }
        
        ref.child("TotalNumTransactions").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let history_records = value {
                for hr in history_records {
                    let record = hr.value as! String
                    self.totalNumTransactions = Int(record)!
                    self.globalNumTransactionsLabel.text = "We have received \(self.globalNumTransactions!) out of \(self.totalNumTransactions!) submissions!"
                }
            }
        }
        
        
        
        // Fetch the record corresponding to the uid
        if let id = Auth.auth().currentUser?.uid {
            
            
            ref.child("UserData").child(id).child("transactions").observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let history_records = value {
                    for hr in history_records {
                        let record = hr.value as! String
                        self.currentNumTransactions = Int(record)!
                    }
                }
            }
            
            ref.child("UserData").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                if let record = value?.value(forKey: id) as? NSDictionary {
                    
                    if let gender = record.value(forKey: "gender") as? String {
                        
                        if let height = record.value(forKey: "height") as? String {
                            
                            if let weight = record.value(forKey: "weight") as? String {
                                
                                if let major = record.value(forKey: "major") as? String {
                                    
                                    if let age = record.value(forKey: "age") as? String {
                                
                                        // split the height in inches and feet
                                        let h = height.components(separatedBy: "-")
                                        self.feet = h[0]
                                        self.inches = h[1]
                                        
                                        // get the gender and the weight
                                        self.gender = gender
                                        self.weight = weight
                                        self.major = major
                                        self.age = age
                                        
                                        
                                        // populate the textfields
                                        self.txtFieldFt.text = self.feet
                                        self.txtFieldInch.text = self.inches
                                        self.txtFieldWeight.text = self.weight
                                        self.txtFieldMajor.text = self.major
                                        self.txtFieldAge.text = self.age
                                        self.gender = gender
                                        
                                        // update the gender
                                        if self.gender == "Female" {
                                            self.segmentedCtrlGender.selectedSegmentIndex = 1
                                        } else {
                                            self.segmentedCtrlGender.selectedSegmentIndex = 0
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
        
        // display the user email
        if let email = Auth.auth().currentUser?.email {
            self.lblEmail.text = email
        }
        
        // reload the data
        self.tableView.reloadData()
    }
    
    // segmented control handler
    @IBAction func segmentedCtrlActionGender(_ sender: Any) {
        let index = self.segmentedCtrlGender.selectedSegmentIndex
        if let selection = self.segmentedCtrlGender.titleForSegment(at: index) {
            self.gender = selection
        }
    }
    
    // save button handler
    @IBAction func saveButton(_ sender: Any) {
        
        // unwrap all the field values
        if let id = Auth.auth().currentUser?.uid {
                
            if let feet = self.txtFieldFt.text {
                
                if let inches = self.txtFieldInch.text {
                    
                    if let weight = self.txtFieldWeight.text {
                        if let major = self.txtFieldMajor.text {
                            if let age = self.txtFieldAge.text {
                        
                        // define the personal record
                        let personalInfoRecord = [
                            "gender": "\(self.gender)",
                            "height": "\(feet)-\(inches)",
                            "weight": "\(weight)",
                            "transactions": "\(self.currentNumTransactions)",
                            "major": "\(major)",
                            "age": "\(age)"
                        ]
                        
                        // push the data to the server
                        ref.child("UserData").child(id).setValue(personalInfoRecord) { (error, ref) in
                            
                            // error handling for the server response
                            if error == nil {
                                
                                // show success message
                                Utils.showAlertController(in: self, withTitle: "Saved!", andMessage: "We updated your record!", andActionTitle: "OK")
                                self.txtFieldFt.resignFirstResponder()
                                self.txtFieldInch.resignFirstResponder()
                                self.txtFieldWeight.resignFirstResponder()
                                
                            } else {
                                
                                // show failure message
                                if let description = error?.localizedDescription {
                                    
                                    Utils.showAlertController(in: self, withTitle: "Oops!", andMessage: description, andActionTitle: "Try again")
                                }
                            }
                        }
                    }
                    }
                }
                }
            }
        }
    }
    
    // sign out handler
    @IBAction func signOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    // table view controller delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 18
    }
}
