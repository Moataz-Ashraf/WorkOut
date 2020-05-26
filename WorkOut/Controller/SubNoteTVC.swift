//
//  SubNoteTVC.swift
//  WorkOut
//
//  Created by Moataz on 11/27/19.
//  Copyright © 2019 Moataz. All rights reserved.
//

import UIKit
import ChameleonFramework
import CoreData
import SwipeCellKit

class SubNoteTVC: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var SubNotes = [SubNote]()
    var Selected : Notes? {
        didSet{
            loadData()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let navColor = Selected?.color {
            title = Selected?.name
            guard let navBar = navigationController?.navigationBar else{fatalError("Navigation Bar Not Found")}
            
            if  let color = HexColor(navColor){
                navBar.barTintColor = color
                navBar.tintColor = ContrastColorOf(color, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(color, returnFlat: true)]
        }
        }
        
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SubNotes.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdSubNote", for: indexPath)as! SwipeTableViewCell
cell.delegate = self
        let color = (HexColor(Selected?.color ?? "#1ABC9C"))!.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(SubNotes.count))
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        cell.textLabel?.text = SubNotes[indexPath.row].title
        cell.accessoryType = SubNotes[indexPath.row].done ?.checkmark : .none
       

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SubNotes[indexPath.row].done = !SubNotes[indexPath.row].done
        self.SaveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
 
    @IBAction func AddSubNote(_ sender: Any) {
        var txtfield = UITextField()
        let alert = UIAlertController(title: "Add Your Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Notes ", style: .default) { (action) in
            let newSubNote = SubNote(context: self.context)
            newSubNote.title = txtfield.text!
            newSubNote.done = false
            newSubNote.subNoteR = self.Selected
            self.SubNotes.append(newSubNote)
            self.SaveData()
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (textField) in
            textField.placeholder = "Add Your Notes"
            txtfield = textField
        }
        present(alert, animated: true, completion: nil)
    }
    func SaveData (){
        do{
            try context.save()
            
        }
            catch {
                print(error)
            
            }
        tableView.reloadData()
    }

func loadData(){
    let MyPredicate = NSPredicate(format: "subNoteR.name MATCHES %@", Selected!.name!)
    let request : NSFetchRequest<SubNote> = SubNote.fetchRequest()
    request.predicate = MyPredicate
    do{
        SubNotes = try context.fetch(request)
    }catch{
        print(error)
    }
    tableView.reloadData()
    }
}
extension SubNoteTVC : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            
            do{
                try self.context.delete(self.SubNotes[indexPath.row])
                self.SubNotes.remove(at:indexPath.row)
                try self.context.save()
            }
            catch{
                print(error)
            }
            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "Trash")
        
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        // options.transitionStyle = .border
        return options
    }
}
