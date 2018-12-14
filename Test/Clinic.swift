//
//  Clinic.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import Foundation

class Clinic {
    var clinicName:String
    var nurses:[Nurse] = []
    var doctors:[Doctor] = []
    
    init(clinicName:String){
        self.clinicName = clinicName
    }
    
    func addNurse(_ firstName: String, lastName: String, employeeID: Int){
        let nurse = Nurse(firstName: firstName, lastName: lastName, employeeID: employeeID)
        self.nurses.append(nurse)
    }
    
    func addDoctor(_ firstName: String, lastName: String, employeeID: Int){
        let doctor = Doctor(firstName: firstName, lastName: lastName, employeeID: employeeID)
        self.doctors.append(doctor)
    }
}
