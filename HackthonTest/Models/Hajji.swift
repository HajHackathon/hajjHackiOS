//
//  Hajji.swift
//  HackthonTest
//
//  Created by Qahtan on 8/1/18.
//  Copyright © 2018 QahtanLab. All rights reserved.
//

import UIKit
class Hajji: NSObject {
    let caseS : Int
    let uid : String
    let loction : [Double]
    
    init(uid: String,location:[Double],casee:Int) {
        self.uid = uid
        self.loction = location
        self.caseS = casee
    }
}
