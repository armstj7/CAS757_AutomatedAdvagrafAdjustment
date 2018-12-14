//
//  Person.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import Foundation

class Person{
    var firstName:String = ""
    var lastName:String = ""
    
    init(){
        
    }
    
    func setName(_ firstName: String, lastName: String){
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func getName() -> String {
        return (firstName + " " + lastName)
    }
}
