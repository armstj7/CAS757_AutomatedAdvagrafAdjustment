//
//  Notification.swift
//  AdvagrafApp
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import Foundation

class Notification{
    var notifStr: String
    var type:String
    var patientID:String
    var dose:Float = 0
    var rangeLow:Float = 0
    var rangeHigh:Float = 0
    
    init(notifStr:String, type:String, patientID:String){
        self.notifStr = notifStr
        self.type = type
        self.patientID = patientID
    }
    
    func setDose(dose:Float){
        self.dose = dose
    }
    
    func setRange(rangeLow:Float, rangeHigh:Float){
        self.rangeLow = rangeLow
        self.rangeHigh = rangeHigh
    }
    
    func acceptNotif(patient: Patient){
        //update patient values
        if(type=="dose"){
            patient.addAdvagrafDose(dose, entryDate: "")
        } else {
            patient.setBloodWorkRange(rangeLow, bloodWorkHigher: rangeHigh)
        }
        
        //remove warning
        
        //add to patient history
        
    }
    
    func declineNotif(){
        //remove warning
        
        //add to patient history
        
    }
    
    func addNotif(patient: Patient, rangeLow:Float, rangeHigh:Float){
        //create text
        
        //write to database
        
    }

    func addNotif(patient: Patient, dose:Float){
        //create text
        
        //write to database
        
    }
    
}
