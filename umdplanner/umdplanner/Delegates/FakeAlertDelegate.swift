//
//  FakeAlertDelegate.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//

protocol FakeAlertDelegate: class {
    func okTapped(assignName:String, schoolClass:String, priority:String, date:String)
    func cancelTapped()
}

