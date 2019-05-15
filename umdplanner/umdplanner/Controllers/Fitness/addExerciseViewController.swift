//
//  addExerciseViewController.swift
//  umdplanner
//
//  Created by Robert Choe on 4/25/19.
//  Copyright © 2019 group42. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import iOSDropDown
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_ShapeThemer

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}



class addExerciseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var setCollectionView: UICollectionView!
    @IBOutlet weak var exerciseDropDown: DropDown!
    @IBOutlet weak var sets: UITextField!
    @IBOutlet weak var reps: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var addButton: MDCButton!
    
    var workoutModel: Workout? = nil
    var currRepScheme = [0,0]
    var repScheme: [Int] = []
    var exerciseTypes: ExerciseTypes? = []
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExerciseViewController Loaded")
        loadPlist()
        //Exercise Drop Down Customization
        exerciseDropDown.isSearchEnable = true
        exerciseDropDown.selectedRowColor = .cyan
        //exerciseDropDown
        exerciseDropDown.optionArray = exerciseTypes!.map{$0.Name}
        AppDelegate.viewContext.automaticallyMergesChangesFromParent = true
       UIsetup()
        
    }
    func UIsetup() {
        //Exercise Drop Down Customization
        exerciseDropDown.isSearchEnable = true
        exerciseDropDown.selectedRowColor = #colorLiteral(red: 1, green: 0.6549019608, blue: 0.768627451, alpha: 1)
        //exerciseDropDown
        exerciseDropDown.optionArray = exerciseTypes!.map{$0.Name}
        exerciseDropDown.setBottomBorder()
        exerciseDropDown.attributedPlaceholder = NSAttributedString(string: "Select Exercise", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7169910912, green: 0.7195112746, blue: 0.7270718249, alpha: 0.5730682791)])
        exerciseDropDown.textColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 0.5156517551)

        
        sets.setBottomBorder()
        sets.textColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 1)
        
        
        reps.textColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 1)
        reps.setBottomBorder()
        
        weight.setBottomBorder()
        weight.attributedPlaceholder = NSAttributedString(string: "Weight", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7169910912, green: 0.7195112746, blue: 0.7270718249, alpha: 0.5730682791)])
        
        addButton.titleLabel?.textColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.9019607843, alpha: 1)
   
        
        sets.backgroundColor = #colorLiteral(red: 0.2068828046, green: 0.2267954946, blue: 0.2691288292, alpha: 1)
        reps.backgroundColor = #colorLiteral(red: 0.2068828046, green: 0.2267954946, blue: 0.2691288292, alpha: 1)
        
        addButton.backgroundColor = #colorLiteral(red: 1, green: 0.6549019608, blue: 0.768627451, alpha: 1)
        self.title = "New Workout"
    
        
      
        
        
        
    }
    func loadPlist() {
        if let pUrl = Bundle.main.url(forResource: "ExerciseTypes", withExtension: "plist") {
            if let data = try? Data(contentsOf: pUrl) {
                print(data)
                do {
                    exerciseTypes = try PropertyListDecoder().decode(ExerciseTypes.self, from:data)
                } catch {
                    print(error)
                }
                if let _ = exerciseTypes {
                    print("exercises.plist sucessfully loaded into exerciseTypes variable")
                } else {
                    print("Error Loading Exercises.plist")
                }
            }
            
        }
    }
    
    @IBAction func repSchemeDidSet(_ sender: Any) {
        print("Rep Scheme was set...Validating Rep Scheme")
        let setNum: Int? = Int(self.sets.text!)
        let repNum: Int? = Int(self.reps.text!)
        if let s = setNum, let r = repNum {
            //set current rep Scheme
            self.currRepScheme = [s,r]
            //print("Current Rep Scheme: \(self.currRepScheme)")
            //setting Delegates and Data Source
            setCollectionView.delegate = self
            setCollectionView.dataSource = self
            
            //rest rep/scheme - don't want to add on to/stack
            self.repScheme = []
            //let s: Int? = Int(self.sets.text!)
            for _ in 0 ..< s {
                self.repScheme.append(0)
            }
            
            //load the rep/set scheme
            setCollectionView.reloadData()
            setCollectionView.isHidden = false
            
            
            //setting gesture recongizers
            /*
            let singleTapGesutre = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
            singleTapGesutre.numberOfTapsRequired = 1
            singleTapGesutre.numberOfTouchesRequired = 1
            setCollectionView.addGestureRecognizer(singleTapGesutre)
            */
        } else {
            //Show UIAlert Controller for Invalid Rep Scheme
            let alert = UIAlertController(title: "Invalid Rep Scheme Entered", message: "Please enter number of sets x reps you intend to complete for this exercise", preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            print("Invalid Rep Scheme, need to enter set x rep")
        }
    }
    
    /*
    @objc func singleTap(_ gesture: UITapGestureRecognizer) {
        let p: CGPoint = gesture.location(in: self.setCollectionView)
        let indexPath: IndexPath? = self.setCollectionView.indexPathForItem(at: p)
        if let index = indexPath {
            if let myCell = self.setCollectionView.cellForItem(at: index) as? setCell {
                var updatedNumber = (Int((myCell.set.titleLabel?.text!)!))! + 1
                //var updatedNumber = (Int(myCell.reps.text!)! + 1)
                let maxReps = self.currRepScheme[1]
                if updatedNumber > maxReps {
                   updatedNumber = 0
                }
                self.repScheme[index[1]] = updatedNumber
                print(self.repScheme)
                myCell.set.titleLabel?.text = String(updatedNumber)
                //myCell.reps.text = String(updatedNumber) //we can force unwrap since we know we always intialize it with text
            } else {
                print("selected cell could not be converted to modeled \"setCell\"")
            }
        } else {
            print("Couldn't find index path")
        }
    }
 */
 
    
    //Collection View Protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repScheme.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = setCollectionView.dequeueReusableCell(withReuseIdentifier: "setCell", for: indexPath) as! setCell
        cell.set.setTitle("0", for: .normal)
        cell.max = self.currRepScheme[1]
        //cell.reps.text = "0"
        
        return cell
    }
    

    @IBAction func saveWorkout(_ sender: Any) {
        if let w = workoutModel {
            do {
                print("saving an object")
                print(w)
                try AppDelegate.viewContext.save()
                AppDelegate.viewContext.reset()
                let fetchWorkouts: NSFetchRequest<Workout> = Workout.fetchRequest()
                let res = try? AppDelegate.viewContext.fetch(fetchWorkouts)
                if let workouts = res {
                    print(workouts.count)
                } else {
                    print("couldn't fetch")
                }
            } catch {
                print("could not save workout")
            }
        } else {
            print("no workout to save")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addExercise(_ sender: Any) {
        //validate weight, rep, set, exercise
        if validateInputFields() {
            if let _ = self.workoutModel {
                
            } else {
                self.workoutModel = Workout(context: AppDelegate.viewContext)
            }
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_US")
            self.workoutModel!.date = dateFormatter.string(from: date)
            
            let exerciseModel = Exercise(context: AppDelegate.viewContext)
            exerciseModel.exerciseName = self.exerciseDropDown.text!
            exerciseModel.setScheme = Int16(self.currRepScheme[0])
            exerciseModel.repScheme = Int16(self.currRepScheme[1])
            exerciseModel.weight = Int16(self.weight.text!)!
            
            
            for (set, rep) in self.repScheme.enumerated() {
                let exerciseRecord = ExerciseRecord(context: AppDelegate.viewContext)
                exerciseRecord.set = Int16(set + 1) //we add one because enumerated inex of array starts at 0
                exerciseRecord.rep = Int16(rep)
                exerciseModel.addToExerciseRecords(exerciseRecord)
            }
 
            self.workoutModel!.addToExercises(exerciseModel)
        } else {
            //show alert if invalid exercise entered
            let alert = UIAlertController(title: "Invalid Exercise Entered", message: "Please enter proper fields in order to complete exercise", preferredStyle: .alert)
            let action = UIAlertAction(title: "Continue", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        clearFields()
        
    }
    func validateInputFields() -> Bool {
        //consider making "weight" field optional
        if !self.sets.text!.isEmpty && !self.reps.text!.isEmpty && !self.exerciseDropDown.text!.isEmpty && !self.weight.text!.isEmpty {
            print("inputs are valid")
            return true
        } else {
            print("inputs are invalid")
            return false
        }
    }
    func clearFields()  {
        self.sets.text = ""
        self.reps.text = ""
        self.exerciseDropDown.text = ""
        self.weight.text = ""
        self.currRepScheme = [0,0]
        setCollectionView.isHidden = true
        setCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            if let _ = self.workoutModel {
                AppDelegate.viewContext.delete(self.workoutModel!)
            }
        }
    }
    
}
