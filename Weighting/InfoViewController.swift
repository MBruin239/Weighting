//
//  InfoViewController.swift
//  Weighting
//
//  Created by Michael  Bruin on 7/14/22.
//

import UIKit

class InfoViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?

    var currentWorkout: Workout?

    var completionHandler: ((String) -> Int)?

    // MARK: View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onButtonTap()
    {
        let result = completionHandler?("FUS-ROH-DAH!!!")

        print("completionHandler returns… \(String(describing: result))")
    }
    
    
}
