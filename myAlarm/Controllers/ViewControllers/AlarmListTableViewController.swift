//
//  AlarmListTableViewController.swift
//  myAlarm
//
//  Created by Bethany Morris on 4/20/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmController.sharedInstance.loadFromPersistentStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
        sender.title = sender.title == "Edit" ? "Done" : "Edit"
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.sharedInstance.myAlarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmListCell", for: indexPath) as? AlarmListTableViewCell else { return UITableViewCell() }

        let selectedAlarm = AlarmController.sharedInstance.myAlarms[indexPath.row]
        cell.delegate = self
        cell.alarm = selectedAlarm
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmtoDelete = AlarmController.sharedInstance.myAlarms[indexPath.row]
            AlarmController.sharedInstance.deleteAlarm(alarm: alarmtoDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = AlarmController.sharedInstance.myAlarms[fromIndexPath.row]
        AlarmController.sharedInstance.myAlarms.remove(at: fromIndexPath.row)
        AlarmController.sharedInstance.myAlarms.insert(item, at: destinationIndexPath.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        if segue.identifier == "ToAlarmDTVC" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
            let alarmToSend = AlarmController.sharedInstance.myAlarms[indexPath.row]
            destinationVC.ADTVCAlarm = alarmToSend
        }
    }

} //End of class

extension AlarmListTableViewController: AlarmListTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: AlarmListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let selectedAlarm = AlarmController.sharedInstance.myAlarms[indexPath.row]
        AlarmController.sharedInstance.toggleEnabled(for: selectedAlarm)
        cell.alarm = selectedAlarm
    }
}
