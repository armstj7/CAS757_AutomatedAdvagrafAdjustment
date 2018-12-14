//
//  Patient.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-26.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

/*
import Foundation

class Patient {
    
    var name: String
    var DOB: String
    
    init(name:String, DOB:String){
        self.name = name
        self.DOB = DOB
    }
}
*/

import UIKit
import FirebaseDatabase

class Patient:Person{
    var DOB:String
    var MRN:String = ""
    var transplantDate:String = ""
    var doctorID:String
    var doctorName:String
    var bloodWorkLower:Float = 0
    var bloodWorkHigher:Float = 0
    
    var patientID = ""
    var alert:Bool = false
    
    var advagrafDoses:[Dose] = []
    var bloodWorkResults:[BloodWorkResult] = []
    var historyEvents:[HistoryEvent] = []
    var doctorNotifcations:[DoctorNotification] = []
    
    init(firstName: String, lastName:String, DOB: String, doctorID:String, doctorName:String){
        self.DOB = DOB
        self.doctorID = doctorID
        self.doctorName = doctorName
        super.init()
        self.setName(firstName, lastName: lastName)
    }
    
    func setMRN(_ MRN: String){
        self.MRN = MRN
    }
    
    func setPatientID(_ patientID: String){
        self.patientID = patientID
    }
    
    func setTransDate(_ transplantDate: String){
        self.transplantDate = transplantDate
    }
    
    func setBloodWorkRange(_ bloodWorkLower:Float, bloodWorkHigher: Float){
        self.bloodWorkLower = bloodWorkLower
        self.bloodWorkHigher = bloodWorkHigher
    }
    
    func setBloodWorkRange(_ bloodWorkBoundary:Float, high:Int){
        if(high==0){
            self.bloodWorkLower = bloodWorkBoundary
        }else{
            self.bloodWorkHigher = bloodWorkBoundary
        }
    }
    
    func setAdvagrafDose(_ doseInMG:Float, entryDate:String){
        let advagrafDose = Dose(doseInMG: doseInMG, entryDate: entryDate)
        self.advagrafDoses.insert(advagrafDose, at: 0)
    }
    
    func addAdvagrafDose(_ doseInMG:Float, entryDate:String){
        var ref:DatabaseReference?
        
        let advagrafDose = Dose(doseInMG: doseInMG, entryDate: entryDate)
        
        self.advagrafDoses.insert(advagrafDose, at: 0)
        
        self.updateValue(attribute:"lastAdvagrafDose", value: String(doseInMG))
        self.updateValue(attribute: "alert", value: "false")
        
        ref = Database.database().reference()
        ref?.child("Notifications").child(self.doctorID).child(self.patientID).removeValue()
        
        self.addHistoryEvent(doctorName, action: "changed dose", entryDate: getNowTimestamp())
    }
    
    func declineDoseChange(entryDate:String){
        var ref:DatabaseReference?
        
        self.updateValue(attribute: "alert", value: "false")
        
        ref = Database.database().reference()
        ref?.child("Notifications").child(self.doctorID).child(self.patientID).removeValue()
        
        self.addHistoryEvent(doctorName, action: "declined dose", entryDate: getNowTimestamp())
    }
    
    func setBloodResult(_ result:Float, entryDate:String){
        let bloodWorkResult = BloodWorkResult(result: result, entryDate: entryDate)
        self.bloodWorkResults.insert(bloodWorkResult, at: 0)
    }
    
    func addBloodResult(_ result:Float, entryDate:String){
        let bloodWorkResult = BloodWorkResult(result: result, entryDate: entryDate)
        self.bloodWorkResults.insert(bloodWorkResult, at: 0)
        self.updateValue(attribute: "lastBloodResult", value: String(result))
        self.updateValue(attribute: "dateOfBloodResult", value: entryDate)
        self.addHistoryEvent(doctorName, action: "changed result", entryDate: getNowTimestamp())
        
        if !self.inRange() {
            self.updateValue(attribute: "alert", value: "true")
            self.addDoseChangeNotif("The app", dateSuggested: getNow(), newDose: self.suggestedDose())
            self.addHistoryEvent("The app", action: "suggested dose", entryDate: getNowTimestamp())
        }
    }
    
    func addHistoryEvent(_ actor:String, action:String, entryDate:String){
        var ref:DatabaseReference?
        
        //create text
        var tempString = actor
        switch action {
        case "suggested dose":
            tempString += " suggested changing the dose to "
            tempString += String(self.suggestedDose()) + "mg"
        break
        
        case "changed dose":
            tempString += " changed the dose to "
            tempString += String(self.advagrafDoses[0].doseInMG) + "mg"
        break
        
        case "declined dose":
            tempString += " declined changing the dose"
        break
        
        case "changed range":
            tempString += " changed the blood test range to "
            tempString += String(self.bloodWorkLower) + "-"
            tempString += String(self.bloodWorkHigher) + "ng/L"
        break
        
        case "changed result":
            tempString += " entered the new blood test result of "
            tempString += String(self.bloodWorkResults[0].result) + "ng/L"
        break
            
        default:
        break
        }
        
        tempString += " on " + getNow()
        
        let history = ["text": tempString]
        
        ref = Database.database().reference().child("History").child(self.patientID).childByAutoId()
        ref?.setValue(history)
    }
    
