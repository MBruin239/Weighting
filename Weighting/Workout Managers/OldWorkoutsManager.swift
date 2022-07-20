//
//  OldWorkoutsManager.swift
//  Weighting
//
//  Created by Michael  Bruin on 7/6/22.
//

import Foundation

protocol OldWorkoutsDelegate {
    func oldWorkoutsOnWorkoutEdited(workout: Workout)
    func oldWorkoutsRefreshViews()
}

class OldWorkoutsManager {
    var oldWorkoutsDictionary = [String:[Workout]]()
    var workoutNames: [String] = []
    var currentWorkoutName: String?
    var currentWorkoutIndex = 0
    
    var delegate:OldWorkoutsDelegate?

    init(savedWorkoutKey: String) {
        if let workoutsDictionary = getOldWorkouts(key: savedOldWorkoutsKey) {
            oldWorkoutsDictionary = workoutsDictionary
            workoutNames = [String](oldWorkoutsDictionary.keys)
        }
    }
    
    func saveOldWorkouts(key: String) {
        do {
            try userDefaults.encode(oldWorkoutsDictionary, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func getOldWorkouts(key: String) -> [String:[Workout]]? {
        do {
            let dictionary = try userDefaults.decode([String:[Workout]].self, forKey: key)
            return dictionary
        } catch {
            print(error)
        }
        return nil
    }
    
    func getWorkoutNames() -> [String] {
        workoutNames = [String](oldWorkoutsDictionary.keys).sorted()
        
        return workoutNames
    }
    
    func setOldWorkoutsCurrentWorkoutNameTo(name: String) {
        currentWorkoutName = name
    }
    
    func getOldWorkoutArrayWith(name: String) -> [Workout] {
        let workoutArray = oldWorkoutsDictionary[name] ?? []
        return workoutArray
    }
    
    func updateOldWorkoutsDictionaryWith(dictionary: [String:Workout]) {
        for (key, val) in dictionary {
            var array = oldWorkoutsDictionary[key] ?? [Workout]()
            array.append(val)
            oldWorkoutsDictionary.updateValue(array, forKey: key)
        }
        saveOldWorkouts(key: savedOldWorkoutsKey)
    }
    
    func updateOldWorkoutsDictionaryWith(value: [Workout], key: String) {
        oldWorkoutsDictionary.updateValue(value, forKey: key)
    }
    
    func removeWorkout(index: Int) {
        print("Remove workout: \(index)")
        guard var oldWorkoutArray = oldWorkoutsDictionary[currentWorkoutName!] else {
            print("Error removing workout: No workout array for: \(currentWorkoutName ?? "nil")")
            return
        }
        guard oldWorkoutArray.count >= index else {
            print("Error removing workout: Index out of bounds")
            return
        }
        
        let oldWorkoutToRemove = oldWorkoutArray[index]
        
        print("Workout to be removed: \(oldWorkoutToRemove)")
        
        oldWorkoutArray.remove(at: index)
        oldWorkoutsDictionary.updateValue(oldWorkoutArray, forKey:currentWorkoutName ?? oldWorkoutToRemove.workoutName)
        
        saveOldWorkouts(key: savedOldWorkoutsKey)
        
        delegate?.oldWorkoutsRefreshViews()
    }
    
}
