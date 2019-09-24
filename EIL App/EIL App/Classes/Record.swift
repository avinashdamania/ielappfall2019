//
//  Record.swift
//  EIL App
//
//  Created by STEPAN ULYANIN on 4/13/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import Foundation

class Record {
    
    public var building: String?
    public var date: String?
    public var room: String?
    public var id: String?
    public var lat: String?
    public var long: String?
    public var comfort: String?
    public var time: String?
    
    init(submittedBy id: String, inBuilding building: String, inRoom room: String, atDate date: String, atTime time: String, atLat lat: String, atLong long: String, comfortLevel comfort: String) {
        self.id = id
        self.building = building
        self.room = room
        self.date = date
        self.lat = lat
        self.long = long
        self.comfort = comfort
        self.time = time
    }
}
