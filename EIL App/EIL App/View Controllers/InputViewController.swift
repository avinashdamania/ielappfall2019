//
//  InputViewController.swift
//  EIL App
//
//  Created by Vazquez Canteli, Jose R on 4/10/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation

class InputViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{

    private var time_remaining: String = ""
    private var latest_record_time = ""
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var textFieldBuilding: UITextField!
    @IBOutlet weak var textFieldFloor: UITextField!
    @IBOutlet weak var textFieldRoom: UITextField!
    @IBOutlet weak var shirtSegControl: UISegmentedControl!
    @IBOutlet weak var pantsSegControl: UISegmentedControl!
    @IBOutlet weak var jacketSegControl: UISegmentedControl!
    @IBOutlet weak var roomSlider: UISlider!
    @IBOutlet weak var wantedRoomSlider: UISlider!
    
    
    var comfortLevel = "0"  // initial comfort level value
    var buildings = ["PCL", "UTC", "SZB", "JES", "JCD", "BHD", "RHD", "SJH", "PHD", "MHD", "GRE", "RSC", "SSW", "MNC", "BEL", "CLA", "SAC", "BRB", "EPS", "GDC", "POB", "PPE", "CS6", "JGB", "UTX", "WIN", "LTH", "PPL", "CT1", "PPA", "ART", "DFA", "PAC", "TMM", "WAG", "CBA", "GSB", "BEN", "MEZ", "BAT", "HRH", "CAL", "PAR", "SUT", "HRC", "GOL", "WMB", "BTL", "GAR", "COM", "MAI", "GEB", "WCH", "WEL", "PAI", "BIO", "HMA", "FAC", "UNB", "LBJ", "TCC", "MRH", "JON", "CS4", "CCJ", "TNH", "SER", "WRW", "MB1", "PAT", "EER", "RLM", "ECJ", "MBB", "NMS", "AHG", "FNT", "NHB", "PHR", "BUR", "BME", "GEA", "GWB", "AND", "BLD", "CRD", "LTD", "LFH", "LCH", "HSM", "CMB", "CMA", "WWH", "BMC", "KIN", "SSB", "SEA", "CPE", "ETC", "ADH", "TSC", "SMC", "HLB", "DCP", "HTB", "HDB", "NUR", "CDL", "ERC"] // list of UT buildings
    
