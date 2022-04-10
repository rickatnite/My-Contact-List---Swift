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
    let sortOrderItems: Array<String> = ["ContactName", "City", "Birthday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SettingsViewController is the data source for the Picker View
        //the View Controller conforms to UIPickerViewDataSource.
        pckSortField.dataSource = self;
        //View Controller is the delegate for the Picker View, so whenever actions are taken on the Picker View, specific methods are called in the View Controller.
        //This works because the View Controller conforms to UIPickerViewDelegate.
        pckSortField.delegate = self;
    }
    
    @IBAction func sortDirectionChanged(_ sender: Any) {
    }
    
    // MARK: UIPickerViewDelegate Methods
    
    //Returns the number of columns to display
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //returns the number of row in the picker
    func pickerView(_ _pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }
    
    //sets the value that is shown for each row in the picker
    //When the Picker is displayed, the system will make repeated calls to this method
    //passing in the row number and getting the corresponding text for the row back.
    //In this case, the method uses the row number to return the corresponding item from the array.
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }
    
    //if user chooses from the pickerview it calls this function
    func pickerView(_pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
