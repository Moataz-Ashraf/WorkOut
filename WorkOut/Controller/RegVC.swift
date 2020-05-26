//
//  RegVC.swift
//  WorkOut
//
//  Created by Moataz on 11/27/19.
//  Copyright © 2019 Moataz. All rights reserved.
//

import UIKit
import CoreData

class RegVC: UIViewController {
    // Variable
    let context:NSManagedObjectContext = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
  var result = [Users]()

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var UserNameTXT: UITextField!
    @IBOutlet weak var PasswordTXT: UITextField!
    @IBAction func buReg(_ sender: Any) {
        
        
//        let NewUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
//        NewUser.setValue(UserNameTXT.text!, forKey: "userName")
//        NewUser.setValue(PasswordTXT.text!, forKey: "password")
//        NewUser.setValue(Email.text!, forKey: "eMail")
        
        let new = Users(context: context)
            
            
        new.userName = UserNameTXT.text!
        new.password = PasswordTXT.text!
        new.eMail = Email.text!
        result.append(new)
        
       if UserNameTXT.text != "" && PasswordTXT.text != "" && Email.text != ""{
            do{
                try context.save()
                performSegue(withIdentifier: "GoToNote", sender: self)

                
            }catch{
                context.deletedObjects
                let alert = UIAlertController(title: "Error" , message: "userName is exist", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                print(error)
            }
        
       }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! NoteTVC
        dest.title = (UserNameTXT.text!+"'s Note")
       dest.UserName = result.last
        
    }
}
