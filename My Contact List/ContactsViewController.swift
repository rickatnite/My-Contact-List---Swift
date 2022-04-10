//
//  ContactsViewController.swift
//  My Contact List
//
//  Created by E Roche on 4/3/22.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtCell: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    
    
    //functions to detect if the keyboard has been displayed and
    //then move the scroll view and its contents enough
    //so that the selected control is not covered.
    //When the keyboard is dismissed, it then moves the content back to its original position.
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeEditMode(self)
        //Calls the changeEditMode method to ensure that the controls are set properly when the view loads.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //dispose of any resources that can be recreated
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
        //When the scene is about to be displayed, a method is called to register the code to listen for notifications that the keyboard has been displayed.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotifications()
        //when the view disappears, a method is called to stop the keyboard from listening for notifications.
    }
    
    //registers the code for notifications and tells the system to execute the appropriate method when the event occurs.
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsViewController.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //removes the listener
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Information is collected from the notification to get the size of the keyboard displayed.
    //This is needed to move the content the appropriate amount.
    @objc func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        //get the existing contentInset for the scrollView and set the bottom property to be the height of the keyboard
        //Content Insets are the distance of the Scroll View’s content from the Scroll View’s edges. The insets collection is retrieved, and the bottom inset is set to the height of the keyboard so that the content will be above the keyboard.
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        
        //The Scroll View is then set to use the new content insert values.
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    //When the keyboard disappears, the Scroll View’s content insert values are set back to the original values.
    @objc func keyboardWillHide(notification: NSNotification) {
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    //called whenever the Segmented Control changes state and will change the controls as needed to reflect the state of the control.
    @IBAction func changeEditMode(_ sender: Any) {
        //All the properties are changed in the same way for each of the TextFields, so set up an Array object containing all the TextFields
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip, txtCell, txtPhone, txtEmail]
        
        //Check the value of the Segmented Control. Viewing is 0, and Editing is 1.
        if sgmtEditMode.selectedSegmentIndex == 0 {
            //Use a fast enumeration loop to go through all the TextFields in the array.
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
                //In view mode, the TextFields are disabled and the border is set to not be there
            }
            btnChange.isHidden = true
            //The Change button should not be shown in view mode.
        }
        
        //When switching to edit mode, the code is similar but the values are opposite. The TextFields are enabled, and the border is set to the Rounded Rect mode (the default). The button is hidden.
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            btnChange.isHidden = false
        }
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
