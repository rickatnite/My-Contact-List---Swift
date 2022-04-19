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
        loadDataFromDatabase() //When the view controller is first loaded into memory, the contacts array is populated with data

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
