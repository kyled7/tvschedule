//
//  Show.swift
//  TV Schedule
//
//  Created by Kyle Dinh on 3/18/16.
//  Copyright © 2016 Kyle Dinh. All rights reserved.
//

import Foundation
struct Show {
    let name: String
    let time: String
    let additional: String?
    
    init(name: String, time: String, additional:String?) {
        self.name = name
        self.time = time
        self.additional = additional
    }
}
