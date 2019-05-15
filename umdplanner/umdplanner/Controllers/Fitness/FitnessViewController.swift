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

//Collection View of Exercises in Each Table Row
extension FitnessViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[collectionView.tag].exercises!.count
    }
    //ExerciseCell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exerciseCell", for: indexPath)
        
        if let myCell = cell as? exerciseCell {
            let exerciseArr = (model[collectionView.tag].exercises!.allObjects as! [Exercise]).sorted(by: {$0.exerciseName! < $1.exerciseName!})[indexPath.item]
            myCell.exerciseName.text = exerciseArr.exerciseName!
            myCell.sets.text = String(exerciseArr.setScheme)
            myCell.reps.text = String(exerciseArr.repScheme)
            myCell.weight.text = String(exerciseArr.weight) + " lb"
            return myCell
        } else {
            return cell
        }

    }
    
   
}

class FitnessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var model: [Workout] = []
    var storedOffsets = [Int: CGFloat]()
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
        
        if let myCell = cell as? workoutCell {
            myCell.date.text = model[indexPath.row].date
            myCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            return myCell
        } else {
            return cell
        }
    }
    //offset settings
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myCell = cell as? workoutCell {
            myCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            myCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        } else {
            return
        }

    }
    //offset settings
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myCell = cell as? workoutCell {
            storedOffsets[indexPath.row] = myCell.collectionViewOffset
        } else {
            return
        }
    }
    
    //deleting rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let objToDelete = model[indexPath.row]
            AppDelegate.viewContext.delete(objToDelete)
            model.remove(at: indexPath.row)
            tableView.reloadData()
            print(self.model.count)
            do {
                try AppDelegate.viewContext.save()
            } catch {
                print("context cant saved")
            }
            //tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FitnessViewController Loaded")
        AppDelegate.viewContext.automaticallyMergesChangesFromParent = true
        

        UISetup()
    }
    
    func UISetup() {
        self.title = "Fitness"
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("FitnessViewController appeared")
        AppDelegate.viewContext.refreshAllObjects()
        
        let fetchWorkouts: NSFetchRequest<Workout> = Workout.fetchRequest()
        let res = try? AppDelegate.viewContext.fetch(fetchWorkouts)
        if let workouts = res {
            let sortedWorkouts = workouts.sorted(by: {$0.date! > $1.date!})
            self.model = sortedWorkouts
            self.fitnessTableView.reloadData()
            print(self.model.count)
        } else {
            print("couldn't fetch")
        }
    }
    
    func deleteAllRecord() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Workout")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try AppDelegate.viewContext.execute(deleteRequest)
            try AppDelegate.viewContext.save()
            print("all data deleted")
        } catch {
            print("can't delete")
        }
    }
 
}