    var buildingCoordinates = ["PCL": ["30.2827","-97.7382"], "UTC": ["30.2831","-97.7388"], "SZB": ["30.2816","-97.7387"], "JES": ["30.2828","-97.7368"], "JCD": ["30.2824","-97.7365"], "BHD": ["30.2831","-97.7360"], "RHD": ["30.2831","-97.7351"], "SJH": ["30.2823","-97.7344"], "PHD": ["30.2824","-97.7351"], "MHD": ["30.2835","-97.7354"], "GRE": ["30.2840","-97.7365"], "RSC": ["30.2815","-97.7325"], "SSW": ["30.2808","-97.7327"], "MNC": ["30.2824","-97.7327"], "BEL": ["30.2838","-97.7336"], "CLA": ["30.2849","-97.7355"], "SAC": ["30.2848","-97.7363"], "BRB": ["30.2852","-97.7367"], "EPS": ["30.2858","-97.7367"], "GDC": ["30.2863","-97.7366"], "POB": ["30.2869","-97.7365"], "PPE": ["30.2869","-97.7358"], "CS6": ["30.2864","-97.7357"], "JGB": ["30.2859","-97.7357"], "UTX": ["30.2843","-97.7344"], "WIN": ["30.2858","-97.7344"], "LTH": ["30.2859","-97.7352"], "PPL": ["30.2868","-97.7351"], "CT1": ["30.2866","-97.7347"], "PPA": ["30.2869","-97.7344"], "ART": ["30.2863","-97.7330"], "DFA": ["30.2858","-97.7317"], "PAC": ["30.2861","-97.7312"], "TMM": ["30.2869","-97.7324"], "WAG": ["30.2850","-97.7376"], "CBA": ["30.2840","-97.7379"], "GSB": ["30.2841","-97.7384"], "BEN": ["30.2840","-97.7390"], "MEZ": ["30.2844","-97.7390"], "BAT": ["30.2848","-97.7390"], "HRH": ["30.2841","-97.7402"], "CAL": ["30.2845","-97.7401"], "PAR": ["30.2849","-97.7401"], "SUT": ["30.2849","-97.7408"], "HRC": ["30.2843","-97.7412"], "GOL": ["30.2853","-97.7412"], "WMB": ["30.2854","-97.7406"], "BTL": ["30.2854","-97.7404"], "GAR": ["30.2852","-97.7385"], "COM": ["30.2900","-97.7406"], "MAI": ["30.2861","-97.7394"], "GEB": ["30.2863","-97.7386"], "WCH": ["30.2861","-97.7384"], "WEL": ["30.2868","-97.7377"], "PAI": ["30.2871","-97.7388"], "BIO": ["30.2872","-97.7398"], "HMA": ["30.2869","-97.7406"], "FAC": ["30.2863","-97.7403"], "UNB": ["30.2866","-97.7411"], "LBJ": ["30.2857","-97.7290"], "TCC": ["30.2870","-97.7291"], "MRH": ["30.2873","-97.7309"], "JON": ["30.2885","-97.7317"], "CS4": ["30.2886","-97.7325"], "CCJ": ["30.2883","-97.7304"], "TNH": ["30.2884","-97.7308"], "SER": ["30.2875","-97.7347"], "WRW": ["30.2875","-97.7357"], "MB1": ["30.2876","-97.7367"], "PAT": ["30.2880","-97.7364"], "EER": ["30.2881","-97.7353"], "RLM": ["30.2889","-97.7362"], "ECJ": ["30.2890","-97.7353"], "MBB": ["30.2885","-97.7372"], "NMS": ["30.2892","-97.7372"], "AHG": ["30.2885","-97.7379"], "FNT": ["30.2878","-97.7380"], "NHB": ["30.2876","-97.7380"], "PHR": ["30.2880","-97.7385"], "BUR": ["30.2889","-97.7384"], "BME": ["30.2892","-97.7387"], "GEA": ["30.2878","-97.7392"], "GWB": ["30.2878","-97.7399"], "AND": ["30.2882","-97.7398"], "BLD": ["30.2887","-97.7394"], "CRD": ["30.2887","-97.7401"], "LTD": ["30.2893","-97.7397"], "LFH": ["30.2881","-97.7407"], "LCH": ["30.2885","-97.7409"], "HSM": ["30.2889","-97.7407"], "CMB": ["30.2893","-97.7411"], "CMA": ["30.2893","-97.7407"], "WWH": ["30.2893","-97.7418"], "BMC": ["30.2902","-97.7407"], "KIN": ["30.2904","-97.7396"], "SSB": ["30.2900","-97.7384"], "SEA": ["30.2900","-97.7373"], "CPE": ["30.2902","-97.7362"], "ETC": ["30.2899","-97.7354"], "ADH": ["30.2915","-97.7406"], "TSC": ["30.2798","-97.7334"], "SMC": ["30.2762","-97.7341"], "HLB": ["30.2755","-97.7333"], "DCP": ["30.2762","-97.7330"], "HTB": ["30.2773","-97.7351"], "HDB": ["30.2773","-97.7351"], "NUR": ["30.2777","-97.7335"], "CDL": ["30.2787","-97.7330"], "ERC": ["30.2770","-97.7322"]]
    
    var buildingsToCheck: [String] = []
    
    var buildingsNoRewards: [String] = []
    
