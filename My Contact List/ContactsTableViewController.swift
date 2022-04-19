//
//  ContactsTableViewController.swift
//  My Contact List
//
//  Created by E Roche on 4/19/22.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController {

    //let contacts = ["Jim", "John", "Dana", "Rosie", "Justin", "Jeremy", "Sarah", "Matt", "Joe", "Donald", "Jeff"]
    var contacts: [NSManagedObject] = [] //hold the Contact objects that will be retrieved from CoreData
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //sets up a class variable for referencing the app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadDataFromDatabase() //When the view controller is first loaded into memory, the contacts array is populated with data
        self.navigationItem.leftBarButtonItem = self.editButtonItem

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase() //ensures that the data is reloaded from the database
        tableView.reloadData() //reloads the data in the table itself
    }
    
    
    func loadDataFromDatabase() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Contact") //defines what data is to be pulled from CoreData by creating a NSFetchRequest object specifying that Contact entities will be retrieved
        do {
            contacts = try context.fetch(request) //executes the fetch and stores the results in the contacts array
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count //returns the number of elements in the contacts array
    }

    //generates the data for a particular cell, so it is passed to the section and row as the indexPath parameter - use to configure the actual cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath)
        // unique identifier for all cells in the table that are set up in the same way so the objects can be reused when the cell scrolls off the screen
        let contact = contacts[indexPath.row] as? Contact //retreives contact object with row number as the index
        cell.textLabel?.text = contact?.contactName //sets the textLabel property to the contactName
        cell.detailTextLabel?.text = contact?.city //sets the detailTextLabel to the city for contact - detail is subtitle text
        cell.accessoryType = UITableViewCell.AccessoryType .detailDisclosureButton //adds accessory button to cell
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row] as? Contact
        let name = selectedContact!.contactName!
        let actionHandler = { (action: UIAlertAction!) -> Void in //sets up an action handler that contains the code to execute when the user taps the Show Details button
            //self.performSegue(withIdentifier: "EditContact", sender: tableView.cellForRow(at: indexPath)) //execute a segue by using the storyboard identifier
            let storyboard = UIStoryboard(name: "Main", bundle: nil) //reference to the storyboard
            let controller = storyboard.instantiateViewController(withIdentifier: "ContactController") as? ContactsViewController //instance of the view controller using identifier
            controller?.currentContact = selectedContact //controller is previously cast as a ContactsViewcontroller in order to set the selected contact
            self.navigationController?.pushViewController(controller!, animated: true) //uses the navigation controller to push the view controller onto the navigation stack
        }
        
        let alertController = UIAlertController(title: "Contact selected", message: "Selected row: \(indexPath.row) (\(name))", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionDetails = UIAlertAction(title: "Show Details", style: .default, handler: actionHandler) //when user taps Show Details, the code in actionHandler is executed
        
        //adds the two buttons to the Alert Controller
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated: true, completion: nil) //displays the controller
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let contact = contacts[indexPath.row] as? Contact //retrieves the object for the selected row
            let context = appDelegate.persistentContainer.viewContext
            context.delete(contact!) //deletes the object from the context
            do {
                try context.save()
            } catch {
                fatalError("Error saving context: \(error)")
            }
            loadDataFromDatabase() //reloads the data from the database into the contacts array
            //could also redefine the contacts variable to be of type NSMutableArray to delete the individual object directly from the array
            tableView.deleteRows(at: [indexPath], with: .fade) //removes the row from the table
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditContact" { //checks to see if the segue matches the identifier in the storyboard
            let contactController = segue.destination as? ContactsViewController //gets a reference to the Contact editing screen view controller as the destination for the segue
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row //which row was selected in the table
            let selectedContact = contacts[selectedRow!] as? Contact //reference to the corresponding Contact object from the contacts array
            contactController?.currentContact = selectedContact! //assigns the selected contact to the currentContact property in ContactsViewController
            //allows that controller to populate the user interface with the selected Contact
        }
    }
    

}



// Uncomment the following line to preserve selection between presentations
// self.clearsSelectionOnViewWillAppear = false

