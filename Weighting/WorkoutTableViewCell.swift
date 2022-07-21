//
//  WorkoutTableViewCell.swift
//  Weighting
//
//  Created by Michael  Bruin on 9/20/21.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workoutTitleLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var cellWorkout: Workout?
    var setLabels: [UILabel] = []

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // code common to all your cells goes here
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setWorkout(workout: Workout){
        cellWorkout = workout
        self.workoutTitleLabel.text = workout.workoutName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        self.date.text = dateFormatter.string(from: workout.date)
        
        var index = 0
        if (setLabels.count != 0) {
            for label in self.setLabels {
                label.removeFromSuperview()
            }
        }
        
        for set in workout.set{
            let stringValue: String
            stringValue = String(format: "[ %@ , %@ ]", set.reps, set.weight)
            let label = UILabel(frame: CGRect(x: self.workoutTitleLabel.frame.origin.x + self.workoutTitleLabel.frame.width + 10, y: self.workoutTitleLabel.frame.origin.y + CGFloat((21*index)), width: 100, height: 21))
            label.text = stringValue
            self.contentView.addSubview(label)
            self.setLabels.append(label)
            index+=1
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
