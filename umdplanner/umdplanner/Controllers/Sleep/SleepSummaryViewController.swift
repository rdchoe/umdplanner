//
//  SleepSummaryViewController.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SleepSummaryViewController: UIViewController {
    var sleepArray = [Date]()
    var upArray = [Date]()
    var duration = 0
    var count = 0
    var avgDuration = 0
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var AvgSleepLabel: UILabel!
    @IBOutlet weak var AvgUpLabel: UILabel!
    @IBOutlet weak var AvgDurationLabel: UILabel!
    @IBOutlet weak var AvgSleepTitle: UILabel!
    @IBOutlet weak var AvgUpTitle: UILabel!
    @IBOutlet weak var AvgDurationTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveData()
        updateLabel()
        
        self.view.backgroundColor = UIColor(rgb: 0x282C35)
        //resetButton.setTitleColor(UIColor(rgb: 0xFFA7C4), for: UIControl.State.normal)
        AvgSleepLabel.textColor = UIColor.white
        AvgUpLabel.textColor = UIColor.white
        AvgDurationLabel.textColor = UIColor.white
        AvgSleepTitle.textColor = UIColor(rgb: 0xFFA7C4)
        AvgUpTitle.textColor = UIColor(rgb: 0xFFA7C4)
        AvgDurationTitle.textColor = UIColor(rgb: 0xFFA7C4)
        //AvgSleepTitle.font = UIFont(name: "merriweather-regular", size: 17)
        //AvgUpTitle.font = UIFont(name: "merriweather-regular", size: 17)
        //AvgDurationTitle.font = UIFont(name: "merriweather-regular", size: 17)
        //resetButton.titleLabel?.font = UIFont(name: "merriweather-regular", size: 17)
    }
    
    @IBAction func ResetPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Data", message: "All data will be removed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in self.resetData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func updateLabel() {
        if (duration == 0) {
            AvgDurationLabel.text = "No Data Available"
            AvgSleepLabel.text = "No Data Available"
            AvgUpLabel.text = "No Data Available"
        } else {
            AvgDurationLabel.text = stringFromTimeInterval(interval: avgDuration)
            AvgSleepLabel.text = calculateAvgTime(dates: sleepArray)
            AvgUpLabel.text = calculateAvgTime(dates: upArray)
        }
    }
    
    func resetData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Create Fetch Request
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sleep")
        
        // Create Batch Delete Request
        var batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            let alert = UIAlertController(title: "Reset Data", message: "Your data has been reset.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        } catch {
            let alert = UIAlertController(title: "Reset Data", message: "Error when reset.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            // Error Handling
        }
        
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SleepFlag")
        // Create Batch Delete Request
        batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(batchDeleteRequest)
            print("deleting")
        } catch {
            // Error Handling
            print("error")
        }
        
        sleepArray = [Date]()
        upArray = [Date]()
        duration = 0
        count = 0
        avgDuration = 0
        updateLabel()
    }
    
    func retrieveData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Sleep")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let slp = data.value(forKey: "sleepTime")
                let up = data.value(forKey: "upTime")
                let dur = data.value(forKey: "duration")
                sleepArray.append(slp as! Date)
                upArray.append(up as! Date)
                duration += dur as! Int
                count += 1
            }
        } catch {
            print("Failed")
        }
        if count != 0 {
            avgDuration = duration/count
        }
        
    }
    
    func stringFromTimeInterval(interval: Int) -> String {
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d hrs %02d min", hours, minutes)
    }
    
    func calculateAvgTime(dates : [Date]) -> String {
        var totalHour = 0, totalMin = 0
        for date in dates {
            let hour = Calendar.current.component(.hour, from: date)
            let minutes = Calendar.current.component(.minute, from: date)
            totalHour += Int(hour)
            totalMin += Int(minutes)
        }
        return String(format: "%02d : %02d", totalHour/dates.count, totalMin/dates.count)
        
    }
}

