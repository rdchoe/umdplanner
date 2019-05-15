//
//  FakeAlertController.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//

import UIKit
import CoreData

class FakeAlertController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let bckColor = UIColor.init(displayP3Red: 40/255, green: 44/255, blue: 53/255, alpha: 1)
    let secondaryColor = UIColor.init(displayP3Red: 51/255, green: 56/255, blue: 72/255, alpha: 1)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var assignName: UITextField!
    @IBOutlet weak var assignClass: UITextField!
    @IBOutlet weak var assignPriority: UITextField!
    @IBOutlet weak var assignDate: UITextField!
    @IBOutlet weak var fakeAlertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    var datePicker = UIDatePicker()
    var classPicker = UIPickerView()
    
    var classes:[NSManagedObject] = []
    
    var delegate: FakeAlertDelegate?
    let fakeAlertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        classPicker.delegate = self
        
        assignDate.inputView = datePicker
        assignClass.inputView = classPicker
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        assignName.attributedPlaceholder = NSAttributedString(string:"Assign Name", attributes: [NSAttributedString.Key.foregroundColor:
            UIColor.lightGray])
        assignDate.attributedPlaceholder = NSAttributedString(string:"Due Date", attributes: [NSAttributedString.Key.foregroundColor:
            UIColor.lightGray])
        assignClass.attributedPlaceholder = NSAttributedString(string:"For Class", attributes: [NSAttributedString.Key.foregroundColor:
            UIColor.lightGray])
        assignPriority.attributedPlaceholder = NSAttributedString(string:"Priority (1-5)", attributes: [NSAttributedString.Key.foregroundColor:
            UIColor.lightGray])
        
        fakeAlertView.backgroundColor = bckColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //add code to get the current list of classes each time the
        //view will appear
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "SchoolClass")
        fetchReq.returnsObjectsAsFaults = false
        do {
            classes = try context.fetch(fetchReq)
        } catch {
            print("Error in fetching")
        }
        
        
        setupView()
        animateView()
    }
    
    @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        assignDate.text = dateFormatter.string(from: datePicker.date)
        //add this to recognize a tap off the pickerview
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let ret = classes[row].value(forKey: "name") as? String
        return NSAttributedString(string: ret!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        assignClass.text = classes[row].value(forKey: "name") as? String
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setupView() {
        fakeAlertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        fakeAlertView.alpha = 0;
        self.fakeAlertView.frame.origin.y = self.fakeAlertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.fakeAlertView.alpha = 1.0;
            self.fakeAlertView.frame.origin.y = self.fakeAlertView.frame.origin.y - 50
        })
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        delegate?.cancelTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okTapped(_ sender: UIButton) {
        delegate?.okTapped(assignName: assignName.text!, schoolClass: assignClass.text!, priority: assignPriority.text!, date: assignDate.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
