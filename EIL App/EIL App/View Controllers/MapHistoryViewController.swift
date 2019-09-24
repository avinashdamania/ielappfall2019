//
//  MapHistoryViewController.swift
//  EIL App
//
//  Created by Henry Vuong on 4/20/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI
import Firebase
import FirebaseDatabase
import Foundation

class MapHistoryViewController: UIViewController, MKMapViewDelegate {

    // properties
    @IBOutlet weak var mapView: MKMapView!
    
    // database reference
    let ref = Database.database().reference()
    var records: [Record] = []
    var personal_records: [Record] = []
    var acceptedHours: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // define the region
        let UTRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(30.284496, -97.737897),
                                              MKCoordinateSpanMake(0.005, 0.005))
        mapView.setRegion(UTRegion, animated: false)
        mapView.delegate = self
        
        ref.child("MapViewUserAverageTimeLimit").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let history_records = value {
                for hr in history_records {
                    let record = hr.value as! String
                    self.acceptedHours = Int(record)!
                    
                }
            }
        }
        
        
        
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
                    let time = record["date_time"]
                    
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
            self.populateMapView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func comfortDescriptor(_ num: Double) -> String {
        if (num >= -3.0 && num < -2.5) {
            return "very cold"
        } else if (num < -1.5) {
            return "somewhat cold"
        } else if (num < -0.5) {
            return "slightly cold"
        } else if (num < 0.5) {
            return "average"
        } else if (num < 1.5) {
            return "slightly warm"
        } else if (num < 2.5) {
            return "somewhat warm"
        } else if (num <= 3.0) {
            return "very warm"
        } else {
            return "Error retrieving average user comfort level for this building"
        }
        
    }
    
    // populates mapview with pins based on history of inputs
    func populateMapView() {
        
        for record in personal_records {
            let latitude = NSNumber(value: Double(record.lat!)!)
            let longitude = NSNumber(value: Double(record.long!)!)
            
            
            let tempComfort: String = String(format: "%.2f", Double(record.comfort!)!)
            let avg = averageUserComfortLevel(record.building!)
            let tempAvg: String = String(format: "%.2f", avg)
            
            let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(truncating: latitude), longitude: CLLocationDegrees(truncating: longitude))
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            annotation.title = "\(String(describing: record.building!)) Comfort Level: \(String(describing: tempComfort))"
            
            annotation.subtitle = "Most users feel \(comfortDescriptor(avg)) (average: \(tempAvg))"
            mapView.addAnnotation(annotation)
            
        }
    }
    
    func validateDate(_ string1: String) -> Bool {
        
        let formatter_from = DateFormatter()
        formatter_from.dateFormat = "yyyyMMddHHmmss"
        let post_date = formatter_from.date(from: string1)
        let defaultDate = NSDate()
        let time_inteval = NSDate().timeIntervalSince(post_date ?? defaultDate as Date)
        let acceptedSeconds = self.acceptedHours * 3600
        let remaining_time =  acceptedSeconds - Int(ceil(time_inteval))
        return remaining_time <= 0
    }
    
    func averageUserComfortLevel(_ building: String) -> Double {
        var sum = 0.0
        var count = 0.0
        
        for record in records {
            if (record.building == building && validateDate(record.time!)) {
                sum += Double(record.comfort!)!
                count += 1
            }
        }
        if (count == 0) {
            return -1
        }
        return sum / count
    }
    
    
    // mapview delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        return annotationView
    }
}
