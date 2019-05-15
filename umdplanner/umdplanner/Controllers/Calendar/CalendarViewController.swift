//
//  CalendarViewController.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//

import UIKit
import CoreData
import FSCalendar

class CalCell: UITableViewCell {
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priorityStripe: UIView!
}

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarView: FSCalendar!
    
    let bckColor = #colorLiteral(red: 0.2068828046, green: 0.2267954946, blue: 0.2691288292, alpha: 1)
    let secondaryColor = UIColor.init(displayP3Red: 51/255, green: 56/255, blue: 72/255, alpha: 1)
    let priority1 = UIColor.init(red: 255/255, green: 208/255, blue: 204/255, alpha: 1)
    let priority2 = UIColor.init(red: 255/255, green: 162/255, blue: 153/255, alpha: 1)
    let priority3 = UIColor.init(red: 255/255, green: 115/255, blue: 102/255, alpha: 1)
    let priority4 = UIColor.init(red: 255/255, green: 68/255, blue: 51/255, alpha: 1)
    let priority5 = UIColor.init(red: 255/255, green: 21/255, blue: 0/255, alpha: 1)
    let colorComplete = UIColor.init(red: 153/255, green: 255/255, blue: 153/255, alpha: 1)
    
    var assignsToday: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.dataSource = self
        calendarView.delegate = self
        
        self.view.backgroundColor = bckColor
        calendarView.backgroundColor = bckColor
        tableView.backgroundColor = bckColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.layoutIfNeeded()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let currentDay = dateFormatter.string(from: calendarView.today!)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "SchoolAssign")
        fetchReq.predicate = NSPredicate(format: "due == %@", currentDay)
        fetchReq.returnsObjectsAsFaults = false
        do {
            assignsToday = try context.fetch(fetchReq)
            print("fetch worked")
            print(assignsToday)
        } catch {
            print("Error in fetching")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignsToday.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func returnColor(priority: String) -> UIColor {
        let intVal = Int(priority)
        if (intVal == 1) {
            return priority1
        } else if (intVal == 2) {
            return priority2
        } else if (intVal == 3) {
            return priority3
        } else if (intVal == 4) {
            return priority4
        } else if (intVal == 5) {
            return priority5
        } else {
            return UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("in cell for row")
        let currentAssign = assignsToday[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalCell", for: indexPath)
        if let myCell = cell as? CalCell {
            myCell.nameLabel.text = currentAssign.value(forKey: "name") as? String
            myCell.classLabel.text = currentAssign.value(forKey: "schoolClass") as? String
            
            let priorityRes = returnColor(priority: (currentAssign.value(forKey: "priority") as? String)!)
            
            if (currentAssign.value(forKey: "completed") as! Bool == false) {
                myCell.priorityStripe.backgroundColor = priorityRes
            } else {
                myCell.priorityStripe.backgroundColor = colorComplete
            }
            
        }
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.backgroundColor = secondaryColor
        cell.layer.cornerRadius = 8
        return cell
        
    }
    
    
    
}
