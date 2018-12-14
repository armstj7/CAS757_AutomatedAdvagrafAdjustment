//
//  Doctor.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import Foundation

class Doctor:Provider{
    var patients:[Patient] = []
    
    init(firstName: String, lastName: String, employeeID: Int){
        super.init()
        self.setName(firstName, lastName: lastName)
        self.setID(employeeID)
    }
    
    
    func addPatient(_ firstName: String, lastName: String, DOB: String, MRN: String, transplantDate: String, bloodWorkLower:Float, bloodWorkHigher: Float){
        /*let patient = Patient(firstName: firstName, lastName: lastName, DOB: DOB, doctorID: String(self.employeeID))
        
        patient.setMRN(MRN)
        patient.setTransDate(transplantDate)
        patient.setBloodWorkRange(bloodWorkLower, bloodWorkHigher: bloodWorkHigher)
        
        self.patients.append(patient)*/
    }
}
