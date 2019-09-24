//
//  Bounty.swift
//  EIL App
//
//  Created by STEPAN ULYANIN on 4/12/18.
//  Copyright © 2018 STEPAN ULYANIN. All rights reserved.
//

import Foundation

class Bounty {
    
    // props
    let id: String
    let building: String
    let floor: String
    let value: String

    // init
    init(withId id: String, andBuilding building: String, andFloor floor: String, withValue value: String) {
        self.id = id
        self.building = building
        self.floor = floor
        self.value = value
    }
    
}
