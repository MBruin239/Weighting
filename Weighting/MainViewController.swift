//
//  MainViewController.swift
//  Weighting
//
//  Created by Michael  Bruin on 9/17/21.
//

import UIKit

class MainViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?

    let cellReuseIdentifier = "cell"
    
    @IBOutlet weak var workoutTextField: UITextField! { didSet { workoutTextField.delegate = self } }
    @IBOutlet weak var repsTextField: UITextField! { didSet { repsTextField.delegate = self } }
    @IBOutlet weak var weightTextField: UITextField! { didSet { weightTextField.delegate = self } }
    @IBOutlet var workoutTableView: UITableView! { didSet { workoutTableView.delegate = self; workoutTableView.dataSource = self} }
    @IBOutlet var workoutPickerView: UIPickerView! { didSet { workoutPickerView.delegate = self; workoutPickerView.dataSource = self} }
    
    @IBOutlet weak var currentWorkoutView: CurrentWorkoutView! { didSet { currentWorkoutView.delegate = self } }

    @IBOutlet var addSetBtn: UIButton!
    @IBOutlet var finishWorkoutBtn: UIButton!
    
    weak var workoutsManager: WorkoutsManager?

    var workoutNames: [String]? {
        get{workoutsManager?.getWorkoutNames()}
    }
    var currentWorkoutName: String?

    // MARK: View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.moveTheViewWithKeyboard()
        self.hideKeyboardWhenTappedAround()

        self.registerTableViewCells()
        
        guard workoutNames!.count >= 1 else { return }
        
        let workoutName = workoutNames?[0]
        currentWorkoutName = workoutName
        workoutsManager?.setWorkoutName(name: workoutName!)

    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "WorkoutTableViewCell",
                                  bundle: nil)
        self.workoutTableView.register(textFieldCell,
                                forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    @IBAction func addSetAction(sender: UIButton!) {
        print("Add set Button Clicked")
        
        let workoutName = workoutTextField.text!
        let workoutWeight = weightTextField.text!
        let workoutReps = repsTextField.text!
        
        workoutsManager?.addWorkoutSet(workoutName: workoutName, weight: workoutWeight, reps: workoutReps)
    }
    
    func movePickerViewToRow(row: Int) {
        workoutPickerView.reloadAllComponents()
        self.workoutPickerView.selectRow(row, inComponent: 0, animated: false)
        self.pickerView(self.workoutPickerView, didSelectRow: row, inComponent: 0)
    }
    
    @IBAction func finishWorkoutAction(sender: UIButton!) {
        print("Finish workout Button Clicked")
        let workoutName = workoutTextField.text!
        
        workoutsManager?.finishCurrentWorkout()
        
        workoutsManager?.setWorkoutName(name: workoutName)
        
    }
    
    private func handleRemoveWorkout(index: Int) {
        workoutsManager?.removeWorkout(index: index)
        workoutsManager?.setWorkoutName(name: currentWorkoutName!)
    }

    private func handleEditWorkout(index: Int) {
        print("Edit workout: \(index)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
    
// MARK: Picker View Delegate functions
extension MainViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let workoutNames = workoutNames {
            return workoutNames.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("pickerView titleForRow", row)
        guard let workoutNames = workoutNames else {
            return nil
        }
        
        let title = workoutNames[row]
        workoutTextField.text = title

        return title
    }
}

extension MainViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("pickerView didSelectRow", row)
        guard let workoutNames = workoutNames else { return }

        let workoutName = workoutNames[row]
                
        workoutsManager?.setWorkoutName(name: workoutName)
    }
}

// MARK: Table Delegate functions
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentWorkoutName = currentWorkoutName else { return 0 }
        
        let oldWorkoutArray = workoutsManager?.getOldWorkoutsArray(workoutName: currentWorkoutName)
        
        return oldWorkoutArray!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let currentWorkoutName = currentWorkoutName else { return 0.0 }
        guard let oldWorkoutArray = workoutsManager?.getOldWorkoutsArray(workoutName: currentWorkoutName) else { return 0.0 }
        
        let workout = oldWorkoutArray[indexPath.row]
        
        let height = workout.set.count == 1 ? CGFloat(70 + ((workout.set.count-1) * 21)) : CGFloat(70 + ((workout.set.count-2) * 21))
        
        return height
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        var cell : WorkoutTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? WorkoutTableViewCell
        if cell == nil {
            cell = WorkoutTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }

        if let oldWorkoutArray = workoutsManager?.getOldWorkoutsArray(workoutName: currentWorkoutName!) {
            let workout = oldWorkoutArray[indexPath.row]
            cell!.setWorkout(workout: workout)
        }
        cell?.textLabel?.numberOfLines = 0

        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Remove action
        let remove = UIContextualAction(style: .destructive,
                                       title: "Remove") { [weak self] (action, view, completionHandler) in
                                        self?.handleRemoveWorkout(index: indexPath.row)
                                        completionHandler(true)
        }
        remove.backgroundColor = .systemRed

        // edit action
        let edit = UIContextualAction(style: .normal,
                                       title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.handleEditWorkout(index: indexPath.row)
                                        completionHandler(true)
        }
        edit.backgroundColor = .systemGreen

        let configuration = UISwipeActionsConfiguration(actions: [remove, edit])

        return configuration
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        guard let currentWorkoutName = currentWorkoutName else { return }
        guard let workout = workoutsManager?.getOldWorkoutsArray(workoutName: currentWorkoutName)[indexPath.row] else { return }

        coordinator?.displayInfo(of: workout, action: { text in
            print("text = \(text)")
            return text.count
        })

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Text Feild Delegate functions
extension MainViewController: UITextFieldDelegate {
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

        if textField == self.workoutTextField {
            workoutsManager?.setWorkoutName(name: textField.text!)
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
}

extension MainViewController: WorkoutsManagerDelegate {
    func onWorkoutEdited(workout: Workout) {
        print(workout)
    }
    
    func refreshViews() {
        workoutTableView.reloadData()
        workoutPickerView.reloadAllComponents()
    }
    
    func updateCurrentWorkout(workout: Workout){
        currentWorkoutView.setWorkout(workout: workout)
        currentWorkoutName = workout.workoutName
    }
    
    func workoutNamesDidUpdate(workoutNames: [String]){
        //self.workoutNames = workoutNames
    }
    
    func movePickerViewToRow(index: Int){
        movePickerViewToRow(row: index)
    }
}

extension MainViewController: CurrentWorkoutViewDelegate {
    func removeSetAtIndex(index: Int) {
        workoutsManager?.removeSet(index: index)
    }
}
