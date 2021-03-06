//
//  ContactsViewController.swift
//  My Contact List
//
//  Created by E Roche on 4/3/22.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentContact: Contact? //to hold information about the Contact entity being edited
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //a reference to the App Delegate that will be used to access the Core Data functionality
    
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
    @IBOutlet weak var imgContactPicture: UIImageView!
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBAction func changePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) { //check that camera exists
            
            //creates camera controller and sets properties
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
            cameraController.cameraCaptureMode = .photo
            cameraController.delegate = self
            cameraController.allowsEditing = true //user allowed to edit image taken
            self.present(cameraController, animated: true, completion: nil) //present camera controller to user
        }
    }
    
    //handles image picker returned - UIImagePickerController returns data in a String array called info
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage { //conditionally assigns the returned image to an image constant
            imgContactPicture.contentMode = .scaleAspectFit //keeps the proper aspect ratio
            imgContactPicture.image = image //image assigned to the imgContactPicture control
            
            //save image - creates a Contact object if currentContact hasn???t been set and converts image to JPEG with no compression
            if currentContact == nil {
                let context = appDelegate.persistentContainer.viewContext
                currentContact = Contact(context: context)
            }
            currentContact?.image = image.jpegData(compressionQuality: 1.0) //lower number to compress image
        }
        dismiss(animated: true, completion: nil) //dismisses the camera control so app becomes visible again
    }
    
    
    //functions to detect if the keyboard has been displayed and
    //then move the scroll view and its contents enough
    //so that the selected control is not covered.
    //When the keyboard is dismissed, it then moves the content back to its original position.
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentContact != nil { //make sure the currentContact object is instantiated
            //populate all the textfields
            txtName.text = currentContact!.contactName
            txtAddress.text = currentContact!.streetAddress
            txtCity.text = currentContact!.city
            txtState.text = currentContact!.state
            txtZip.text = currentContact!.zipCode
            txtPhone.text = currentContact!.phoneNumber
            txtCell.text = currentContact!.cellNumber
            txtEmail.text = currentContact!.email
            //exclamation marks are needed because currentContact is optional
            //since currentContact does contain an object, the exclamation mark implicitly unwraps the value
            
            //retrieve the image from the database - takes image stored as Data and turns it into UIImage for display, and assigns to the image property of the ImageView control
            if let imageData = currentContact?.image as? Data {
            imgContactPicture.image = UIImage(data: imageData)
            }
            
            //set up a DateFormatter to format the date to short format
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            
            if currentContact!.birthday != nil { //checks that the birthday property is set to a value
                lblBirthdate.text = formatter.string(from: currentContact!.birthday as! Date) //formats and assigns to the label
            }
            
            let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(callPhone(gesture:)))
            lblPhone.addGestureRecognizer(longPress)

        }
        
        changeEditMode(self) //Calls the changeEditMode method to ensure that the controls are set properly when the view loads.
        
        //text fields to array
        let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip, txtPhone, txtCell, txtEmail]
        
        //loop to go over all textfields in array
        for textfield in textFields {
            //each time this is executed, it adds a listener (target) to the text field.
            //self specifies the object that contains the method that is called when the event occurs that the listener is listening for.
            //the method will be in the current class, so we use self.
            //action specifies the name of the method to call when the event occurs.
            //the method is a standard method from the UITextFieldDelegate interface and is called just as the TextField is done editing and can be used for text validation
            //for is the actual event to listen for, editingDidEnd, which occurs after the user leaves the TextField.
            textfield.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
        }
    }
    
    @objc func callPhone(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began { //check gesture state - began is called once for the long press
            let number = txtPhone.text
            if number!.count > 0 { //checks that number isn't blank
                let url = NSURL(string: "telprompt://\(number!)") //NSURL object holds the number to call
                UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil) //calls phone number
                print("Calling Phone Number: \(url!)")
            }
        }
    }
    
    //updates the currentContact object with the values in all the TextFields
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //if no currentContact object, the code first uses the appDelegate variable to get a reference to the Managed Object Context
        //(which is essentially the file that stores the data)
        //This is used in the next line, which instantiates the currentContact variable by inserting it as a new object into the context.
            if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        currentContact?.contactName = txtName.text
        currentContact?.streetAddress = txtAddress.text
        currentContact?.city = txtCity.text
        currentContact?.state = txtState.text
        currentContact?.zipCode = txtZip.text
        currentContact?.cellNumber = txtCell.text
        currentContact?.phoneNumber = txtPhone.text
        currentContact?.email = txtEmail.text
        return true
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
        //Content Insets are the distance of the Scroll View???s content from the Scroll View???s edges. The insets collection is retrieved, and the bottom inset is set to the height of the keyboard so that the content will be above the keyboard.
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height
        
        //The Scroll View is then set to use the new content insert values.
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    
    //When the keyboard disappears, the Scroll View???s content insert values are set back to the original values.
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
            btnChange.isHidden = true //The Change button should not be shown in view mode.
            navigationItem.rightBarButtonItem = nil //ensures there is no button in View mode
        }
        
        //When switching to edit mode, the code is similar but the values are opposite. The TextFields are enabled, and the border is set to the Rounded Rect mode (the default). The button is hidden.
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            btnChange.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.save, target: self, action: #selector(self.saveContact))
        } //creates a UIBarButtonItem in the left spot of the navigation bar with the text Save and associates it with the saveContact method
    }
    
    /*check the database:
    1. In Xcode, select Window > Devices and Simulators and then locate the simulator on which you ran the app. Copy the Identifier for this Simulator by triple-clicking it.
    2. Open a Finder window and select Go > Go To Folder.
    3. Enter ~/Library/Developer/CoreSimulator/Devices/{DEVICE IDENTIFIER}/data/Containers/Data/Application, but replace {DEVICE IDENTIFIER} with the Identifier you copied in Step 1.
     */
    
    
    @objc func saveContact() {
        appDelegate.saveContext() //saves the object to the database
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self) //change the scene from editing to viewing mode
    }
    
    
    
    func dateChanged(date: Date) {
        if currentContact == nil { //checks if the currentContact variable is populated, since currentContact is optional
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        currentContact?.birthday = date //sets the date that was passed in from the calling controller to the birthday property in currentContact
        let formatter = DateFormatter() //set up a date formatter
        formatter.dateStyle = .short //format the date using the short style
        lblBirthdate.text = formatter.string(from: date) //the formatted date is set on the label on the Contacts screen
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueContactDate") { //checks to see which segue initiated the call to the method - "segueContactDate" is a unique identifier of the segue
            let dateController = segue.destination as! DateViewController //reference to the destination View Controller
            dateController.delegate = self //sets the delegate for the Date Controller to be the Contacts Controller (self).
            //This allows the Date Controller to call the dateChanged method in the Contacts Controller.
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
