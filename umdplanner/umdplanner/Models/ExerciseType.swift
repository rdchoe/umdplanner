//
//  ExerciseType.swift
//  umdplanner
//
//  Created by Robert Choe on 4/25/19.
//  Copyright © 2019 group42. All rights reserved.
//

import Foundation


struct ExerciseType: Codable {
    var Name: String
    var Category: String
}

typealias ExerciseTypes = [ExerciseType]
