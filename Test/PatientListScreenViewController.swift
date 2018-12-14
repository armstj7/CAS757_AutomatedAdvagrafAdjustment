//
//  PatientListScreenViewController.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-26.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PatientListScreenViewController: UIViewController {

    @IBOutlet weak var patientTableView: UITableView!
    @IBOutlet weak var patientSearchBar: UISearchBar!
    
    var patients: [Patient] = []
    var allPatients: [Patient] = []
    var searching:Bool = false
    var filtering:Bool = false
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    var postData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createPatientArray()
        
        /*
        var tempPatients: [Patient] = []
        let patient1 = Patient(firstName: "Harry", lastName:  "Potter", DOB: "June 05, 1980")
        let patient2 = Patient(firstName: "Hermione", lastName: "Granger", DOB: "Sept 19, 1979")
        let patient3 = Patient(firstName: "Ron", lastName: "Weasley", DOB: "Mar 1, 1980")
        let patient4 = Patient(firstName: "Albus", lastName: "Dumbledore", DOB: "August 8, 1881")
        let patient5 = Patient(firstName: "Minerva", lastName: "McGonagall", DOB: "c")
        
        tempPatients.append(patient1)
        tempPatients.append(patient2)
        tempPatients.append(patient3)
        tempPatients.append(patient4)
        tempPatients.append(patient5)
        
        self.allPatients = tempPatients
        self.patients = tempPatients
    */
        
    }

    func createPatientArray(){
        /*
        let patient1 = Patient(firstName: "Harry", lastName:  "Potter", DOB: "June 05, 1980")
         let patient2 = Patient(firstName: "Hermione", lastName: "Granger", DOB: "Sept 19, 1979")
         let patient3 = Patient(firstName: "Ron", lastName: "Weasley", DOB: "Mar 1, 1980")
         let patient4 = Patient(firstName: "Albus", lastName: "Dumbledore", DOB: "August 8, 1881")
         let patient5 = Patient(firstName: "Minerva", lastName: "McGonagall", DOB: "Oct 04, 1935")
         
         tempPatients.append(patient1)
         tempPatients.append(patient2)
         tempPatients.append(patient3)
         tempPatients.append(patient4)
         tempPatients.append(patient5)
         */
        
        ref = Database.database().reference()
        //get all patient data
        
        databaseHandle = ref?.child("Patients").observe(.value, with: {(snapshot) in
            var tempPatients: [Patient] = []
            
            for pat in snapshot.children.allObjects as! [DataSnapshot] {
                //getting values
                let patObject = pat.value as? [String: AnyObject]
                let tempPatient = setPatient(patObject: patObject!)
                tempPatients.append(tempPatient)
            }
            
            self.allPatients = tempPatients
            self.patients = tempPatients
            
            DispatchQueue.main.async {
                self.patientTableView.reloadData()
            }
            
        })
    }
    
    func filterPatientArray(allPatients: [Patient]) -> [Patient] {
        var tempPatients: [Patient] = []
        
        for patIndex in 0 ..< allPatients.count {
            if(allPatients[patIndex].getAlert()){
                tempPatients.append(allPatients[patIndex])
            }
        }
        
        /*
        let patient1 = Patient(firstName: "Harry", lastName:  "Potter", DOB: "June 05, 1980")
        let patient2 = Patient(firstName: "Hermione", lastName: "Granger", DOB: "Sept 19, 1979")
        let patient3 = Patient(firstName: "Ron", lastName: "Weasley", DOB: "Mar 1, 1980")
        
        tempPatients.append(patient1)
        tempPatients.append(patient2)
        tempPatients.append(patient3)
        */
        
        return tempPatients
    }

    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            filtering = false
            patients = allPatients
            
            if searching {
                patients = performPatientSearch()
            }
            
            UIView.transition(with: patientTableView, duration: 0.35, options: .transitionCrossDissolve , animations: {() -> Void in self.patientTableView.reloadData()}, completion: nil)
            //patientTableView.reloadData()
        default:
            filtering = true
            patients = filterPatientArray(allPatients: allPatients)
            
            if searching {
                patients = performPatientSearch()
            }
            UIView.transition(with: patientTableView, duration: 0.35, options: .transitionCrossDissolve , animations: {() -> Void in self.patientTableView.reloadData()}, completion: nil)
            //patientTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PatientSegue" {
            let destVC = segue.destination as! TabBarController
            destVC.patient = sender as? Patient
        }
    }
}

extension PatientListScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let patient = patients[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientListCell") as! PatientListCell
        
        cell.setPatient(patient)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let patient = patients[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "PatientSegue", sender: patient)
    }
}

extension PatientListScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searching = true
        
        patients = performPatientSearch()
        
        patientTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false

        searchBar.text = ""
        
        if filtering {
            patients = filterPatientArray(allPatients: allPatients)
        } else {
            patients = allPatients
        }
        
        patientTableView.reloadData()
    }
    
    func performPatientSearch() -> [Patient] {
        var searchPatients: [Patient] = []

        if filtering {
            patients = filterPatientArray(allPatients: allPatients)
        } else {
            patients = allPatients
        }
        
        if(patientSearchBar.text!.isEmpty){
            searchPatients = patients
        } else {
            for rows in 0 ..< patients.count {
                if(patients[rows].getName().lowercased().contains(patientSearchBar.text!.lowercased())){
                    searchPatients.append(patients[rows])
                }
            }
        }
        
        return searchPatients
    }
}
