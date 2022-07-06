//
//  CurrentWorkoutView.swift
//  Weighting
//
//  Created by Michael  Bruin on 9/22/21.
//

import UIKit

class CurrentWorkoutView: UIView {
    
    @IBOutlet var setsTableView: UITableView! { didSet { setsTableView.delegate = self; setsTableView.dataSource = self} }
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    
    public var currentWorkoutsDictionary = [String:Workout]()
    var currentWorkout: Workout?
    
// MARK: Work functions
    func resetCurrentWorkout() {
        currentWorkoutsDictionary.removeAll()
    }

    func setWorkout(workout: Workout){
        currentWorkout = workout
        self.workoutTitleLabel.text = workout.workoutName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        self.date.text = dateFormatter.string(from: workout.date)
        
        self.setsTableView.reloadData()
    }
    
    func setWorkoutWithName(workout: String){
        guard let workout = currentWorkoutsDictionary[workout] else {
            setWorkout(workout: Workout.init(workoutName: workout, set: [], date: Date(), index: 0))
            self.setsTableView.reloadData()
            return
        }
        currentWorkout = workout
        
        self.workoutTitleLabel.text = currentWorkout?.workoutName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        self.date.text = dateFormatter.string(from: currentWorkout!.date)
        
        self.setsTableView.reloadData()
    }
    
    func addWorkoutSetToCurrentWorkout(workoutSet: WorkoutSet){
        currentWorkout?.set.append(workoutSet)
        
        currentWorkoutsDictionary.updateValue(currentWorkout!, forKey: workoutSet.workoutName)

        self.setsTableView.reloadData()
        
    }

}

// MARK: Table Delegate functions
extension CurrentWorkoutView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentWorkout == nil) {
            return 0;
        }
        return self.currentWorkout!.set.count
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

        if (self.currentWorkout?.set.count)! > 0 {
            let set = currentWorkout!.set[indexPath.row]
            let stringValue: String
            stringValue = String(format: "[ %@ , %@ ]", set.reps, set.weight)

            cell?.textLabel!.text = stringValue
            }

        return cell!
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

