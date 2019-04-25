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


class addExerciseViewController: UIViewController {
    let exercises: [String] = ["Squat", "Bench Press", "Deadlift", "Shoulder Press", "Military Press", "Barbell Curl", "Incline Bench Press", "Front Squat", "Bent Over Row", "Hex Bar Deadlift",
                               "Sumo Deadlift", "Hip Thrust", "Romanian Deadlift", "Close Grip Bench Press", "Rack Pull", "Preacher Curl", "Barbell Shrug", "T-Bar Row", "Pendlay Row", "Decline Bench Press", "Tricep Extension", "Box Squat", "Upright Row", "Bulgarian Split Squat", "Stiff Legged Deadlift", "Lying Tricep Extension", "Wrist Curl", "Barbell Lunge", "Good Morning", "Zercher Squat", "Split Squat", "Landmine Squat", "Pull Ups", "Push Ups", "Dips", "Chin Ups", "Bodyweight Squat", "Muscle Ups", "One Arm Push Ups", "Sit Ups", "Single Leg Squat", "Burpees", "Crunches", "Lunge", "Handstand Push Ups", "Power Clean", "Snatch", "Clean and Jerk", "Clean", "Push Press", "Overhead Squat", "Clean and Press", "Thruster", "Power Snatch", "Push Jerk", "Dumbbell Bench Press", "Dumbbell Curl", "Dumbbell Shoulder Press", "Incline Dumbbell Bench Press", "Dumbbell Row", "Dumbbell Lateral Raise", "Dumbbell Hammer Curl", "Dumbbell Tricep Extension", "Goblet Squat", "Dumbbell Fly", "Dumbbell Bulgarian", "Arnold Press", "Dumbbell Shrug", "Dumbbell Front Raise", "Dumbbell Lunge", "Incline Dumbbell Curl Standards", "Lying Dumbbell Tricep Extension", "Dumbbell Pullover", "Dumbbell Concentration Curl", "Decline Dumbbell Bench Press", "Incline Dumbbell Fly", "Dumbbell Reveser Fly", "Machine Sled Leg Press", "Machine Horizontal Leg Press", "Machine Chest Press", "Machine Leg Extension", "Machine Shoulder Press", "Machine Seated Leg Curl", "Machine Calf Raise", "Machine Seated Calf Raise", "Machine Lying Leg Curl", "Machine Pec Deck Fly", "Machine Hack Squat", "Machine Vertical Leg Press", "Machine Hip Abduction", "Machine Hip Adduction", "Lat Pulldown", "Seated Cable Row", "Tricep Pushdown", "Trciep Rope Pushdown", "Face Pull", "Cable Fly"]
    @IBOutlet weak var exerciseDropDown: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("addExerciseViewController Loaded")
        self.exerciseDropDown.optionArray = ["Option 1", "Option 2", "Option 3"]
        self.exerciseDropDown.optionIds = [1,2,3]
        
    }
    
    
}
