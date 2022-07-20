//
//  MainCoordinator.swift
//  Weighting
//
//  Created by Michael  Bruin on 7/14/22.
//

import UIKit

let savedOldWorkoutsKey = "savedWorkouts"
let userDefaults = UserDefaults.standard

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var workoutsManager = WorkoutsManager()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewControllerProvider.mainViewController
        vc.coordinator = self
        vc.workoutsManager = workoutsManager
        workoutsManager.delegate = vc
        
        navigationController.setNavigationBarHidden(true, animated: false)

        navigationController.pushViewController(vc, animated: false)
    }

    func displayInfo(of workout: Workout, action: @escaping (String) -> Int) {
        let infoVC = ViewControllerProvider.infoViewController(for: workout)
        infoVC.coordinator = self
        //infoVC.delegate = delegate
        infoVC.completionHandler = action
        navigationController.present(infoVC, animated: true)
    }
}
