//
//  EnterRangeVC.swift
//  AdvagrafApp
//
//  Created by Steven Armstrong on 2018-12-11.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit

class EnterRangeVC: UIViewController {

    var patient:Patient?
    
    @IBOutlet weak var rangeLowTF: UITextField!
    @IBOutlet weak var rangeHighTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitTapped(_ sender: Any) {
        var updated = false
        
        if(rangeLowTF.text != ""){
            if let rangeLow = Float(rangeLowTF.text!) {
                patient?.updateValue(attribute: "bloodRangeLow", value: String(rangeLow))
                patient?.setBloodWorkRange(rangeLow, high: 0)
                updated = true
            }
        }
        
        if(rangeHighTF.text != ""){
            if let rangeHigh = Float(rangeHighTF.text!) {
                patient?.updateValue(attribute: "bloodRangeHigh", value: String(rangeHigh))
                patient?.setBloodWorkRange(rangeHigh, high: 1)
                updated = true
            }
            
        }
        
        if(updated){
            patient?.addHistoryEvent((patient?.doctorName)!, action: "changed range", entryDate: getNowTimestamp())
            _ = self.navigationController?.popViewController(animated: true)
            
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
