//
//  Coordinator.swift
//  Weighting
//
//  Created by Michael  Bruin on 7/14/22.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
