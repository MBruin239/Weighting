//
//  WorkoutSet.swift
//  Weighting
//
//  Created by Michael  Bruin on 9/17/21.
//

import Foundation
import UIKit

struct Workout: Codable{
    let workoutName: String
    var set: [WorkoutSet]
    let date: Date
    let index: NSInteger
}

struct WorkoutSet: Codable {
    let workoutName: String
    let weight: String
    let reps: String
}
