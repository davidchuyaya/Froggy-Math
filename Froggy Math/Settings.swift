//
//  Settings.swift
//  Froggy Math
//
//  Created by David Chu on 6/14/23.
//

import Foundation

class Settings {
    static let keyLastOpened = "last-opened" // when was the app last opened
    static let keyFrogStage = "frog-stage" // what current stage of the egg are we on
    static let keyTimesTable = "times-table" // which numbers' times tables we are using
    
    // call function on init
    static func registerDefaults() {
        UserDefaults.standard.register(defaults: [
            keyLastOpened: Date(),
            keyFrogStage: 0,
            keyTimesTable: Array(2...9)
        ])
    }
    
    static func getLastOpened() -> Date {
        return UserDefaults.standard.object(forKey: keyLastOpened) as! Date
    }
    
    static func setLastOpened() {
        UserDefaults.standard.set(Date(), forKey: keyLastOpened)
    }
    
    static func getFrogStage() -> Int {
        return UserDefaults.standard.integer(forKey: keyFrogStage)
    }
    
    static func setFrogStage(num: Int) {
        UserDefaults.standard.setValue(num, forKey: keyFrogStage)
    }
    
    static func getTimesTable() -> [Int] {
        return UserDefaults.standard.array(forKey: keyTimesTable) as! [Int]
    }
    
    static func setTimesTable(_ table: [Int]) {
        UserDefaults.standard.set(table, forKey: keyTimesTable)
    }
}
