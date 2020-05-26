//
//  NoteTVC.swift
//  WorkOut
//
//  Created by Moataz on 11/27/19.
//  Copyright © 2019 Moataz. All rights reserved.
//

import UIKit
import CoreData
import SwipeCellKit
import ChameleonFramework

class NoteTVC: UITableViewController{
    
    //     Variable
    var NoteCategs = [Notes]()
    var UserName : Users? {
        didSet{
            LoadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
// print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       LoadData()
       // print(UserName!.userName!)
    }


    // MARK: - Table view data source

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return NoteCategs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "IdNote", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        let color = HexColor(NoteCategs[indexPath.row].color!)
       cell.textLabel?.text = NoteCategs[indexPath.row].name
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)

        return cell
    }
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToSubNote", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! SubNoteTVC
        if let indexpath = tableView.indexPathForSelectedRow {
            dest.Selected = NoteCategs[indexpath.row]

        }
    }

    @IBAction func AddNote(_ sender: Any) {
        var txt = UITextField()
        let alert = UIAlertController(title: "Notes", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Note", style: .default) { (action) in
            let NewNotes = Notes(context: self.context)
            NewNotes.name = txt.text!
            NewNotes.color = UIColor.hexValue(UIColor.randomFlat)()
            NewNotes.noteR = self.UserName
           self.NoteCategs.append(NewNotes)
            self.SaveData()
        }
        alert.addAction(action)
        alert.addTextField { (txtField) in
            txt = txtField
            txt.placeholder = "Add New Note"
        }
       present(alert, animated: true, completion: nil)


    }
    
    func SaveData(){
        do{
        try context.save()
        }
        catch {
            print(error)
        }
        tableView.reloadData()
        
    }
    
    func LoadData(){
        let request : NSFetchRequest<Notes> = Notes.fetchRequest()
        let predicate = NSPredicate(format: "noteR.userName MATCHES %@",UserName!.userName! )
        request.predicate = predicate
        do{
           NoteCategs = try context.fetch(request)
        }catch {
            print(error)
        }
        tableView.reloadData()
        
    }
}
//bde ashkelk mn nar hobe
extension NoteTVC: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else{ return nil }
        let deleteAction = SwipeAction(style:.destructive, title: "Delete") { action, indexPath in
            do{
                try self.context.delete(self.NoteCategs[indexPath.row])
                self.NoteCategs.remove(at: indexPath.row)
                try self.context.save()
            }catch{
                print(error)
            }
        }
       deleteAction.image = UIImage(named: "Trash")
        return [deleteAction]
        
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

