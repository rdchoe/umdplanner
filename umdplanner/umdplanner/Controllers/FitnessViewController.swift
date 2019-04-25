//
//  FitnessViewController.swift
//  umdplanner
//
//  Created by Robert Choe on 4/16/19.
//  Copyright © 2019 group42. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class FitnessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let model: [Int] = [3,2,1]
    @IBOutlet weak var fitnessTableView: UITableView! {
        didSet {
            fitnessTableView.dataSource = self
            fitnessTableView.delegate = self
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fitnessTableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath)
        
        cell.textLabel?.text = "yo"
        
        return cell
        
        
    }   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FitnessViewController Loaded")
    }
}
