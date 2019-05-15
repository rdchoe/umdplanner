//
//  ClassFakeAlertDelegate.swift
//  umdplanner
//
//  Created by Robert Choe on 5/13/19.
//  Copyright © 2019 group42. All rights reserved.
//

protocol ClassFakeAlertDelegate: class {
    func okTapped(className: String, classStart: String, classEnd: String, daysMeeting: String)
    func cancelTapped()
}
