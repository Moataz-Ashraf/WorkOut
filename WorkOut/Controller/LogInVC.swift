//
//  LogInVC.swift
//  WorkOut
//
//  Created by Moataz on 11/27/19.
//  Copyright © 2019 Moataz. All rights reserved.
//

import UIKit
import CoreData

class LogInVC: UIViewController {
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
var Myresult = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var UserNameTxt: UITextField!
    
     @IBOutlet weak var passwordTxt: UITextField!
    
    @IBAction func buLogin(_ sender: AnyObject) {
        let request = NSFetchRequest<Users>(entityName: "Users")
        let predicate = NSPredicate(format: "userName = %@", UserNameTxt.text!)
        request.predicate = predicate
        do{
        Myresult = try context.fetch(request)
            if Myresult.count>0
            {
                var objectEntity : Users = Myresult.first as! Users
                if (objectEntity.userName == UserNameTxt.text! && objectEntity.userName != "") && (objectEntity.password == passwordTxt.text! && objectEntity.password != "")
                {
                    print("LogIN SUCC")
                    
            performSegue(withIdentifier: "GoToNote", sender: self)
                    // Entered Username & password matched
                }
                else
                {
                    print("LogIN Failed")
                }
            }else{
                print("UserName NotFound!")
            }
            
        }catch{
            print(error)
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! NoteTVC
        dest.title = UserNameTxt.text!
        dest.UserName = (self.Myresult.first as! Users)
        
    }
    
    
}
