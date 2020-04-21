//
//  AlarmListTableViewCell.swift
//  myAlarm
//
//  Created by Bethany Morris on 4/20/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

protocol AlarmListTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: AlarmListTableViewCell)
}

class AlarmListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    // MARK: - Properties
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: AlarmListTableViewCellDelegate?
    
    // MARK: - Methods
    
    func updateViews() {
        guard let alarm = alarm else { return }
        
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
    
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }

}
