//
//  HistoryTableViewController.swift
//  EIL App
//
//  Created by STEPAN ULYANIN on 4/13/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HistoryTableViewController: UITableViewController {

    // database reference
    private let ref = Database.database().reference()
    private var records: [Record] = []
    private var personal_records: [Record] = []
    
    @IBOutlet weak var transactionCounter: UIBarButtonItem!
    
    private var amountPerTransaction: Double = 0.0
    private var numCurrentUserTransactions: Int = 0
    private var globalNumTransactions: Int = 0
    
    // if let id = Auth.auth().currentUser?.uid
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // refresh the records
        self.records = []
        self.personal_records = []
        
        // get the records
        ref.child("Transaction").observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            if let history_records = value {
                
                for hr in history_records {
                    
                    // get the values
                    let record = hr.value as! [String:String]
                    let building = record["building"]
                    let date = record["date"]
                    let room = record["room"]
                    let id = record["userId"]
                    let lat = record["lat"]
                    let long = record["long"]
                    let comfort = record["room_comfort"]
                    let time = record["time"]
                    
                    // append to the collection
                    self.records.append(Record(submittedBy: id!, inBuilding: building!, inRoom: room!, atDate: date!, atTime: time!, atLat: lat!, atLong: long!, comfortLevel: comfort!))
                }
            }
            
            // filter the data
            if let id = Auth.auth().currentUser?.uid {
                for record in self.records {
                    if record.id! == id {
                        self.personal_records.append(record)
                    }
                }
            }
            
            // reload the data
            self.tableView.reloadData()
        }
        
        
        
        ref.child("AmountPerTransaction").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let history_records = value {
                for hr in history_records {
                    let record = hr.value as! String
                    self.amountPerTransaction = Double(record)!
                }
            }
        }
        
        
        ref.child("GlobalNumTransactions").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let history_records = value {
                for hr in history_records {
                    let record = hr.value as! String
                    self.globalNumTransactions = Int(record)!
                    
                }
            }
        }
        
        
        
        
        if let id = Auth.auth().currentUser?.uid {
            ref.child("UserData").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let record = value?.value(forKey: id) as? NSDictionary {
                    if let transactions = record.value(forKey: "transactions") as? String {
                        self.numCurrentUserTransactions = Int(transactions)!
                        let font = UIFont.systemFont(ofSize: 10)
                        self.transactionCounter.setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedStringKey.font.rawValue): font], for: .normal)
                        
                        
                        let temp: Double = self.amountPerTransaction * Double(self.numCurrentUserTransactions)
                        let amtEarned: String = String(format: "%.2f", temp)
                        
//                        let temp2: Double = Double(self.globalNumTransactions) * self.amountPerTransaction
//                        let temp3: String = String(format: "%.2f", temp2)
                        self.transactionCounter.title = "Your Rewards: $\(amtEarned)"
                        

                        
                    }
                }
            })
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.personal_records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell

        // populate the cells
        cell.lblBuilding.text = self.personal_records[indexPath.row].building
        cell.lblRoom.text = self.personal_records[indexPath.row].room
        cell.lblDate.text = self.personal_records[indexPath.row].date
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! MapHistoryViewController
        destinationViewController.personal_records = personal_records
    }
}
