//
//  Settings.swift
//  Froggy Math
//
//  Created by David Chu on 6/14/23.
//

import Foundation

class Settings {
    static let keyLastWeek = "last-week" // the week we're tracking weekly stats for
    static let keyLastDay = "last-day" // the day we're tracking daily stats for
    static let keyLastEvolved = "last-evolved" // the last day the frog stage changed. Cannot change 2 stages in one day
    static let keyFrogStage = "frog-stage" // what current stage of the egg are we on
    static let keyLatestFrog = "latest-frog" // if frog-stage = 7, what the most recent frog was
    static let keyTimesTable = "times-table" // which numbers' times tables we are using
    static let keyLanguage = "language" // whether the buttons show up in arabic numerals or something else
    static let keyFliesInAccuracyMode = "flies-in-accuracy-mode" // how many flies we got in accuracy mode since we last maxed out all flies
    static let keyFliesInSpeedMode = "flies-in-speed-mode"
    static let keyFliesInZenMode = "flies-in-zen-mode"
    static let keyAccuracyWeek = "accuracy-week" // max accuracy over the last week
    static let keyAccuracyDay = "accuracy-day"
    static let keySpeedWeek = "speed-week"
    static let keySpeedDay = "speed-day"
    static let keyFrogs = "frogs" // array of all frogs
    static let keyCoins = "coins" // how many coins you have
    static let keyDuelist0Frog = "duelist-0-frog" // frog last used by duelist 0
    static let keyDuelist1Frog = "duelist-1-frog"
    static let keyDuelist0Handicap = "duelist-0-handicap"
    static let keyDuelist1Handicap = "duelist-1-handicap"
    