    func addDoseChangeNotif(_ suggester:String, dateSuggested:String, newDose:Float){
        var ref:DatabaseReference?
        
        //create text
        var tempString = suggester
        tempString += " suggested changing the Advagraf dose for "
        tempString += String(self.getName())
        tempString += " from " + String(self.advagrafDoses[0].doseInMG)
        tempString += " to " +  String(newDose)
        tempString += " on " + getNow()
        
        let notification = [
            "text": tempString,
            "dose": String(newDose),
            "patientID": self.patientID
        ]
        
        ref = Database.database().reference().child("Notifications").child(self.doctorID).child(self.patientID).child("doseType")
        ref?.setValue(notification)
        
    }
    
    func addRangeUpdateNotif(_ suggester:String, suggestType:Character, dateSuggested:String, newRangeLow:Float, newRangeHigh:Float){
        let doctorNotification = DoctorNotification(suggester: suggester, suggestType: suggestType, dateSuggested: dateSuggested, newRangeLow: newRangeLow, newRangeHigh: newRangeHigh)
        self.doctorNotifcations.insert(doctorNotification, at: 0)
    }
    
    func inRange() -> Bool {
        if(bloodWorkResults.isEmpty){
            return true
        } else {
            if(bloodWorkResults[0].result>=bloodWorkLower && bloodWorkResults[0].result<=bloodWorkHigher){
                return true
            } else {
                return false
            }
        }
    }
    
    func setAlert(state:Bool){
        self.alert = state
    }
    
    func getAlert() -> Bool {
        return self.alert
    }
    
    func suggestedDose() -> Float {
        let midRange = (bloodWorkLower + bloodWorkHigher)/2
        let adjustment:Float = (midRange/bloodWorkResults[0].result)
        
        var suggestedDose = round(adjustment*advagrafDoses[0].doseInMG*2)/2
        
        if (suggestedDose>25){
           suggestedDose = 25
        }
        
        
        return suggestedDose
    }
    
    func hasDoctorNotification() -> Bool {
        if (doctorNotifcations.isEmpty) {
            return false
        } else {
            for rows in 0 ..< doctorNotifcations.count {
                if(!doctorNotifcations[rows].approved){
                    return true
                }
            }
            return false
        }
    }
    
    //change to returning only indices??
    func getDoctorNotification() -> [DoctorNotification] {
        var tempNotification:[DoctorNotification] = []
        
        if !(doctorNotifcations.isEmpty) {
            for rows in 0 ..< doctorNotifcations.count {
                if(!doctorNotifcations[rows].approved){
                    tempNotification.append(doctorNotifcations[rows])
                }
            }
        }
        
        return tempNotification
    }
    
    func getPatientHistory() -> [String] {
        var tempStringArr:[String] = []
        
        for rows in 0..<historyEvents.count{
            tempStringArr.append(historyEvents[rows].getHistory())
        }
        
        return tempStringArr
    }
    
    func updateValue(attribute:String, value:String){
        var ref:DatabaseReference?
        
        ref = Database.database().reference()
        ref?.child("Patients").child(self.patientID).updateChildValues([attribute: value])
    }
}

class Dose {
    var doseInMG:Float
    var entryDate:String
    
    init(doseInMG:Float, entryDate:String){
        self.doseInMG = doseInMG
        self.entryDate = entryDate
    }
}

class BloodWorkResult {
    var result:Float
    var entryDate:String
    
    init(result:Float, entryDate:String){
        self.result = result
        self.entryDate = entryDate
    }
}

class HistoryEvent {
    var actor:String
    var actorType:Character
    var action:String
    var entryDate:String
    
    init(actor:String, actorType:Character, action:String, entryDate:String){
        self.actor = actor
        self.actorType = actorType
        self.action = action
        self.entryDate = entryDate
    }
    
    func getHistory () -> String {
        return (actor +  " " + action + " on " + entryDate)
    }
}

class DoctorNotification {
    var approved:Bool = false
    var suggester:String
    var suggestType:Character
    var dateSuggested:String
    
    var rangeChange:Bool = false
    var newRangeLow:Float = 0
    var newRangeHigh:Float = 0
    
    var doseChange:Bool = false
    var newDose:Float = 0
    
    init(suggester:String, suggestType:Character, dateSuggested:String, newRangeLow:Float, newRangeHigh:Float){
        self.suggester = suggester
        self.suggestType = suggestType
        self.dateSuggested = dateSuggested
        self.rangeChange = true
        self.newRangeLow = newRangeLow
        self.newRangeHigh = newRangeHigh
    }
    
    init(suggester:String, suggestType:Character, dateSuggested:String, newDose:Float){
        self.suggester = suggester
        self.suggestType = suggestType
        self.dateSuggested = dateSuggested
        self.doseChange = true
        self.newDose = newDose
    }
    
    func getNotification (_ patient:Patient) -> String {
        var tempString:String = ""
        
        tempString += suggester + " "
        
        if(doseChange){
            tempString += "changed the Advagraf dose for "
            tempString += patient.getName()
            tempString += " from " + (newRangeLow).description
            tempString += " to " + (newRangeHigh).description
        } else if (rangeChange) {
            
        }
        
        tempString += "on " + dateSuggested
        
        return tempString
    }
}


