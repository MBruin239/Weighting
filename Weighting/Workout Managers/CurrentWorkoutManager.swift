//
//  CurrentWorkoutManager.swift
//  Weighting
//
//  Created by Michael  Bruin on 7/16/22.
//

import Foundation

protocol CurrentWorkoutDelegate {
    func currentWorkoutRefreshViews()
    func updateCurrentWorkout(workout: Workout)
}

class CurrentWorkoutsManager {
    var currentWorkoutIndex: Int {
        get{
            return userDefaults.integer(forKey: "currentWorkoutIndex")
        }
        set {
            userDefaults.set(newValue, forKey:"currentWorkoutIndex")
            userDefaults.synchronize()
        }
    }
    
    var currentWorkoutsDictionary = [String:Workout]()
    var currentWorkout: Workout?
    var newWorkoutNames = [String]()
    
    var delegate: CurrentWorkoutDelegate?
    
    func addWorkoutSet(workoutName: String, weight: String, reps: String){
        setWorkoutWithName(workoutName: workoutName)
        if var currentWorkout = currentWorkout {
            let newSet = WorkoutSet.init(workoutName: workoutName, weight: weight, reps: reps)

            currentWorkout.set.append(newSet)
            
            addWorkoutToCurrentWorkoutDictionary(workout: currentWorkout)
        }
        
        delegate?.currentWorkoutRefreshViews()
    }
    
    private func addWorkoutToCurrentWorkoutDictionary(workout: Workout){
        if !checkCurrentWorkoutsDictionaryForWorkout(workoutName: workout.workoutName){
            currentWorkoutIndex += 1
        }

        currentWorkoutsDictionary.updateValue(workout, forKey: workout.workoutName)
        
        delegate?.updateCurrentWorkout(workout: workout)
    }
    
    func checkCurrentWorkoutsDictionaryForWorkout(workoutName: String) -> Bool {
        let currentWorkoutNames = [String](currentWorkoutsDictionary.keys)
        for name in currentWorkoutNames {
            if name == workoutName {
                return true
            }
        }
        return false
    }
    
    func getCurrentWorkoutNames() -> [String] {
        let workoutNames = [String](currentWorkoutsDictionary.keys).sorted()
        let combined = Array(Set(workoutNames + newWorkoutNames)).sorted()

        return combined
    }
    
    func resetCurrentWorkout() {
        currentWorkoutsDictionary.removeAll()
    }

    func setWorkout(workout: Workout){
        currentWorkout = workout
        
        delegate?.updateCurrentWorkout(workout: workout)
        
        delegate?.currentWorkoutRefreshViews()
    }
    
    func setWorkoutWithName(workoutName: String){
        guard let workout = currentWorkoutsDictionary[workoutName] else {
            newWorkoutNames.append(workoutName)
            setWorkout(workout: Workout.init(workoutName: workoutName, set: [], date: Date(), index: currentWorkoutIndex))
            return
        }
        setWorkout(workout: workout)
        
        delegate?.updateCurrentWorkout(workout: workout)
    }
    
    func handleRemoveSet(index: Int) {
        print("Remove set: \(index)")
        print(currentWorkout!.set[index])
        
        currentWorkout?.set.remove(at: index)
        currentWorkoutsDictionary.updateValue(currentWorkout!, forKey:currentWorkout!.workoutName)
        
        delegate?.currentWorkoutRefreshViews()
    }
    
}
