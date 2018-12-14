//
//  PatientHistoryScreen.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PatientHistoryScreen: UIViewController {
    
    @IBOutlet weak var patHistTableView: UITableView!
    
    @IBOutlet weak var patientDOBLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientMRNLabel: UILabel!
    @IBOutlet weak var patientDateofTransLabel: UILabel!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var histories: [History] = []
    var patient:Patient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarController
        self.patient = tabBar.patient
        
        setUI()
        
        createHistArray()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        patientNameLabel.text = patient?.getName()
        patientDOBLabel.text = "Date of Birth: " + patient!.DOB
        patientMRNLabel.text = "OHIP: " + patient!.MRN
        patientDateofTransLabel.text = "Date of Transplant: " + patient!.transplantDate
        
    }
    
    func createHistArray() {
        
        ref = Database.database().reference()
        
        ref?.child("History").child(patient.patientID).observe(.value, with: { (snapshot) in
            var tempHists: [History] = []
            
            for history in snapshot.children.allObjects as! [DataSnapshot] {
                //getting values
                let historyObject = history.value as? [String: AnyObject]
                let text = historyObject?["text"]
                
                let tempHist = History(histStr: text as! String)
                tempHists.append(tempHist)
            }
            
            self.histories = tempHists
            
            DispatchQueue.main.async {
                self.patHistTableView.reloadData()
            }
        })
    }
}


extension PatientHistoryScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let history = histories[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatHistCell") as! PatHistCell
        
        cell.setHist(history)
        
        return cell
    }
}