    var gpsValidationDistance: Double = 0.0
    var currentNumTransactions: Int = 0
    var weeklyTransactionLimit: Int = 0
    var transactionsThisWeek: Int = 0
    var amountPerTransaction: Double = 0.0
    var globalNumTransactions: Int = 0
    
    
    var selectedBuilding: String? // selected building for picker view
    
    // database reference
    private var ref: DatabaseReference = Database.database().reference()
    
    // location manager
    private let locationManager = CLLocationManager()
    
    // lat long props
    private var lat: String = ""
    private var long: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildings.sort()
        
        // - - - add the DONE buttons to the keyboards to dismiss the keyboard - - -
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        //setting toolbar as inputAccessoryView
        self.textFieldRoom.inputAccessoryView = toolbar
        self.textFieldFloor.inputAccessoryView = toolbar
        // - - - https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
        
        
        
//        // - - - - Location - - - - -
//        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
//
//        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
////            locationManager.delegate = self
////            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
////            locationManager.startUpdatingLocation()
//            
//
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//        }
        
        
        
        // - - - - - - - -
        
        
        // - - - - Location - - - - -
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //            locationManager.delegate = self
            //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //            locationManager.startUpdatingLocation()
            
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // assign the delegates
        self.textFieldBuilding.delegate = self
        self.textFieldRoom.delegate = self

