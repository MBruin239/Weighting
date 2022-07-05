//
//  ViewController.swift
//  Weighting
//
//  Created by Michael  Bruin on 9/17/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let userDefaults = UserDefaults.standard

    let cellReuseIdentifier = "cell"
    public var currentWorkoutIndex = 0
    
    @IBOutlet weak var workoutTextField: UITextField! { didSet { workoutTextField.delegate = self } }
    @IBOutlet weak var repsTextField: UITextField! { didSet { repsTextField.delegate = self } }
    @IBOutlet weak var weightTextField: UITextField! { didSet { weightTextField.delegate = self } }
    @IBOutlet var workoutTableView: UITableView! { didSet { workoutTableView.delegate = self; workoutTableView.dataSource = self} }
    @IBOutlet var workoutPickerView: UIPickerView! { didSet { workoutPickerView.delegate = self; workoutPickerView.dataSource = self} }
    
    @IBOutlet weak var currentWorkoutView: CurrentWorkoutView!

    @IBOutlet var addSetBtn: UIButton!
    @IBOutlet var finishWorkoutBtn: UIButton!

    private var oldWorkoutsDictionary = [String:[Workout]]()
    private var oldWorkoutArray: [Workout] = []
    private var workoutNames: [String] = []
    var currentWorkout: Workout?

    // MARK: View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.moveTheViewWithKeyboard()
        self.hideKeyboardWhenTappedAround()

        getOldWorkouts(key: "savedWorkouts")

        self.registerTableViewCells()
        
        addSetBtn.addTarget(self, action: #selector(addSetAction), for: .touchUpInside)
        finishWorkoutBtn.addTarget(self, action: #selector(finishWorkoutAction), for: .touchUpInside)

        //saveOldWorkouts(key: "savedWorkouts")

        workoutNames = [String](oldWorkoutsDictionary.keys)
        
        oldWorkoutArray = oldWorkoutsDictionary[self.workoutNames[0]]!
        
        self.currentWorkout = Workout.init(workoutName: self.workoutNames[0], set: [], date: Date(), index: currentWorkoutIndex)
        currentWorkoutView.setWorkout(workout: self.currentWorkout!)

        workoutTableView.reloadData()
        workoutPickerView.reloadAllComponents()

    }
    
    func saveOldWorkouts(key: String) {
        do {
            try userDefaults.encode(oldWorkoutsDictionary, forKey: key)
            
        } catch {
            print(error)
        }
    }
    
    func getOldWorkouts(key: String) {
        do {
            oldWorkoutsDictionary = try userDefaults.decode([String:[Workout]].self, forKey: key)
        } catch {
            print(error)
        }
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "WorkoutTableViewCell",
                                  bundle: nil)
        self.workoutTableView.register(textFieldCell,
                                forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    @IBAction func addSetAction(sender: UIButton!) {
        print("Add set Button Clicked")
        
        var workoutName = workoutTextField.text!
        let workoutWeight = weightTextField.text!
        let workoutReps = repsTextField.text!

        for name in workoutNames {
            if name.caseInsensitiveCompare(workoutName) == .orderedSame {
                workoutName = name
            }
        }
        
        let newSet = WorkoutSet.init(workoutName: workoutName, weight: workoutWeight, reps: workoutReps)
        
       /* currentWorkoutView.setWorkout(workout: currentWorkout!)

        currentWorkoutView.currentWorkout?.set.append(newSet)
        currentWorkoutView.currentWorkoutsDictionary.updateValue(currentWorkoutView.currentWorkout!, forKey: workoutName)
        
        let set = Set(oldWorkoutsDictionary.keys)
        let union = set.union(currentWorkoutView.currentWorkoutsDictionary.keys)

        workoutNames = Array(union)*/
        currentWorkout?.set.append(newSet)
        currentWorkoutView.setWorkout(workout: currentWorkout!)
                
        oldWorkoutArray = oldWorkoutsDictionary[newSet.workoutName] ?? [Workout]()
        if currentWorkout?.index == oldWorkoutArray.first?.index {
            oldWorkoutArray.removeFirst()
        }
        
        oldWorkoutArray.insert(currentWorkout!, at: 0)
        oldWorkoutsDictionary.updateValue(oldWorkoutArray, forKey: newSet.workoutName)
        
        workoutNames = [String](oldWorkoutsDictionary.keys)
        
        workoutTableView.reloadData()
        workoutPickerView.reloadAllComponents()
    }
    
    @IBAction func finishWorkoutAction(sender: UIButton!) {
         print("Finish workout Button Clicked")
        
        self.workoutTableView.reloadData()
        self.workoutPickerView.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Picker View Delegate functions

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workoutNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("pickerView didSelectRow", row)
        oldWorkoutArray = oldWorkoutsDictionary[self.workoutNames[row]]!

        self.workoutTableView.reloadData()
        
        currentWorkoutIndex += 1
        //self.currentWorkout = Workout.init(workoutName: self.workoutNames[row], set: [], date: Date(), index: currentWorkoutIndex)
        currentWorkoutView.setWorkout(workout: self.currentWorkout!)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("pickerView titleForRow", row)
        workoutNames = [String](oldWorkoutsDictionary.keys)
        var title = ""
        if workoutNames.count > 0 {
            title = self.workoutNames[row]
            self.workoutTextField.text = title
        }
        return title
    }
    
    // MARK: Table Delegate functions
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.oldWorkoutArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let workout = oldWorkoutArray[indexPath.row]
        
        return CGFloat(70 + ((workout.set.count-1) * 21))
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        var cell : WorkoutTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? WorkoutTableViewCell
            if cell == nil {
                cell = WorkoutTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            }

        if self.oldWorkoutsDictionary.count > 0 {
            let workout = oldWorkoutArray[indexPath.row]
            cell!.setWorkout(workout: workout)
        }
        cell?.textLabel?.numberOfLines = 0

        return cell!
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    // MARK: Text Feild Delegate functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }
        
    // This function is called when you click return key in the text field.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        NSLog("textFieldShouldReturn")
        textField.resignFirstResponder();

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(textField.text!)")
        var lift = self.oldWorkoutsDictionary[textField.text!]
        if lift == nil {
            lift = []
        }
        if textField == self.workoutTextField {
            self.currentWorkout = Workout.init(workoutName: textField.text! as String, set: [], date: Date(), index: currentWorkoutIndex)
            currentWorkoutView.setWorkout(workout: self.currentWorkout!)
        } else if textField == self.repsTextField {
            
        } else if textField == self.weightTextField {
            
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true;
    }
        
    // This function is called when you input text in the textfield.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("textField should change characters")
        
        print("input text is : \(string)")
        
        return true
        
    }
    
    func makeFakeWorkOutData() {
         var workouts = [Workout].init()
         
         let workout = Workout.init(workoutName: "Bench Press", set: [WorkoutSet.init(workoutName: "Bench Press", weight: "185", reps: "10"), WorkoutSet.init(workoutName: "Bench Press", weight: "185", reps: "10"), WorkoutSet.init(workoutName: "Bench Press", weight: "185", reps: "10"), WorkoutSet.init(workoutName: "Bench Press", weight: "185", reps: "10")], date: Date(), index: currentWorkoutIndex)
         workouts.append(workout)
         currentWorkoutIndex += 1
         let workout2 = Workout.init(workoutName: "Bench Press", set: [WorkoutSet.init(workoutName: "Bench Press", weight: "185", reps: "10")], date: Date(), index: currentWorkoutIndex)
         workouts.append(workout2)

         self.oldWorkoutsDictionary.updateValue(workouts, forKey: workout.workoutName)
         
         workouts.removeAll()
         
         currentWorkoutIndex += 1
         let workout3 = Workout.init(workoutName: "Curl", set: [WorkoutSet.init(workoutName: "Curl", weight: "35", reps: "10"), WorkoutSet.init(workoutName: "Curl", weight: "35", reps: "10"), WorkoutSet.init(workoutName: "Curl", weight: "35", reps: "10"), WorkoutSet.init(workoutName: "Curl", weight: "25", reps: "10"), WorkoutSet.init(workoutName: "Curl", weight: "20", reps: "10")], date: Date(), index: currentWorkoutIndex)
         workouts.insert(workout3, at: 0)
         currentWorkoutIndex += 1
         let workout4 = Workout.init(workoutName: "Curl", set: [WorkoutSet.init(workoutName: "Curl", weight: "35", reps: "10")], date: Date(), index: currentWorkoutIndex)
         workouts.insert(workout4, at: 0)
         currentWorkoutIndex += 1
         let workout5 = Workout.init(workoutName: "Curl", set: [WorkoutSet.init(workoutName: "Curl", weight: "35", reps: "10")], date: Date(), index: currentWorkoutIndex)
         workouts.insert(workout5, at: 0)
         currentWorkoutIndex += 1
         let workout6 = Workout.init(workoutName: "Curl", set: [WorkoutSet.init(workoutName: "Curl", weight: "35", reps: "10")], date: Date(), index: currentWorkoutIndex)
         workouts.insert(workout6, at: 0)
         currentWorkoutIndex += 1
         let workout7 = Workout.init(workoutName: "Curl", set: [WorkoutSet.init(workoutName: "Curl", weight: "35", reps: "10")], date: Date(), index: currentWorkoutIndex)
         workouts.insert(workout7, at: 0)

         self.oldWorkoutsDictionary.updateValue(workouts, forKey: workout4.workoutName)
    }
}

