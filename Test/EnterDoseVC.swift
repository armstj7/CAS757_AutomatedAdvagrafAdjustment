//
//  EnterDoseVC.swift
//  AdvagrafApp
//
//  Created by Steven Armstrong on 2018-12-11.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit

class EnterDoseVC: UIViewController {

    var patient:Patient?
    
    @IBOutlet weak var doseTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
        if(doseTextField.text != ""){
            if let dose = Float(doseTextField.text!) {
                /*let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy"
                
                let now = formatter.string(from: date)*/
                
                patient?.addAdvagrafDose(dose, entryDate: getNow())
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
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
