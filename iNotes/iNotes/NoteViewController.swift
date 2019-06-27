//
//  NoteViewController.swift
//  iNotes
//
//  Created by alexey on 16/06/2019.
//  Copyright © 2019 alexey. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteTextTop: NSLayoutConstraint!
    @IBOutlet weak var noteTextTopEdit: NSLayoutConstraint!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var titleText: String?
    var selectedNote: Note?
    let screenSize = UIScreen.main.bounds
    var cancelButtonWidth : CGFloat = 0
    
    
    @IBAction func editTitle(_ sender: UIButton) {
        
        
        
        var textField = UITextField()
        let alert = UIAlertController(title: "New Title", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Change Title", style: .default) { (action) in
            
            self.selectedNote?.setValue(textField.text!, forKey: "title")
            print("Title changed")
            self.noteTitle.text = textField.text!
            
            do {
                try self.context.save()
                print("Title Saved")
            }
            catch {
                print("Error saving, \(error)")
            }
        }
        
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { (actionCancel) in
            self.dismiss(animated: true, completion: nil)
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Insert New Title"
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
    
    
    
    @IBAction func saveContent(_ sender: UIButton) {
        
        
        if selectedNote?.contentText == nil {
            selectedNote?.contentText = ""
        }
        
            selectedNote?.contentText = (selectedNote?.contentText)! + noteText.text!
        
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            noteText.resignFirstResponder()
        setBadge()
    }

    
    @IBAction func cancelContent(_ sender: UIButton) {
        if selectedNote?.contentText != nil{
            noteText?.text! = (selectedNote?.contentText)!
        }
        else {
            noteText?.text! = ""
        }
        noteText.resignFirstResponder()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButtonWidth = cancelButton.frame.size.width
        saveButtonConstraint.constant = screenSize.width
//        saveButton.isHidden = true
        
        noteTitle.text = titleText
        noteText?.delegate = self
        noteText.text = selectedNote?.contentText
        
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NoteViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        setBadge()
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - keyboardSize.height)
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + keyboardSize.height)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    
    
    //MARK: Data Manipulation
    
    func saveContentText (){
        
        if selectedNote?.contentText == nil {
            selectedNote?.contentText = ""
        }
        
        selectedNote?.contentText = noteText.text!
        setBadge()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
//        saveButton.isHidden = false
        textView.text = selectedNote?.contentText
        textView.textColor = UIColor.black
        saveButtonConstraint.constant = screenSize.width - cancelButtonWidth
        cancelButton.frame.size.width = cancelButtonWidth
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == noteText.text
        {
            if (text == "\n")
            {
                textView.text = textView.text + "\n"
            }
        }
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        saveContentText()
        textView.text = selectedNote?.contentText
        saveButtonConstraint.constant = screenSize.width
//        saveButton.isHidden = true
        setBadge()
    }

}

