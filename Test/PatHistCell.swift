//
//  PatHistCell.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-27.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit

class PatHistCell: UITableViewCell {

    @IBOutlet weak var patHistLabel: UILabel!
    
    func setHist(_ history:History){
        patHistLabel.text = history.histStr
    }

}
