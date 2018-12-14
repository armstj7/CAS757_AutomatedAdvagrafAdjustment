//
//  PatientListCell.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-26.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit

class PatientListCell: UITableViewCell {


    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientDOBLabel: UILabel!
    
    
    func setPatient(_ patient: Patient){
        patientNameLabel.text = patient.getName()
        patientDOBLabel.text = patient.DOB
    }
}
