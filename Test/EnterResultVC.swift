//
//  EnterResultVC.swift
//  AdvagrafApp
//
//  Created by Steven Armstrong on 2018-12-05.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit

class EnterResultVC: UIViewController {

    @IBOutlet weak var resultTextField: UITextField!
    
    var patient:Patient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submitTapped(_ sender: Any) {
       if(resultTextField.text != ""){
            if let result = Float(resultTextField.text!) {
                
                patient?.addBloodResult(result, entryDate: getNow())
        
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
