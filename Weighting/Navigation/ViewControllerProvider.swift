//
//  ViewControllerProvider.swift
//  Weighting
//
//  Created by Michael  Bruin on 7/14/22.
//

import Foundation
import UIKit

enum ViewControllerProvider {
    static var mainViewController: MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        return viewController
    }

    static func infoViewController(for workout: Workout) -> InfoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        viewController.currentWorkout = workout
        return viewController
    }
}
