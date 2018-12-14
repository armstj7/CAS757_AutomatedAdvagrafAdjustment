//
//  PhysNotifScreen.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PhysNotifScreen: UIViewController {
    
    @IBOutlet weak var notifTableView: UITableView!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    
    var notifs: [Notification] = []
    var patient:Patient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNotifArray()
        //notifs = createNotifArray()
        // Do any additional setup after loading the view.
    }

    func createNotifArray(){
        
        ref = Database.database().reference()
        
        databaseHandle = ref?.child("Notifications").child("1").observe(.value, with: {(snapshot) in
            var tempNotifs: [Notification] = []
            
            for notif in snapshot.children.allObjects as! [DataSnapshot] {
                //getting values
                let notifObject = notif.value as? [String: AnyObject]
                print(notifObject)
                
                if let doseObject = notifObject?["doseType"] as? [String: AnyObject] {
                    let notifText  = doseObject["text"]
                    let patientID  = doseObject["patientID"]
                    let dose = doseObject["dose"]
                    
                    let tempNotif = Notification(notifStr: notifText as! String, type: "dose", patientID: patientID as! String)
                    tempNotif.setDose(dose: Float(dose as! String)!)
                    tempNotifs.append(tempNotif)
                }
                
                if let rangeObject = notifObject?["rangeType"] as? [String: AnyObject] {
                    let notifText  = rangeObject["text"]
                    let patientID  = rangeObject["patientID"]
                    let rangeLow = rangeObject["rangeLow"]
                    let rangeHigh = rangeObject["rangeHigh"]
                    
                    let tempNotif = Notification(notifStr: notifText as! String, type: "range", patientID: patientID as! String)
                    tempNotif.setRange(rangeLow: Float(rangeLow as! String)!, rangeHigh: Float(rangeHigh as! String)!)
                    tempNotifs.append(tempNotif)
                }
                
            }
            
            self.notifs = tempNotifs
            
            DispatchQueue.main.async {
                self.notifTableView.reloadData()
            }
            
            //return tempNotifs
        })
    }
    
    func removeNotif(index:Int) {
        ref = Database.database().reference()
        
        ref?.child("Notifications").child("1").child(notifs[index].patientID).removeValue()
    }
    
    func updateValue(index:Int, attribute:String, value:String){
        ref = Database.database().reference()
        
        ref?.child("Patients").child(notifs[index].patientID).updateChildValues([attribute: value])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NotifSegue" {
            let destVC = segue.destination as! TabBarController
            destVC.patient = sender as? Patient
        }
    }

}

extension PhysNotifScreen: PhysNotifCellDelegate {
    func didTapAccept(_ cellIndex: Int){
        updateValue(index: cellIndex, attribute:"lastAdvagrafDose", value: String(notifs[cellIndex].dose))
        updateValue(index: cellIndex, attribute: "alert", value: "false")
        removeNotif(index: cellIndex)
        
        var ref:DatabaseReference?
        
        var tempString = "Dilys Derwent"
        
        tempString += " changed the dose to "
        tempString += String(String(notifs[cellIndex].dose)) + "mg"
        tempString += " on " + getNow()
        
        let history = ["text": tempString]
        
        ref = Database.database().reference().child("History").child(notifs[cellIndex].patientID).childByAutoId()
        ref?.setValue(history)
        
        
        notifs.remove(at: cellIndex)
        notifTableView.reloadData()
        
    }
    
    func didTapDecline(_ cellIndex: Int){
        updateValue(index: cellIndex, attribute: "alert", value: "false")
        removeNotif(index: cellIndex)
        
        var ref:DatabaseReference?
        var tempString = "Dilys Derwent"
        
        tempString += " declined changing the dose"
        tempString += " on " + getNow()
        
        let history = ["text": tempString]
        
        ref = Database.database().reference().child("History").child(notifs[cellIndex].patientID).childByAutoId()
        ref?.setValue(history)
        
        notifs.remove(at: cellIndex)
        notifTableView.reloadData()
        
    }
    
    func didTapSeePat(_ cellIndex: Int) {
        
        ref = Database.database().reference()
        
        ref?.child("Patients").child(notifs[cellIndex].patientID).observeSingleEvent(of: .value, with: {(snapshot) in
            
            let patObject = snapshot.value as? [String: AnyObject]
            
            let tempPatient = setPatient(patObject: patObject!)
            
            self.patient = tempPatient
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "NotifSegue", sender: self.patient)
            }
            
        })
    }
}

extension PhysNotifScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notif = notifs[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhysNotifCell") as! PhysNotifCell
        
        cell.setNotif(notif, cellIndex: (indexPath as NSIndexPath).row)
        cell.delegate = self
        
        return cell
    }
}

    
