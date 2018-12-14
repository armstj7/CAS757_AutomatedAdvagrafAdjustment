//
//  PatientStatsScreen.swift
//  AdvagrafApp
//
//  Created by Steven Armstrong on 2018-12-06.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit

class PatientStatsScreen: UIViewController {

    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientDOBLabel: UILabel!
    @IBOutlet weak var patientMRNLabel: UILabel!
    @IBOutlet weak var patientDateofTransLabel: UILabel!
    
    var patient:Patient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = tabBarController as! TabBarController
        self.patient = tabBar.patient
        
        setUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        patientNameLabel.text = patient?.getName()
        patientDOBLabel.text = "Date of Birth: " + patient!.DOB
        patientMRNLabel.text = "OHIP: " + patient!.MRN
        patientDateofTransLabel.text = "Date of Transplant: " + patient!.transplantDate
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
