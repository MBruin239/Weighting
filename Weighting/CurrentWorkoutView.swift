//
//  CurrentWorkoutView.swift
//  Weighting
//
//  Created by Michael  Bruin on 9/22/21.
//

import UIKit

protocol CurrentWorkoutViewDelegate {
    func removeSetAtIndex(index: Int)
}

class CurrentWorkoutView: UIView {
    
    @IBOutlet var setsTableView: UITableView! { didSet { setsTableView.delegate = self; setsTableView.dataSource = self} }
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var delegate: CurrentWorkoutViewDelegate?
    
    var currentWorkout: Workout?
    
// MARK: Work functions

    func setWorkout(workout: Workout){
        currentWorkout = workout
        self.workoutTitleLabel.text = workout.workoutName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        self.date.text = dateFormatter.string(from: workout.date)
        
        self.setsTableView.reloadData()
    }
    
    private func handleRemoveSet(index: Int) {
        delegate?.removeSetAtIndex(index: index)
    }
}

// MARK: Table Delegate functions
extension CurrentWorkoutView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentWorkout = currentWorkout {
            return currentWorkout.set.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 21
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            }
        
        if let currentWorkout = currentWorkout {
            if (currentWorkout.set.count) > 0 {
                let set = currentWorkout.set[indexPath.row]
                let stringValue: String
                stringValue = String(format: "[ %@ , %@ ]", set.reps, set.weight)

                cell?.textLabel!.text = stringValue
                }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Remove action
        let remove = UIContextualAction(style: .destructive,
                                       title: "Remove") { [weak self] (action, view, completionHandler) in
                                        self?.handleRemoveSet(index: indexPath.row)
                                        completionHandler(true)
        }
        remove.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [remove])

        return configuration
    }
}

extension CurrentWorkoutView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

