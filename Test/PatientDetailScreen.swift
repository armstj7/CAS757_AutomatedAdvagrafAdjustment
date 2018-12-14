//
//  PatientDetailScreen.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PatientDetailScreen: UIViewController {

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientDOBLabel: UILabel!
    @IBOutlet weak var patientMRNLabel: UILabel!
    @IBOutlet weak var patientDateofTransLabel: UILabel!
    
    @IBOutlet weak var resultDateLabel: UILabel!
    @IBOutlet weak var resultCurrentLabel: UILabel!
    @IBOutlet weak var resultRangeLabel: UILabel!
    
    @IBOutlet weak var advagrafDoseLabel: UILabel!
    @IBOutlet weak var doseAlertLabel: UILabel!
    @IBOutlet weak var doseSuggestionLabel: UILabel!
    
    @IBOutlet weak var acceptDoseButton: UIButton!
    @IBOutlet weak var declineDoseButton: UIButton!
    
    var patient: Patient?
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarController
        self.patient = tabBar.patient
        
        updateView()
        //self.patient = setPatient(patObje)(tabBar.patient?.patientID)

        
        // Do any additional setup after loading the view.
    }
    
    func updateView(){
        ref = Database.database().reference()
        
        ref?.child("Patients").child((self.patient?.patientID)!).observe(.value, with: {(snapshot) in
            
            let patObject = snapshot.value as? [String: AnyObject]
            
            let tempPatient = setPatient(patObject: patObject!)
            
            self.patient = tempPatient
            
            DispatchQueue.main.async {
                self.setUI()
            }
            
        })
    }
    
    func setUI(){
        patientNameLabel.text = patient?.getName()
        patientDOBLabel.text = "Date of Birth: " + patient!.DOB
        patientMRNLabel.text = "OHIP: " + patient!.MRN
        patientDateofTransLabel.text = "Date of Transplant: " + patient!.transplantDate
        
        if(!patient!.bloodWorkResults.isEmpty){
            resultDateLabel.text = patient!.bloodWorkResults[0].entryDate
            resultCurrentLabel.text = (NSString(format: "%.1f",patient!.bloodWorkResults[0].result) as String) + "ng/mL"
        } else {
            resultDateLabel.text = ""
            resultCurrentLabel.text = "__ ng/L"
        }
        
        if(patient!.bloodWorkLower==0 && patient!.bloodWorkHigher==0){
            resultRangeLabel.text = "__ - __ ng/L"
        } else {
            resultRangeLabel.text = (NSString(format: "%.1f",patient!.bloodWorkLower) as String) + " - " + (NSString(format: "%.1f",patient!.bloodWorkHigher) as String) + "ng/mL"
        }
        
        if(!patient!.advagrafDoses.isEmpty){
            advagrafDoseLabel.text = (NSString(format: "%.1f",patient!.advagrafDoses[0].doseInMG) as String) + "mg"
        } else {
            advagrafDoseLabel.text = "__ mg"
        }
        
        if(!((patient?.getAlert())!)){
            self.hideAlert()
        } else {
            self.showAlert()
        }
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        patient?.addAdvagrafDose((patient?.suggestedDose())!, entryDate: getNow())
        updateView()
    }

    @IBAction func declineTapped(_ sender: Any) {
        patient?.declineDoseChange(entryDate: getNow())
        updateView()
    }
    
    @IBAction func enterResultTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ResultSegue", sender: self.patient)
    }
    
    @IBAction func updateRangeTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "RangeSegue", sender: self.patient)
    }
    
    @IBAction func adjustDoseTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "DoseSegue", sender: self.patient)
    }
    
    func hideAlert(){
        acceptDoseButton.isHidden = true
        declineDoseButton.isHidden = true
        doseAlertLabel.text = ""
        doseSuggestionLabel.text = ""
    }
    
    func showAlert(){
        acceptDoseButton.isHidden = false
        declineDoseButton.isHidden = false
        doseAlertLabel.text = "ALERT!"
        doseSuggestionLabel.text = "Suggestion: Change dose to " + (NSString(format: "%.1f",(patient?.suggestedDose())!) as String) + "mg"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultSegue" {
            let destVC = segue.destination as! EnterResultVC
            destVC.patient = sender as? Patient
        } else if segue.identifier == "DoseSegue" {
            let destVC = segue.destination as! EnterDoseVC
            destVC.patient = sender as? Patient
        } else if segue.identifier == "RangeSegue" {
            let destVC = segue.destination as! EnterRangeVC
            destVC.patient = sender as? Patient
        }
        
    }
    
    
    
}
