//
//  setPatient.swift
//  AdvagrafApp
//
//  Created by Steven Armstrong on 2018-12-12.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import Foundation

func setPatient(patObject:[String: AnyObject]) -> Patient {
    
    let patFirstName  = patObject["firstName"]
    let patLastName  = patObject["lastName"]
    let patDOB  = patObject["DOB"]
    let patAlert = patObject["alert"]
    let patientID = patObject["userID"]
    
    let patDoctorID  = patObject["doctorID"]
    let patDoctorName  = patObject["doctorName"]
    //let patientID  = patObject?["userID"]
    
    let tempPatient = Patient(firstName: patFirstName as! String, lastName: patLastName as! String, DOB: patDOB as! String, doctorID: patDoctorID as! String, doctorName: patDoctorName as! String)
    
    tempPatient.setPatientID(patientID as! String)
    tempPatient.setAlert(state: Bool(patAlert as! String)!)
    
    if let patMRN  = patObject["MRN"] as? String {
        tempPatient.setMRN(patMRN)
    }
    
    if let patTransDate  = patObject["transDate"] as? String {
        tempPatient.setTransDate(patTransDate)
    }
    
    if let patlastBloodResult  = patObject["lastBloodResult"] as? String {
        if let patDateBloodResult  = patObject["dateOfBloodResult"] as? String {
            tempPatient.setBloodResult(Float(patlastBloodResult)!, entryDate: patDateBloodResult)
        }
    }
    
    if let patBloodLow  = patObject["bloodRangeLow"] as? String {
        if let patBloodHigh  = patObject["bloodRangeHigh"] as? String {
            tempPatient.setBloodWorkRange(Float(patBloodLow)!, bloodWorkHigher: Float(patBloodHigh)!)
        }
    }
    
    //THIS DATE IS WRONG, FIX ME!!!!!!!!!!
    if let patLastAdvagrafDose  = patObject["lastAdvagrafDose"] as? String {
        tempPatient.setAdvagrafDose(Float(patLastAdvagrafDose)!, entryDate: "")
    }
    
    return tempPatient
}