        // create building view picker and toolbar
        createBuildingPicker()
        createToolbar()
        
        
//        ref.child("TotalNumTransactions").childByAutoId().setValue("3000")
        
        
        ref.child("BuildingsToCheck").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let history_records = value {
                for hr in history_records {
                    let record = hr.value as! [String:String]
                    for building in record {
                        if building.value == "1" {
                            self.buildingsToCheck.append(building.key)
                        }
                        if building.value == "2" {
                            self.buildingsToCheck.append(building.key)
                            self.buildingsNoRewards.append(building.key)
                        }
                    }
                }
            }
        }
        
        
        ref.child("GPSValidationDistance").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let history_records = value {
                for hr in history_records {
                    let record = hr.value as! String
                    self.gpsValidationDistance = Double(record)!
                    
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
        
        
        ref.child("AmountPerTransaction").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let history_records = value {
                for hr in history_records {
                    let record = hr.value as! String
                    self.amountPerTransaction = Double(record)!
                    
                }
            }
        }
        
      
        
        ref.child("WeeklyTransactionLimit").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let history_records = value {
                for hr in history_records {
                    let record = hr.value as! String
                    self.weeklyTransactionLimit = Int(record)!
                    print(self.weeklyTransactionLimit)
                }
            }
        }
        
        if let userId = Auth.auth().currentUser?.uid {
            print("user id is \(userId)")
            
            ref.child("UserData").observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let history_records = value {
                    for hr in history_records {
                        let record = hr.value as! [String:String]
                        if (hr.key as! String == userId) {
                            print("yuh")
                            if let temp = Int(record["transactions"]!) {
                                self.currentNumTransactions = temp
                            }
                        }
                    }
                }
            }
            
            
            
            
            
            ref.child("UserData").child(userId).child("transactions").observeSingleEvent(of: .value) { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let history_records = value {
                    for hr in history_records {
                        let record = hr.value as! String
                        self.currentNumTransactions = Int(record)!
                    }
                }
            }
            
            
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            //            locationManager.delegate = self
            //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //            locationManager.startUpdatingLocation()
            
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        self.buildingsToCheck.sort()
        
        
        // set the button disabled by default
        self.btnSubmit.isEnabled = false
        
        // update the time and -> unlock the button
        self.update_time()
        
        
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // update time from the last post
    func update_time() {
        
        // query the records from the server
        let ref = Database.database().reference()
        var records: [Record] = []
        var personal_records: [Record] = []
        
        // refresh the records
        records = []
        personal_records = []
        
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
                    let datetime = record["date_time"]
                    
                    // append to the collection
                    records.append(Record(submittedBy: id!, inBuilding: building!, inRoom: room!, atDate: date!, atTime: datetime!, atLat: lat!, atLong: long!, comfortLevel: comfort!))
                }
            }
            
            if let id = Auth.auth().currentUser?.uid {
                for record in records {
                    if record.id! == id {
                        personal_records.append(record)
                    }
                    
                    let record_time = record.time!
                    let formatter_from = DateFormatter()
                    formatter_from.dateFormat = "yyyyMMddHHmmss"
                    let post_date = formatter_from.date(from: record_time)
                    let defaultDate = NSDate()
                    let time_inteval = NSDate().timeIntervalSince(post_date ?? defaultDate as Date)
                    let remaining_time =  604800 - Int(ceil(time_inteval))
                    if remaining_time >= 0 {
                        self.transactionsThisWeek += 1
                    }
                }
            }
            
            // sort the records
            let sorted_records = personal_records.sorted(by: { $0.time! > $1.time! })
            
            // get the latest record
            // if the sorted array is empty - no posts have been made yet
            if sorted_records.isEmpty {
                
                // allow to post
                self.btnSubmit.isEnabled = true
                self.lblTime.text = "Ready!"
            
            // if the sorted array not empty - there are previous posts
            } else {
                
                // get the time of the latest record
                let latest_record_time = sorted_records[0].time

                // convert the string to date
                let formatter_from = DateFormatter()
                formatter_from.dateFormat = "yyyyMMddHHmmss"
                let post_date = formatter_from.date(from: latest_record_time!)
                print(latest_record_time)
                
                // calculate the elapsed seconds
                let defaultDate = NSDate()
                let time_inteval = NSDate().timeIntervalSince(post_date ?? defaultDate as Date)
                
                // calculate the 3 hour interval count down
                let remaining_time =  10800 - Int(ceil(time_inteval))
//                let remaining_time =  1 - Int(ceil(time_inteval))
                
                // get hours, minutes, seconds
                let re_hours = remaining_time / 3600
                let re_minutes = (remaining_time / 60) % 60
                let re_seconds = remaining_time % 60
                
                //            print(remaining_time)
                //            print("\(re_hours):\(re_minutes):\(re_seconds)")
                
                // assign the elapsed time to the label
                self.time_remaining = "\(re_hours):\(re_minutes):\(re_seconds)"
                
                // set the label
                self.lblTime.text = self.time_remaining
                
                
                
                // prevernt the user from posing if the time hasn't passed yet
                if remaining_time <= 0 {
                    self.btnSubmit.isEnabled = true
                    self.lblTime.text = "Ready!"
                }
            }
        }
    }
    
    func validateGPS(_ currentBuilding: String, _ lat: String, _ long: String) -> (Bool, String) {
        
        
        if (buildingsNoRewards.contains(currentBuilding)) {
            return(true, "no reward")
        }
        
        // TODO: change back to false
        if !(buildingsToCheck.contains(currentBuilding)) {
            return (false, "Sorry! We're not collecting data from that building at this moment, but thank you!");
        }
        
        let thisLat = Double(lat)
        let thisLong = Double(long)
        let buildingCoords = buildingCoordinates[currentBuilding]
        let buildingLat = Double(buildingCoords![0])
        let buildingLong = Double(buildingCoords![1])
        
//        print("thisLat is \(thisLat)")
//        print("thisLong is \(thisLong)")
//        print("buildingLat is \(buildingLat)")
//        print("buildingLong is \(buildingLong)")
        
        if thisLat == nil {
            return (false, "Your location hasn't updated yet, try closing and restarting the app or waiting a little please!")
        }
        
        if thisLong == nil {
            return (false, "Your location hasn't updated yet, try closing and restarting the app or waiting a little please!")
        }
        
        // TODO: change back to false
        if abs(thisLat! - buildingLat!) > self.gpsValidationDistance {
            return (true, "You're too far away from the building you're submitting info for! Move closer and try again.")
        }

        if abs(thisLong! - buildingLong!) > self.gpsValidationDistance {
            return (true, "You're too far away from the building you're submitting info for! Move closer and try again.")
        }
        
        return (true, "");
    }
    
    
    
    // submit is tapped
    @IBAction func actionSubmit(_ sender: UIButton) {
        
        
        
        // resign the responder
        self.textFieldRoom.resignFirstResponder()
        
        if CLLocationManager.locationServicesEnabled() {
            
           
        
        // submit the data to the server
        if let userId = Auth.auth().currentUser?.uid {
            
            
            
            if transactionsThisWeek < self.weeklyTransactionLimit {
            
            
            
            
            if let building = self.textFieldBuilding.text {
                
                if let floor = self.textFieldFloor.text {
                    
                    if let room = self.textFieldRoom.text {
                        
                        // limit the floor to 2 digits and room to 3 digits
                        if (floor.count > 2) || (room.count > 3) {
    
                            // raise the error
                            Utils.showAlertController(in: self, withTitle: "Invalid Floor or Room", andMessage: "Check your floor or room entry. \n - Format: FF.RRR -", andActionTitle: "OK")
                            
                        } else {
                            
                            if let shirtSleeve = self.shirtSegControl.titleForSegment(at: self.shirtSegControl.selectedSegmentIndex) {
                                
                                if let pantsLength = self.pantsSegControl.titleForSegment(at: self.pantsSegControl.selectedSegmentIndex) {
                                    
                                    if let jacketOn = self.jacketSegControl.titleForSegment(at: self.jacketSegControl.selectedSegmentIndex) {
                                    
                                    // get the date and calendar for the time
                                    let date = Date()
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: date)
                                    let minutes = calendar.component(.minute, from: date)
                                    let seconds = calendar.component(.second, from: date)
                                    
                                    var zeroNeededForSeconds = ""
                                    if seconds < 10 {
                                        zeroNeededForSeconds = "0"
                                    }
                                    
                                    var zeroNeededForMinutes = ""
                                    if minutes < 10 {
                                        zeroNeededForMinutes = "0"
                                    }
                                    
                                    var zeroNeededForHours = ""
                                    if hour < 10 {
                                        zeroNeededForHours = "0"
                                    }
                                    
                                    
                                    // format the time
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyyMMdd"
                                    let currentDate = formatter.string(from: date)

                                    
                                    
                                    
                                    if building != "" && room != "" {
                                        
                                        // create the record
                                        let personRecord = [
                                            "userId": "\(userId)",
                                            "date": "\(currentDate)",
                                            "date_time": "\(currentDate)" + zeroNeededForHours + "\(hour)" + zeroNeededForMinutes + "\(minutes)" + zeroNeededForSeconds + "\(seconds)",
                                            "time": zeroNeededForHours + "\(hour):" + zeroNeededForMinutes + "\(minutes)",
                                            "building": building,
                                            "room": "\(floor).\(room)",
                                            "room_comfort": String(self.roomSlider.value),
                                            "desired_room_temp": String(self.wantedRoomSlider.value),
                                            "shirt": shirtSleeve,
                                            "pants": pantsLength,
                                            "jacket": jacketOn,
                                            "lat": self.lat,
                                            "long": self.long]
                                        
                                        let tryValidateLocation = validateGPS(building, self.lat, self.long)
                                        if (!tryValidateLocation.0) {
                                            Utils.showAlertController(in: self, withTitle: "Oops!", andMessage: tryValidateLocation.1, andActionTitle: "OK")
                                        } else {
                                            // push the value to the server
                                            ref.child("Transaction").childByAutoId().setValue(personRecord) { (error, ref) in
                                                
                                                // show success
                                                Utils.showAlertController(in: self, withTitle: "We got your data!", andMessage: "Thank you for participating! Your response has been recorded!", andActionTitle: "OK")
                                                
                                                // reset the controls
                                                self.resetViewControls()
                                                self.btnSubmit.isEnabled = false
                                                
                                                // reset the timer
                                                self.update_time()
                                            }
                                            
                                            var newNumTransactions = self.currentNumTransactions + 1
                                            var newNumGlobalTransactions = self.globalNumTransactions + 1
                                            
                                            
                                            print(tryValidateLocation.1)
                                            if !(tryValidateLocation.1 == "no reward") {
                                                // update num transactions
                                                self.ref.child("UserData").child(userId).child("transactions").setValue("\(newNumTransactions)") { (error, ref) in
                                                    // error handling for the server response
                                                    if error == nil {
                                                        print("updating user and newnum is \(newNumTransactions)")
                                                        self.currentNumTransactions = newNumTransactions
                                                        print("new numTransactions is \(newNumTransactions)")
                                                    } else {
                                                        // show failure message
                                                        if let description = error?.localizedDescription {
                                                            Utils.showAlertController(in: self, withTitle: "Oops!", andMessage: description, andActionTitle: "Something went wrong")
                                                        }
                                                    }
                                                }
                                                
                                                
                                                self.ref.child("GlobalNumTransactions").child("-LaUOXipLj0TMkaae-g9") .setValue("\(newNumGlobalTransactions)") { (error, ref) in
                                                    // error handling for the server response
                                                    if error == nil {
                                                        self.globalNumTransactions = newNumGlobalTransactions
                                                        print("new globalNumTransactions is \(newNumGlobalTransactions)")
                                                    } else {
                                                        // show failure message
                                                        if let description = error?.localizedDescription {
                                                            Utils.showAlertController(in: self, withTitle: "Oops!", andMessage: description, andActionTitle: "Something went wrong")
                                                        }
                                                    }
                                                }
                                                
                                                
                                            }
                                            
                                    
                                            
                                        }
                                    } else {
                                        // show error
                                        Utils.showAlertController(in: self, withTitle: "No data entered!", andMessage: "Building and room can't be empty, buddy!", andActionTitle: "OK")
                                    }
                                }
                                }
                            }// end else
                            }
                        }
                    }
                }
            } else {
                Utils.showAlertController(in: self, withTitle: "Sorry!", andMessage: "You've hit the weekly limit for submissions", andActionTitle: "OK")
            }
        }
            
        } else {
            Utils.showAlertController(in: self, withTitle: "Location services disabled", andMessage: "Please enable location services", andActionTitle: "OK")
        }
    }
    
    // clear the fields
    func resetViewControls() -> Void {
        self.textFieldBuilding.text = ""
        self.textFieldFloor.text = ""
        self.textFieldRoom.text = ""
        self.roomSlider.value = 0
        self.wantedRoomSlider.value = 0
        self.shirtSegControl.selectedSegmentIndex = 0
        self.pantsSegControl.selectedSegmentIndex = 0
        self.jacketSegControl.selectedSegmentIndex = 0
    }
    
    // dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // action for the uiview touch
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    // location delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        while(!CLLocationCoordinate2DIsValid(locValue)) {
            
        }
        
        self.lat = String(locValue.latitude)
        self.long = String(locValue.longitude)
        
//        print("!!!!!", self.lat)
//        print("!!!!!", self.long)

    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//
//        let location = locations.last! as CLLocation
//
//        /* you can use these values*/
//        self.lat = String(location.coordinate.latitude)
//        self.long = String(location.coordinate.longitude)
//    }
    
    // building picker
    func createBuildingPicker() {
        let buildingPicker = UIPickerView()
        buildingPicker.delegate = self
        
        textFieldBuilding.inputView = buildingPicker
    }
    
    // UIPickerView delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return buildingsToCheck.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return buildingsToCheck[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBuilding = buildingsToCheck[row]
        textFieldBuilding.text = selectedBuilding
    }
    
    // toolbar for input picker view
    func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textFieldBuilding.inputAccessoryView = toolBar
    }
}
