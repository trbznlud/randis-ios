//
//  LoginPageController.swift
//  Randis1
//
//  Created by Davut Peker on 14.06.2019.
//  Copyright © 2019 Davut Peker. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase

class LoginPageController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    sifre.isSecureTextEntry = true	
}
    
    @IBOutlet weak var kullaniciAdi: UITextField!
    @IBOutlet weak var sifre: UITextField!
    
    @IBAction func kayitOl(_ sender: UIButton) {
        performSegue(withIdentifier: "Kayıt", sender: nil)
        
    }
    @IBAction func girisYap(_ sender: UIButton) {
        if self.kullaniciAdi.text == "" || self.sifre.text == "" {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else {
            
            Auth.auth().signIn(withEmail: self.kullaniciAdi.text!, password: self.sifre.text!) { (user, error) in
                
                if error == nil {
                    
                    self.performSegue(withIdentifier: "Home", sender: nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
