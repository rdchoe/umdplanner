//
//  SleepAddNewViewController.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import Charts

class SleepAddNewViewController: UIViewController {
    var datePicker = UIDatePicker()
    var dateFormatter = DateFormatter()
    var toolBar = UIToolbar()
    var sleepTime : Date?
    var upTime : Date?
    var duration : TimeInterval?
    
    @IBOutlet weak var SleepTimePicker: UITextField!
    @IBOutlet weak var UpTimePicker: UITextField!
    @IBOutlet weak var DurationTextField: UILabel!
    @IBOutlet weak var SleepTitle: UILabel!
    @IBOutlet weak var UpTitle: UILabel!
    @IBOutlet weak var DurationTitle: UILabel!
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBAction func SleepPressed(_ sender: Any) {
        
    }
    
    @IBAction func SavePressed(_ sender: Any) {
        createData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SleepTimePicker.inputView = datePicker
        UpTimePicker.inputView = datePicker
        
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolBar.setItems([doneButton], animated: true)
        SleepTimePicker.inputAccessoryView = toolBar
        UpTimePicker.inputAccessoryView = toolBar
        
        self.view.backgroundColor = UIColor(rgb: 0x282C35)
        SleepTitle.textColor = UIColor(rgb: 0xFFA7C4)
        UpTitle.textColor = UIColor(rgb: 0xFFA7C4)
        DurationTitle.textColor = UIColor(rgb: 0xFFA7C4)
        SleepTimePicker.backgroundColor = UIColor(rgb: 0x424857)
        SleepTimePicker.textColor = UIColor.white
        UpTimePicker.backgroundColor = UIColor(rgb: 0x424857)
        UpTimePicker.textColor = UIColor.white
        DurationTextField.textColor = UIColor.white
        //SaveButton.setTitleColor(UIColor(rgb: 0xFFA7C4), for: UIControl.State.normal)
        //SleepTitle.font = UIFont(name: "merriweather-regular", size: 17)
        //UpTitle.font = UIFont(name: "merriweather-regular", size: 17)
        //DurationTitle.font = UIFont(name: "merriweather-regular", size: 17)
        //SaveButton.titleLabel?.font = UIFont(name: "merriweather-regular", size: 17)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == SleepTimePicker {
            datePicker.datePickerMode = .date
        }
        if textField == UpTimePicker {
            datePicker.datePickerMode = .date
        }
    }
    
    @objc func doneButtonTapped() {
        if SleepTimePicker.isFirstResponder {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            SleepTimePicker.text = dateFormatter.string(from: datePicker.date)
            self.sleepTime = self.datePicker.date
            calculateDuration()
        }
        if UpTimePicker.isFirstResponder {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            UpTimePicker.text = dateFormatter.string(from: datePicker.date)
            self.upTime = self.datePicker.date
            calculateDuration()
        }
        self.view.endEditing(true)
    }
    
    func calculateDuration() {
        if (upTime != nil && sleepTime != nil) {
            duration = upTime?.timeIntervalSince(sleepTime!)
            DurationTextField.text = stringFromTimeInterval(interval: duration!)
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d hrs %02d min", hours, minutes)
    }
    
    func createData() {
        if (sleepTime == nil || upTime == nil || duration == nil || sleepTime! > upTime! || Int(duration!) >= 86400) {
            let alert = UIAlertController(title: "Invalid Data Entry", message: "Please check your date before saving.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Sleep", in: context)
            let newRecord = NSManagedObject(entity: entity!, insertInto: context)
            
            newRecord.setValue(Int(duration!), forKey: "duration")
            newRecord.setValue(sleepTime, forKey: "sleepTime")
            newRecord.setValue(upTime, forKey: "upTime")
            
            do {
                try context.save()
                let alert = UIAlertController(title: "Data Entry Saved!", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            } catch {
                let alert = UIAlertController(title: "Saving Error", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("Failed saving")
            }
        }
    }
    
    @IBAction func ButtonPressed(_ sender: Any) {
        retrieveData()
    }
    
    func retrieveData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sleep")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print("---")
                print(data.value(forKey: "duration") as! Int)
                
            }
        } catch {
            print("Failed")
        }
    }
    
}



