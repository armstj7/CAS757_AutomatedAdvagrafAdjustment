//
//  LoginScreen.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginScreen: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //var ref:DatabaseReference?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        //ref = Database.database().reference()
        
        //ref?.child("Patients")
        //.setValue(["username": username])

        /*
        let postRef = ref?.child("Patients").childByAutoId()

        
         let patient = [
         "firstName":"Ginny",
         "lastName":"Weasley",
         "DOB":"-",
         "MRN":"9876543214RT",
         "transDate":"Nov 9, 2018",
         "lastBloodResult": "2",
         "dateOfBloodResult": "Nov 26, 2018",
         "bloodRangeLow": "3",
         "bloodRangeHigh": "6",
         "lastAdvagrafDose": "9",
         "doctorID": "2",
         "doctorName": "-",
         //"doctorName": "Dilys Derwent",
         "userID": postRef?.key]
         
         postRef?.setValue(patient)
        
        */
        
        // Do any additional setup after loading the view.
    }

    @IBAction func loginTapped(_ sender: AnyObject) {
       // let username = usernameTextField.text
        //let password = passwordTextField.text
    }
    
}
