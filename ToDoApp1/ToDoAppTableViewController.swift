//
//  ToDoAppTableViewController.swift
//  ToDoApp1
//
//  Created by Tatsuya Moriguchi on 7/5/18.
//  Copyright © 2018 Becko's Inc. All rights reserved.
//

import UIKit
import CoreData

class ToDoAppTableViewController: UITableViewController {

    var tasks = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()

        self.tableView.reloadData()
 
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func fetchData() {
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        let sort = NSSortDescriptor(key: #keyPath(Task.dateCreated), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            tasks = try context.fetch(fetchRequest)
        } catch {
            print("Cannot fetch Expenses")
        }
    }
    
    
    fileprivate func saveTask() {
        //Pop=up an alert window to add a task
        let alert = UIAlertController(title: "Add Task", message: "Add an undevidable task to do.", preferredStyle: .alert)
        let task = Task(context: context)


        let save = UIAlertAction(title: "Save", style: .default) { (alertAction: UIAlertAction) in
                task.toDo = alert.textFields![0].text
                task.dateCreated = Date()

            do {
                try self.context.save()
                self.fetchData()
                self.tableView.reloadData()
                
            } catch {
                print("\nTask Add Failed. \(error)\n")
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(save)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addTaskPressed(_ sender: UIBarButtonItem) {
        saveTask()
    }
    
    func noTextAlert() {
        let alert2 = UIAlertController(title: "No Text Entered!", message: "Add text for a goal.", preferredStyle: .alert)
        self.present(alert2, animated: true, completion: nil)
        alert2.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].toDo
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let task = self.tasks[indexPath.row]
        
        if editingStyle == .delete {
            // Delete the row from the data source
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.context.delete(task)
            do {
                try self.context.save()
            } catch {
                print("\nDelete Save Error: \(error)\n")
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            //tableView.insertRows(at: [indexPath], with: .fade)
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //performSegue(withIdentifier: "ShowAddTodo", sender: tableView.cellForRow(at: indexPath))
        
       //Pop=up an alert window to update a task
        let alert2 = UIAlertController(title: "Add Task", message: "Add an undevidable task to do.", preferredStyle: .alert)

        let save = UIAlertAction(title: "Save", style: .default) { (alertAction: UIAlertAction) in

            let task = self.tasks[indexPath.row]
            task.toDo = alert2.textFields![0].text
            //task.dateCreated = Date()
            
            do {
                try self.context.save()
                self.fetchData()
                self.tableView.reloadData()
                
            } catch {
                print("\nTask Add Failed. \(error)\n")
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        //alert2.addTextField(configurationHandler: nil)
        // Show the selected goal in alert popup.
        alert2.addTextField(configurationHandler: { (textField) in
            textField.text = self.tasks[indexPath.row].toDo
        })
        alert2.addAction(save)
        alert2.addAction(cancel)
        self.present(alert2, animated: true, completion: nil)
  
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
        if segue.identifier == "segueToNewVC" {
            let newVC = segue.destination as! NewViewController
            newVC.toDo = "Hello"
        }
    }
    

}
