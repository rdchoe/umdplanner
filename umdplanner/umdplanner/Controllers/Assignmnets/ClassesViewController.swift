//
//  ClassesViewController.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//

import UIKit
import CoreData

class ClassCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var colorStrip: UIView!
}

class ClassesViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let bckColor = UIColor.init(displayP3Red: 40/255, green: 44/255, blue: 53/255, alpha: 1)
    let secondaryColor = UIColor.init(displayP3Red: 51/255, green: 56/255, blue: 72/255, alpha: 1)
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 78
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var classes: [NSManagedObject] = []
    
    let context = (UIApplication.shared.delegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = bckColor
        view.layer.backgroundColor = bckColor.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        print("making fetch req")
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "SchoolClass")
        fetchReq.returnsObjectsAsFaults = false
        do {
            classes = try context.fetch(fetchReq)
        } catch {
            print("Error in fetching")
        }
        
        print(classes)
    }
    
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        let fakeAlert = self.storyboard?.instantiateViewController(withIdentifier: "ClassFakeAlertController") as! ClassFakeAlertController
        fakeAlert.providesPresentationContextTransitionStyle = true
        fakeAlert.definesPresentationContext = true
        fakeAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        fakeAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        fakeAlert.delegate = self as! ClassFakeAlertDelegate
        self.present(fakeAlert, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return classes.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(classes[indexPath.section])
            classes.remove(at: indexPath.section)
            
            do {
                try context.save()
            } catch {
                print("Error in deleting")
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentClass = classes[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath)
        if let myCell = cell as? ClassCell {
            myCell.nameLabel.text = currentClass.value(forKey: "name") as? String
            myCell.timeLabel.text = currentClass.value(forKey: "start") as? String
            myCell.daysLabel.text = currentClass.value(forKey: "days") as? String
            myCell.timeEndLabel.text = currentClass.value(forKey: "end") as? String
        }
        
        cell.backgroundColor = secondaryColor
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 8
        return cell
    }
    
    
}

extension ClassesViewController: ClassFakeAlertDelegate {
    
    func okTapped(className: String, classStart: String, classEnd: String, daysMeeting: String) {
        saveClass(className: className, classStart: classStart, classEnd: classEnd, daysMeeting: daysMeeting)
    }
    
    func cancelTapped() {
        print("cancel tapped")
    }
    
    func saveClass(className: String, classStart: String, classEnd: String, daysMeeting: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newClass = NSEntityDescription.entity(forEntityName: "SchoolClass", in: context)!
        let theClass = NSManagedObject(entity: newClass, insertInto: context)
        theClass.setValue(className, forKey: "name")
        theClass.setValue(classStart, forKey: "start")
        theClass.setValue(classEnd, forKey: "end")
        theClass.setValue(daysMeeting, forKey: "days")
        
        do {
            try context.save()
            classes.append(theClass)
        } catch {
            print("saving error")
        }
        
        self.tableView.reloadData()
    }
    
    
}

