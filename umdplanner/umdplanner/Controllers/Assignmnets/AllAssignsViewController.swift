//
//  AllAssignsViewController.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//

import UIKit
import CoreData

class AssignmentCell: UITableViewCell {
    
    @IBOutlet weak var assignLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var priorityStripe: UIView!
    @IBOutlet weak var dateLabel: UILabel!
}

class AllAssignsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let bckColor = #colorLiteral(red: 0.2068828046, green: 0.2267954946, blue: 0.2691288292, alpha: 1)
    let secondaryColor = UIColor.init(displayP3Red: 51/255, green: 56/255, blue: 72/255, alpha: 1)
    
    let priority1 = UIColor.init(red: 255/255, green: 208/255, blue: 204/255, alpha: 1)
    let priority2 = UIColor.init(red: 255/255, green: 162/255, blue: 153/255, alpha: 1)
    let priority3 = UIColor.init(red: 255/255, green: 115/255, blue: 102/255, alpha: 1)
    let priority4 = UIColor.init(red: 255/255, green: 68/255, blue: 51/255, alpha: 1)
    let priority5 = UIColor.init(red: 255/255, green: 21/255, blue: 0/255, alpha: 1)
    let colorComplete = UIColor.init(red: 153/255, green: 255/255, blue: 153/255, alpha: 1)
    
    var sortPicker = UIPickerView()
    @IBOutlet weak var sortBy: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var toggleCompleted: UIButton!
    var isSelected = false
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.allowsSelection = false
            tableView.delegate = self
            tableView.rowHeight = 64
            tableView.separatorStyle = .singleLine
        }
    }
    
    lazy var tap: UITapGestureRecognizer = {
        let dblTap = UITapGestureRecognizer(target: self, action: #selector(didDouble))
        dblTap.numberOfTapsRequired = 2
        return dblTap
    }()
    
    var assigns: [NSManagedObject] = []
    var options = ["Class Name", "Priority Value", "Due Date"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortPicker.delegate = self
        sortBy.inputView = sortPicker
        self.view.addGestureRecognizer(tap)
        toggleCompleted.setTitle("✓", for: .normal)
        toggleCompleted.setTitleColor(.green, for: .normal)
        tableView.backgroundColor = bckColor
        view.layer.backgroundColor = bckColor.cgColor
        
        UINavigationBar.appearance().barTintColor = bckColor
        UINavigationBar.appearance().backgroundColor = bckColor
        
        sortBy.backgroundColor = secondaryColor
        
        UITextField.appearance().backgroundColor = secondaryColor
        
        UIPickerView.appearance().backgroundColor = secondaryColor
        
        sortBy.attributedPlaceholder = NSAttributedString(string:"Sort Assignments", attributes: [NSAttributedString.Key.foregroundColor:
            UIColor.lightGray])
        
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        
    }
    
    @IBAction func sortTapped(_ sender: Any) {
        sortPicker.contentMode = .center
        sortPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        sortPicker.backgroundColor = UIColor.white
        self.view.addSubview(sortPicker)
    }
    
    @IBAction func toggled(_ sender: UIButton) {
        isSelected = !isSelected
        if (isSelected) {
            sender.setTitle("✓", for: .normal)
            sender.setTitleColor(.green, for: .normal)
            //add completed to list
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "SchoolAssign")
            fetchReq.returnsObjectsAsFaults = false
            do {
                assigns = try context.fetch(fetchReq)
                print("fetch worked")
                print(assigns)
            } catch {
                print("Error in fetching")
            }
            
            //preserve the sorting preference if specified
            if (sortBy.text != "" && sortBy.text != nil) {
                sortTableView(sortBy: sortBy.text!)
            } else {
                tableView.reloadData()
            }
            
        } else {
            sender.setTitle("X", for: .normal)
            sender.setTitleColor(.red, for: .normal)
            
            //remove completed from assigns
            assigns = assigns.filter {
                $0.value(forKey: "completed") as! Bool != true
            }
            
            if (sortBy.text != "" && sortBy.text != nil) {
                sortTableView(sortBy: sortBy.text!)
            } else {
                tableView.reloadData()
            }
            
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let ret = options[row]
        return NSAttributedString(string: ret, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sortBy.text = options[row]
        self.view.endEditing(true)
        sortTableView(sortBy: options[row])
    }
    
    func sortTableView(sortBy: String) {
        if (sortBy == "Class Name") {
            assigns.sort(by: sorterForName)
        } else if (sortBy == "Due Date") {
            assigns.sort(by: sorterForDate)
        } else {
            assigns.sort(by: sorterForPriority)
        }
        
        self.tableView.reloadData()
        
    }
    
    func sorterForName(this:NSManagedObject,that:NSManagedObject) -> Bool {
        return that.value(forKey: "schoolClass") as! String > this.value(forKey: "schoolClass") as! String
    }
    
    func sorterForDate(this:NSManagedObject,that:NSManagedObject) -> Bool {
        return that.value(forKey: "due") as! String > this.value(forKey: "due") as! String
    }
    
    func sorterForPriority(this:NSManagedObject,that:NSManagedObject) -> Bool {
        return that.value(forKey: "priority") as! String > this.value(forKey: "priority") as! String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "SchoolAssign")
        fetchReq.returnsObjectsAsFaults = false
        do {
            assigns = try context.fetch(fetchReq)
            print("fetch worked")
            print(assigns)
        } catch {
            print("Error in fetching")
        }
        
    }
    
    @objc func didDouble() {
        let tappedLocation = tap.location(in: tableView)
        let tappedCellIndexPath = tableView.indexPathForRow(at: tappedLocation)
        
        print(tappedLocation)
        if (tappedCellIndexPath == nil) {
            print("the tapped cell was nil")
        } else {
            //modify the completed status of assignment in the cell that was tapped
            let theAssign = assigns[(tappedCellIndexPath?.row)!]
            if (theAssign.value(forKey: "completed") as! Bool == false) {
                theAssign.setValue(true, forKey: "completed")
            } else {
                theAssign.setValue(false, forKey: "completed")
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                try context.save()
                print("doubletap saved")
            } catch {
                print("updating error")
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        
        let fakeAlert = self.storyboard?.instantiateViewController(withIdentifier: "FakeAlertController") as! FakeAlertController
        fakeAlert.providesPresentationContextTransitionStyle = true
        fakeAlert.definesPresentationContext = true
        fakeAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        fakeAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        fakeAlert.delegate = self as! FakeAlertDelegate
        self.present(fakeAlert, animated: true, completion: nil)
        
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
        let currentAssign = assigns[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignCell", for: indexPath)
        if let myCell = cell as? AssignmentCell {
            myCell.assignLabel.text = currentAssign.value(forKey: "name") as? String
            myCell.dateLabel.text = currentAssign.value(forKey: "due") as? String
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
    
    func cellWasDoubleTapped(cell: UITableViewCell) {
        print("i was tapped xd")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(assigns[indexPath.row])
            assigns.remove(at: indexPath.row)
            
            do {
                try context.save()
                
            } catch {
                print("Error in deleting")
            }
            
            self.tableView.reloadData()
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assigns.count
    }
    
}

extension AllAssignsViewController: FakeAlertDelegate {
    func okTapped(assignName: String, schoolClass: String, priority: String, date: String) {
        saveAssign(assignName: assignName, schoolClass: schoolClass, priority: priority, date: date)
    }
    
    func cancelTapped() {
        print("cancel tapped")
    }
    
    @objc func dateChanged() {
        
    }
    
    func saveAssign(assignName: String, schoolClass: String, priority: String, date: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newAssign = NSEntityDescription.entity(forEntityName: "SchoolAssign", in: context)!
        let theAssign = NSManagedObject(entity: newAssign, insertInto: context)
        
        theAssign.setValue(assignName, forKey: "name")
        theAssign.setValue(schoolClass, forKey: "schoolClass")
        theAssign.setValue(date, forKey: "due")
        theAssign.setValue(priority, forKey: "priority")
        theAssign.setValue(false, forKey: "completed")
        
        do {
            try context.save()
            assigns.append(theAssign)
        } catch {
            print("saving error")
        }
        
        self.tableView.reloadData()
        
    }
}
