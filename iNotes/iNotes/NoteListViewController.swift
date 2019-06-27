//
//  ViewController.swift
//  iNotes
//
//  Created by alexey on 16/06/2019.
//  Copyright © 2019 alexey. All rights reserved.
//

import UIKit
import CoreData

class NoteListViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredNotes = [Note]()
    var noteArray = [Note]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let currentDate = Date()
    
    @IBAction func addNoteButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let newNote = Note(context: self.context)
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Note", style: .default) { (action) in
                newNote.title = textField.text!
                newNote.date = Date()
            newNote.user = actualUser
                self.noteArray.append(newNote)
                self.filteredNotes.append(newNote)
                self.tableView.reloadData()
                self.saveNotes()
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
            self.dismiss(animated: true, completion: nil)
            self.context.delete(newNote)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Note"
            textField = alertTextField
            action.isEnabled = false
            
            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: textField, queue: OperationQueue.main, using:
                {_ in
                    let txt = textField.text
                    if txt?.count != nil{
                        action.isEnabled = true
                    }
            })
        }
        
        alert.addAction(action)
        alert.addAction(actionCancel)
        setBadge()
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let alert = UIAlertController(title: "Are you sure?", message: "", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default) { (actionYes) in
                self.context.delete(self.noteArray[indexPath.row])
                self.noteArray.remove(at: indexPath.row)
                self.filteredNotes.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                self.saveNotes()
                setBadge()
            }
            
            let actionNo = UIAlertAction(title: "No", style: .default) { (actionNo) in
                self.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
            }
            
            alert.addAction(actionYes)
            alert.addAction(actionNo)
            setBadge()
            present(alert, animated: true, completion:nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0)]
        
        //loadNotes()
        let predicate = NSPredicate(format: "user = %@", actualUser)
        fetchMod(with: predicate)
        filteredNotes = noteArray
        print(noteArray)
        print(filteredNotes)
        print(context)
        let color = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0)
        tableView.separatorColor = color
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        setBadge()
    }
    
    
    //MARK - Table View data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! TableViewCell
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        let now = dateformatter.string(from: filteredNotes[indexPath.row].date!)
       
        cell.cellTitle?.text = filteredNotes[indexPath.row].title
        cell.cellDate?.text = now
        
        return cell
    }

    
    //MARK - Table View delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNote", sender: self)
    }

    

    //MARK: Data Manipulation
    
    func saveNotes (){
        
        do {
            try context.save()
        }
        catch {
            print("Error saving, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func fetchMod(with predicate: NSPredicate) {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = predicate
        
        noteArray = try! context.fetch(request)
        filteredNotes = try! context.fetch(request)
    }
    
    func loadNotes(with request: NSFetchRequest<Note> = Note.fetchRequest()){
        
        filteredNotes = noteArray
        do {
            noteArray = try context.fetch(request)
            print("Notes Loaded")
        }
        catch{
            print("Error fetching, \(error)")
        }
        setBadge()
        tableView.reloadData()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        tableView.tableFooterView = customView
        return customView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NoteViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedNote = noteArray[indexPath.row]
            print(noteArray[indexPath.row].title!)
            print(noteArray[indexPath.row].date!)
            destinationVC.titleText = noteArray[indexPath.row].title!
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredNotes = noteArray
        self.tableView.reloadData()
        if searchController.searchBar.text! != "" {
            filteredNotes = noteArray.filter { ($0.title?.lowercased().contains(searchController.searchBar.text!.lowercased()))! }
        }
        
        self.tableView.reloadData()
    }
    
    
}




