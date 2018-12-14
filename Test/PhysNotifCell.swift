//
//  PhysNotifCell.swift
//  Test
//
//  Created by Steven Armstrong on 2018-11-26.
//  Copyright © 2018 CAS757_Group6. All rights reserved.
//

import UIKit

protocol PhysNotifCellDelegate {
    func didTapAccept(_ cellIndex: Int)
    func didTapDecline(_ cellIndex: Int)
    func didTapSeePat(_ cellIndex: Int)
}

class PhysNotifCell: UITableViewCell {
    
    @IBOutlet weak var notifText: UILabel!
    @IBOutlet weak var acceptNotif: UIButton!
    @IBOutlet weak var declineNotif: UIButton!
    @IBOutlet weak var seePatient: UIButton!
    
    var delegate: PhysNotifCellDelegate?
    var notif: Notification!
    var index:Int = 0
    
    func setNotif(_ notification: Notification, cellIndex: Int){
        notif = notification
        self.index = cellIndex
        notifText.text = notification.notifStr
    }
    
    
    @IBAction func acceptTapped(_ sender: AnyObject) {
        delegate?.didTapAccept(index)
    }
    
    @IBAction func declineTapped(_ sender: AnyObject) {
        delegate?.didTapDecline(index)
    }
        //update patient values
    @IBAction func seePatientTapped(_ sender: AnyObject) {
        delegate?.didTapSeePat(index)
    }
        
        //add to history
        
        //update notification variable
        
        //remove notification cell
    
}
