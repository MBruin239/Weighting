//
//  WorkoutsManager.swift
//  Weighting
//
//  Created by Michael  Bruin on 7/18/22.
//

import Foundation

protocol WorkoutsManagerDelegate {
    func onWorkoutEdited(workout: Workout)
    func refreshViews()
    func movePickerViewToRow(index: Int)
    func updateCurrentWorkout(workout: Workout)
}

class WorkoutsManager {
    var oldWorkoutsManager: OldWorkoutsManager
    var currentWorkoutsManager: CurrentWorkoutsManager
    
    var delegate:WorkoutsManagerDelegate?
    
    init(){
        oldWorkoutsManager = OldWorkoutsManager(savedWorkoutKey: savedOldWorkoutsKey)
        currentWorkoutsManager = CurrentWorkoutsManager()
        
        defer{
            oldWorkoutsManager.delegate = self
            currentWorkoutsManager.delegate = self
        }
    }
    
    func addWorkoutSet(workoutName: String, weight: String, reps: String){
        var newName = workoutName
        
        let workoutNames = getWorkoutNames()
        for i in 0..<workoutNames.count {
            let name = workoutNames[i]
            if name.caseInsensitiveCompare(workoutName) == .orderedSame {
                newName = name
                delegate?.movePickerViewToRow(index: i)
            }
        }
        
        currentWorkoutsManager.addWorkoutSet(workoutName: newName, weight: weight, reps: reps)
        
        if !workoutNames.contains(newName){
            oldWorkoutsManager.workoutNames.append(newName)
            delegate?.movePickerViewToRow(index: workoutNames.count-1)
        }
    }
    
    func finishCurrentWorkout() {
        let currentWorkoutsDictionary = currentWorkoutsManager.currentWorkoutsDictionary
        
        oldWorkoutsManager.updateOldWorkoutsDictionaryWith(dictionary: currentWorkoutsDictionary)
        
        currentWorkoutsManager.resetCurrentWorkout()
    }
    
    func getWorkoutNames() -> [String] {
        return oldWorkoutsManager.getWorkoutNames()
    }
    
    func getOldWorkoutsArray(workoutName: String) -> [Workout] {
        return oldWorkoutsManager.getOldWorkoutArrayWith(name: workoutName)
    }
    
    func setWorkoutName(name: String) {
        oldWorkoutsManager.setOldWorkoutsCurrentWorkoutNameTo(name: name)
        currentWorkoutsManager.setWorkoutWithName(workout: name)
    }
    
    func removeWorkout(index: Int) {
        oldWorkoutsManager.removeWorkout(index: index)
    }
    
    func removeSet(index: Int) {
        currentWorkoutsManager.handleRemoveSet(index: index)
    }
}

extension WorkoutsManager: OldWorkoutsDelegate {
    func oldWorkoutsOnWorkoutEdited(workout: Workout) {
        print(workout)
        delegate?.onWorkoutEdited(workout: workout)
    }
    
    func oldWorkoutsRefreshViews() {
        delegate?.refreshViews()
    }
}

extension WorkoutsManager: CurrentWorkoutDelegate {
    func currentWorkoutRefreshViews() {
        delegate?.refreshViews()
    }
    
    func updateCurrentWorkout(workout: Workout){
        delegate?.updateCurrentWorkout(workout: workout)
    }
}


