//
//  Settings.swift
//  Froggy Math
//
//  Created by David Chu on 6/14/23.
//

import Foundation

class Settings {
    static let keyLastWeek = "last-week" // the week we're tracking weekly stats for
    static let keyLastDay = "last-day" // when the flies/frog stage was last recalculated + the day we're tracking daily stats for
    static let keyFrogStage = "frog-stage" // what current stage of the egg are we on
    static let keyTimesTable = "times-table" // which numbers' times tables we are using
    static let keyFliesInAccuracyMode = "flies-in-accuracy-mode" // how many flies we got in accuracy mode since we last maxed out all flies
    static let keyFliesInSpeedMode = "flies-in-speed-mode"
    static let keyFliesInZenMode = "flies-in-zen-mode"
    static let keyAccuracyWeek = "accuracy-week" // max accuracy over the last week
    static let keyAccuracyDay = "accuracy-day"
    static let keySpeedWeek = "speed-week"
    static let keySpeedDay = "speed-day"
    
    // call function on init
    static func registerDefaults() {
        let now = Date()
        UserDefaults.standard.register(defaults: [
            keyLastWeek: now,
            keyLastDay: now,
            keyFrogStage: 0,
            keyTimesTable: Array(2...9),
            keyFliesInAccuracyMode: 0,
            keyFliesInSpeedMode: 0,
            keyFliesInZenMode: 0,
            keyAccuracyWeek: 0.0,
            keyAccuracyDay: 0.0,
            keySpeedWeek: 0.0,
            keySpeedDay: 0.0
        ])
    }
    
    static func isSameWeek() -> Bool {
        let now = Date()
        let lastWeek = UserDefaults.standard.object(forKey: keyLastWeek) as! Date
        return NSCalendar.current.isDate(now, equalTo: lastWeek, toGranularity: .weekOfYear)
    }
    
    static func isSameDay() -> Bool {
        let now = Date()
        let lastDay = UserDefaults.standard.object(forKey: keyLastDay) as! Date
        return NSCalendar.current.isDate(now, equalTo: lastDay, toGranularity: .day)
    }
    
    static func refreshDate() {
        let now = Date()
        if !isSameWeek() {
            UserDefaults.standard.set(now, forKey: keyLastWeek)
        }
        if !isSameDay() {
            UserDefaults.standard.set(now, forKey: keyLastDay)
        }
    }
    
    static func getFrogStage() -> Int {
        return UserDefaults.standard.integer(forKey: keyFrogStage) % 7
    }
    
    static func setFrogStage(num: Int) {
        UserDefaults.standard.set(num % 7, forKey: keyFrogStage)
    }
    
    static func getTimesTable() -> [Int] {
        return UserDefaults.standard.array(forKey: keyTimesTable) as! [Int]
    }
    
    static func setTimesTable(_ table: [Int]) {
        UserDefaults.standard.set(table, forKey: keyTimesTable)
    }
    
    static func getFliesInAccuracyMode() -> Int {
        return UserDefaults.standard.integer(forKey: keyFliesInAccuracyMode)
    }
    
    static func updateFliesInAccuracyMode(solved: Int) {
        guard solved > 0 else {
            return
        }
        let oldFlies = getFliesInAccuracyMode()
        guard oldFlies != FlyCounter.maxFlies else {
            return
        }
        let newFlies = min(FlyCounter.maxFlies, oldFlies + solved)
        UserDefaults.standard.set(newFlies, forKey: keyFliesInAccuracyMode)
    }
    
    static func getFliesInSpeedMode() -> Int {
        return UserDefaults.standard.integer(forKey: keyFliesInSpeedMode)
    }
    
    static func updateFliesInSpeedMode(solved: Int) {
        guard solved > 0 else {
            return
        }
        let oldFlies = getFliesInSpeedMode()
        guard oldFlies != FlyCounter.maxFlies else {
            return
        }
        let newFlies = min(FlyCounter.maxFlies, oldFlies + solved)
        UserDefaults.standard.set(newFlies, forKey: keyFliesInSpeedMode)
    }
    
    static func getFliesInZenMode() -> Int {
        return UserDefaults.standard.integer(forKey: keyFliesInZenMode)
    }
    
    static func updateFliesInZenMode(solved: Int) {
        guard solved > 0 else {
            return
        }
        let oldFlies = getFliesInZenMode()
        guard oldFlies != FlyCounter.maxFlies else {
            return
        }
        let newFlies = min(FlyCounter.maxFlies, oldFlies + solved)
        UserDefaults.standard.set(newFlies, forKey: keyFliesInZenMode)
    }
    
    static func getAccuracyWeek() -> Double {
        return UserDefaults.standard.double(forKey: keyAccuracyWeek)
    }
    
    static func getAccuracyDay() -> Double {
        return UserDefaults.standard.double(forKey: keyAccuracyDay)
    }
    
    static func updateAccuracy(_ num: Double) {
        if getAccuracyWeek() < num {
            UserDefaults.standard.set(num, forKey: keyAccuracyWeek)
        }
        if getAccuracyDay() < num {
            UserDefaults.standard.set(num, forKey: keyAccuracyDay)
        }
    }
    
    static func getSpeedWeek() -> Double {
        return UserDefaults.standard.double(forKey: keySpeedWeek)
    }
    
    static func getSpeedDay() -> Double {
        return UserDefaults.standard.double(forKey: keySpeedDay)
    }
    
    static func updateSpeed(_ num: Double) {
        if getSpeedWeek() < num {
            UserDefaults.standard.set(num, forKey: keySpeedWeek)
        }
        if getSpeedDay() < num {
            UserDefaults.standard.set(num, forKey: keySpeedDay)
        }
    }
}