    // call function on init
    static func registerDefaults() {
        let now = Date()
        UserDefaults.standard.register(defaults: [
            keyLastWeek: now,
            keyLastDay: now,
            keyLastEvolved: NSCalendar.current.date(byAdding: .day, value: -1, to: now)!, // last evolved NOT today by default
            keyFrogStage: 7, // default stage = 7 so we can trigger new egg alert, which will reset stage to 0
            keyLatestFrog: FrogType.basic.rawValue,
            keyTimesTable: Array(2...9),
            keyLanguage: NumberStyles.arabic.rawValue,
            keyFliesInAccuracyMode: 0,
            keyFliesInSpeedMode: 0,
            keyFliesInZenMode: 0,
            keyAccuracyWeek: 0.0,
            keyAccuracyDay: 0.0,
            keySpeedWeek: 0.0,
            keySpeedDay: 0.0,
            keyFrogs: [FrogType.basic.rawValue],
            keyCoins: 0,
            keyDuelist0Frog: FrogType.basic.rawValue,
            keyDuelist1Frog: FrogType.basic.rawValue,
            keyDuelist0Handicap: 0,
            keyDuelist1Handicap: 0
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
    
    static func didLastEvolveToday() -> Bool {
        let now = Date()
        let lastEvolved = UserDefaults.standard.object(forKey: keyLastEvolved) as! Date
        return NSCalendar.current.isDate(now, inSameDayAs: lastEvolved)
    }
    
    static func setLastEvolved() {
        UserDefaults.standard.set(Date(), forKey: keyLastEvolved)
    }
    
    static func getFrogStage() -> Int {
        return UserDefaults.standard.integer(forKey: keyFrogStage) % 8
    }
    
    static func incrementFrogStage() -> Int {
        let newStage = (getFrogStage() + 1) % 8
        UserDefaults.standard.set(newStage, forKey: keyFrogStage)
        return newStage
    }
    
    static func getLatestFrog() -> FrogType {
        return FrogType(rawValue: UserDefaults.standard.string(forKey: keyLatestFrog)!)!
    }
    
    static func setLatestFrog(frog: FrogType) {
        UserDefaults.standard.set(frog.rawValue, forKey: keyLatestFrog)
    }
    
    static func getTimesTable() -> [Int] {
        return UserDefaults.standard.array(forKey: keyTimesTable) as! [Int]
    }
    
    static func setTimesTable(_ table: [Int]) {
        UserDefaults.standard.set(table, forKey: keyTimesTable)
    }
    
    static func getLanguage() -> NumberStyles {
        return NumberStyles(rawValue: UserDefaults.standard.string(forKey: keyLanguage)!)!
    }
    
    static func setLanguage(language: NumberStyles) {
        UserDefaults.standard.set(language.rawValue, forKey: keyLanguage)
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
    
    static func resetFlies() {
        UserDefaults.standard.set(0, forKey: keyFliesInAccuracyMode)
        UserDefaults.standard.set(0, forKey: keyFliesInSpeedMode)
        UserDefaults.standard.set(0, forKey: keyFliesInZenMode)
    }
    
    static func getAccuracyWeek() -> Double {
        return UserDefaults.standard.double(forKey: keyAccuracyWeek)
    }
    
    static func resetAccuracyWeek() {
        UserDefaults.standard.set(0.0, forKey: keyAccuracyWeek)
    }
    
    static func getAccuracyDay() -> Double {
        return UserDefaults.standard.double(forKey: keyAccuracyDay)
    }
    
    static func resetAccuracyDay() {
        UserDefaults.standard.set(0.0, forKey: keyAccuracyDay)
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
    
    static func resetSpeedWeek() {
        UserDefaults.standard.set(0.0, forKey: keySpeedWeek)
    }
    
    static func getSpeedDay() -> Double {
        return UserDefaults.standard.double(forKey: keySpeedDay)
    }
    
    static func resetSpeedDay() {
        UserDefaults.standard.set(0.0, forKey: keySpeedDay)
    }
    
    static func updateSpeed(_ num: Double) {
        if getSpeedWeek() < num {
            UserDefaults.standard.set(num, forKey: keySpeedWeek)
        }
        if getSpeedDay() < num {
            UserDefaults.standard.set(num, forKey: keySpeedDay)
        }
    }
    
    static func getFrogs() -> [FrogType] {
        return UserDefaults.standard.stringArray(forKey: keyFrogs)!.map({FrogType(rawValue: $0)!})
    }
    
    static func addFrog(_ frog: FrogType) {
        var frogs = getFrogs()
        guard !frogs.contains(frog) else {
            return
        }
        frogs.append(frog)
        UserDefaults.standard.set(frogs.map({$0.rawValue}), forKey: keyFrogs)
    }
    
    static func addCoins(_ coins: Int) {
        let existingCoins = UserDefaults.standard.integer(forKey: keyCoins)
        UserDefaults.standard.set(existingCoins + coins, forKey: keyCoins)
    }
    
    static func getDuelist0Frog() -> FrogType {
        return FrogType(rawValue: UserDefaults.standard.string(forKey: keyDuelist0Frog)!)!
    }
    
    static func setDuelist0Frog(_ frog: FrogType) {
        UserDefaults.standard.set(frog.rawValue, forKey: keyDuelist0Frog)
    }
    
    static func getDuelist1Frog() -> FrogType {
        return FrogType(rawValue: UserDefaults.standard.string(forKey: keyDuelist1Frog)!)!
    }
    
    static func setDuelist1Frog(_ frog: FrogType) {
        UserDefaults.standard.set(frog.rawValue, forKey: keyDuelist1Frog)
    }
    
    static func getDuelist0Handicap() -> Int {
        return UserDefaults.standard.integer(forKey: keyDuelist0Handicap)
    }
    
    static func setDuelist0Handicap(_ num: Int) {
        UserDefaults.standard.set(num, forKey: keyDuelist0Handicap)
    }
    
    static func getDuelist1Handicap() -> Int {
        return UserDefaults.standard.integer(forKey: keyDuelist1Handicap)
    }
    
    static func setDuelist1Handicap(_ num: Int) {
        UserDefaults.standard.set(num, forKey: keyDuelist1Handicap)
    }
}
