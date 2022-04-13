//
//  DateViewController.swift
//  My Contact List
//
//  Created by E Roche on 4/13/22.
//

import UIKit

//sets up the delegate protocol and specifies that any class adopting this protocol must also implement the dateChanged method
protocol DateControllerDelegate: AnyObject {
    func dateChanged(date: Date) //the Date Controller calls this method on its delegate anytime the date changes
}

class DateViewController: UIViewController {
    //main controller may not set itself as a delegate of the Date Controller, so it is weak and optional type
    //optional is nil by default so no init method needed
    weak var delegate: DateControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveDate))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick Birthdate"
    }
    
    
    @objc func saveDate() {
        self.delegate?.dateChanged(date: dtpDate.date)
        self.navigationController?.popViewController(animated: true)
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
