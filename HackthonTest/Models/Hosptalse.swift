//
//  Hosptalse.swift
//  HackthonTest
//
//  Created by Qahtan on 8/2/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
class Hospital: NSObject {
    
    let name: String
    let lat: Double
    let lng: Double
    
    init(name:String,lat:Double,lng:Double) {
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}
