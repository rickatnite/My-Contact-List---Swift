//
//  SettingsViewController.swift
//  My Contact List
//
//  Created by E Roche on 4/3/22.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pckSortField: UIPickerView!
    @IBOutlet weak var swAscending: UISwitch!

    //array to store the items that will show up in the Picker View
    let sortOrderItems: Array<String> = ["contactName", "city", "birthday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SettingsViewController is the data source for the Picker View
        //the View Controller conforms to UIPickerViewDataSource
        pckSortField.dataSource = self;
        //View Controller is the delegate for the Picker View
        //whenever actions are taken on the Picker View, specific methods are called in the View Controller
        //the View Controller conforms to UIPickerViewDelegate
        pckSortField.delegate = self;
    }
    
    //executed just before the view is displayed
    override func viewWillAppear(_ animated: Bool) {
        //set the UI based on the values in userDefaults
        let settings = UserDefaults.standard
        //sets the value of the Switch based on the value in the sortDirectionAscending key by calling the setOn: method on the Switch
        swAscending.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)
        //read the sortField value into a constant
        let sortField = settings.string(forKey: Constants.kSortField)
        var i = 0
        //the Picker View is updated by telling it which number row to select, so the for loop goes through the sortOrderItems array
        for field in sortOrderItems {
            if field == sortField {
                //if a match is found, the Picker View is told to select that row
                //set to zero bc there is only one component.
                //animated to false bc the selection is already made before the user opens the Selection screen
                pckSortField.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        pckSortField.reloadComponent(0) //call to have the Picker View change
    }
    
    
    //store the value of the switch
    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }
    
    
    
    // MARK: UIPickerViewDelegate Methods
    
    //Returns the number of columns to display
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    //returns the number of row in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }
    
    
    
    //sets the value that is shown for each row in the picker
    //When the Picker is displayed, the system will make repeated calls to this method
    //passing in the row number and getting the corresponding text for the row back.
    //In this case, the method uses the row number to return the corresponding item from the array.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }
    
    
    
    //if user chooses from the pickerview it calls this function - saves userr settings
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: Constants.kSortField)
        settings.synchronize()
        print("Chosen item: \(sortOrderItems[row])")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
