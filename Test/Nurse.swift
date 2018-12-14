//
//  Nurse.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import Foundation

class Nurse:Provider{
    
    init(firstName: String, lastName: String, employeeID: Int){
        super.init()
        self.setName(firstName, lastName: lastName)
        self.setID(employeeID)
    }
}