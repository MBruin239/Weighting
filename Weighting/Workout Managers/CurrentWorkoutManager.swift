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
    var currentWorkoutsDictionary = [String:Workout]()
    var currentWorkout: Workout?
    
    var delegate: CurrentWorkoutDelegate?
    
    func addWorkoutSet(workoutName: String, weight: String, reps: String){
        setWorkoutWithName(workout: workoutName)
        let newSet = WorkoutSet.init(workoutName: workoutName, weight: weight, reps: reps)

        currentWorkout!.set.append(newSet)
        
        currentWorkoutsDictionary.updateValue(currentWorkout!, forKey: newSet.workoutName)
        
        delegate?.updateCurrentWorkout(workout: currentWorkout!)
        
        delegate?.currentWorkoutRefreshViews()
    }
    
    func resetCurrentWorkout() {
        currentWorkoutsDictionary.removeAll()
    }

    func setWorkout(workout: Workout){
        currentWorkout = workout
        
        delegate?.updateCurrentWorkout(workout: workout)
        
        delegate?.currentWorkoutRefreshViews()
    }
    
    func setWorkoutWithName(workout: String){
        guard let workout = currentWorkoutsDictionary[workout] else {
            setWorkout(workout: Workout.init(workoutName: workout, set: [], date: Date(), index: 0))
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
