//
//  RegistrationViewController.swift
//  iNotes
//
//  Created by alexey on 16/06/2019.
//  Copyright © 2019 alexey. All rights reserved.
//

import UIKit
import CoreData

class RegistrationViewController: UIViewController {

    var listUsers: [Users] = []
    var newUser: Users!
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func registrateTouch(_ sender: UIButton) {
        if nameTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Enter Your Name", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            
            alert.addAction(OKAction)
            
            present(alert, animated: true, completion: nil)
            passwordTextField.text = ""
        } else if passwordTextField.text == "" {
            let alert = UIAlertController(title: "Error", message: "Enter Your Password", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            
            alert.addAction(OKAction)
            
            present(alert, animated: true, completion: nil)
            passwordTextField.text = ""
        } else if CheckUserName(userName: nameTextField.text!) {
            let alert = UIAlertController(title: "Error", message: "User With the Same Name Already Exists", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            
            alert.addAction(OKAction)
            
            present(alert, animated: true, completion: nil)
            nameTextField.text = ""
            passwordTextField.text = ""
        } else {
            saveUser(userName: nameTextField.text!, password: passwordTextField.text!)
            if let nvc = navigationController {
                nvc.popViewController(animated: true)
            }
        }
    }
    
    func saveUser(userName: String, password: String) {
        if let myContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            newUser = Users(context: myContext)
            
            newUser.password = passwordTextField.text
            newUser.name = nameTextField.text
            
            do {
                try myContext.save()
            } catch let error {
                print("Error when saving: \(error)")
            }
        }
    }
    
    func CheckUserName(userName: String) -> Bool {
        fetchModels()
        for user in listUsers {
            if (userName == user.name) {
                return true
            }
        }
        return false
    }
    
    func fetchModels() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            return
        }
        
        let request: NSFetchRequest<Users> = Users.fetchRequest()
        
        listUsers = try! context.fetch(request)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.text = ""
        passwordTextField.text = ""
        // Do any additional setup after loading the view.
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
