//
//  ClassFakeAlertController.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//

import UIKit
import CoreData

class ClassFakeAlertController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var className: UITextField!
    @IBOutlet weak var classStart: UITextField!
    @IBOutlet weak var classEnd: UITextField!
    @IBOutlet weak var meetingDays: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fakeAlertView: UIView!
    
    let bckColor = UIColor.init(displayP3Red: 40/255, green: 44/255, blue: 53/255, alpha: 1)
    let secondaryColor = UIColor.init(displayP3Red: 51/255, green: 56/255, blue: 72/255, alpha: 1)
    
    var dayPicker = UIPickerView()
    var delegate: ClassFakeAlertDelegate?
    
    var dayOptions = ["M/W/F","Tu/Th","M/W","W/F","M","Tu","W","Th","F"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dayOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        meetingDays.text = dayOptions[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayPicker.delegate = self
        meetingDays.inputView = dayPicker
        
        fakeAlertView.backgroundColor = bckColor
        
        className.attributedPlaceholder = NSAttributedString(string:"Class Name", attributes: [NSAttributedString.Key.foregroundColor:
            UIColor.lightGray])
        classEnd.attributedPlaceholder = NSAttributedString(string:"Class End Time", attributes: [NSAttributedString.Key.foregroundColor:
            UIColor.lightGray])
        classStart.attributedPlaceholder = NSAttributedString(string:"Class Start Time", attributes: [NSAttributedString.Key.foregroundColor:
            UIColor.lightGray])
        meetingDays.attributedPlaceholder = NSAttributedString(string:"Meeting On", attributes: [NSAttributedString.Key.foregroundColor:
            UIColor.lightGray])
        
        dayPicker.setValue(UIColor.white, forKey: "textColor")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
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
    
    @IBAction func okTapped(_ sender: UIButton) {
        delegate?.okTapped(className: className.text!, classStart: classStart.text!, classEnd: classEnd.text!, daysMeeting: meetingDays.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        delegate?.cancelTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

