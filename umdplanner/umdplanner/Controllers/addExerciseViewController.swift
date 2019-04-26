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


class addExerciseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var setCollectionView: UICollectionView!
    @IBOutlet weak var exerciseDropDown: DropDown!
    @IBOutlet weak var sets: UITextField!
    @IBOutlet weak var reps: UITextField!
    
    var repScheme: [Int] = []
    var exerciseTypes: ExerciseTypes? = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExerciseViewController Loaded")
        
        loadPlist()
        //Exercise Drop Down Customization
        exerciseDropDown.isSearchEnable = true
        exerciseDropDown.selectedRowColor = .red
        //exerciseDropDown
        exerciseDropDown.optionArray = exerciseTypes!.map{$0.Name}
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
                print("exercises.plist loaded into exerciseTypes variable")
                print(self.exerciseTypes)
                if let es = exerciseTypes {
                    for e in es {
                        print(e)
                    }
                } else {
                    print("what")
                }
            }
            
        }
    }
    @IBAction func repSchemeDidSet(_ sender: Any) {
        print("Rep Scheme was set...Validating Rep Scheme")
        let num: Int? = Int(self.sets.text!)
        if let s = num {
    
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
        } else {
            print("Invalid Rep Scheme")
        }
    }
    
    //Collection View Protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repScheme.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = setCollectionView.dequeueReusableCell(withReuseIdentifier: "setCell", for: indexPath) as! setCell
        cell.backgroundColor = .red
        cell.reps.text = "0"
        
        return cell
    }
    
}
