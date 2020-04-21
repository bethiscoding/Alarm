//
//  AlarmTableViewController.swift
//  myAlarm
//
//  Created by Bethany Morris on 4/20/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var enabledLabel: UILabel!
    @IBOutlet weak var enableButton: UIButton!
    
    // MARK: - Properties
    
    var ADTVCAlarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var alarmIsOn: Bool = true
        
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let alarm = ADTVCAlarm else { return }
        navigationItem.title = "\(alarm.name)"
    }
    
    // MARK: - Actions
    
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = ADTVCAlarm else { return }
        AlarmController.sharedInstance.toggleEnabled(for: alarm)
        updateViews()
        setUpEnableButton()
        
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let alarmName = nameLabel.text, !alarmName.isEmpty else { return }

        if let alarm = ADTVCAlarm {
            AlarmController.sharedInstance.updateAlarm(alarm: alarm, name: alarmName, fireDate: datePicker.date, enabled: alarmIsOn)
        } else {
            AlarmController.sharedInstance.createAlarm(name: alarmName, fireDate: datePicker.date, enabled: alarmIsOn)
        }

        navigationController?.popViewController(animated: true)
    }

    // MARK: - Methods
    
    private func updateViews() {
        guard let alarm = ADTVCAlarm else { return }
        alarmIsOn = alarm.enabled
        datePicker.date = alarm.fireDate
        nameLabel.text = alarm.name
        navigationItem.title = "\(alarm.name)"
        setUpEnableButton()
    }
    
    func setUpEnableButton() {
        switch alarmIsOn {
        case true:
            enabledLabel.text = "On"
            enabledLabel.backgroundColor = .green
            enabledLabel.textColor = .white
            enabledLabel.layer.cornerRadius = 10
            enabledLabel.layer.masksToBounds = true
            enableButton.setTitle("Turn Off?", for: .normal)
        case false:
            enabledLabel.text = "Off"
            enabledLabel.backgroundColor = .red
            enabledLabel.textColor = .white
            enabledLabel.layer.cornerRadius = 10
            enabledLabel.layer.masksToBounds = true
            enableButton.setTitle("Turn On?", for: .normal)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 2 {
            return 2
        } else {
            return 1
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

}
