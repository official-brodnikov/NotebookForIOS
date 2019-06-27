//
//  LogInViewController.swift
//  iNotes
//
//  Created by alexey on 16/06/2019.
//  Copyright © 2019 alexey. All rights reserved.
//

import UIKit
import CoreData

class LogInViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    var listUsers: [Users] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext!
    public var User: String = ""
    
    @IBAction func logInTouch(_ sender: UIButton) {
        fetchModels()
        var checkLogin: Bool = false
        for user in listUsers {
            print("name = \(user.name!), password = \(user.password!)")
            if (nameTextField.text == user.name && passwordTextField.text == user.password) {
                actualUser = nameTextField.text!
                checkLogin = true
            }
        }
        if checkLogin {
            performSegue(withIdentifier: "mySegueID", sender: nil)
        } else {
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
            } else {
            let alert = UIAlertController(title: "Error", message: "Name or password not true", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            
            alert.addAction(OKAction)
            
            present(alert, animated: true, completion: nil)
                passwordTextField.text = ""
                
            }
        }
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
    

    @IBAction func registrateTouch(_ sender: UIButton) {
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
