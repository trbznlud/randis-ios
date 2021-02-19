//
//  ViewController.swift
//  Randis1
//
//  Created by Davut Peker on 13.06.2019.
//  Copyright © 2019 Davut Peker. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sifre.isSecureTextEntry = true    
    }
    @IBOutlet weak var kullaniciAdi: UITextField!
    @IBOutlet weak var sifre: UITextField!
    
    @IBAction func kayitOl(_ sender: UIButton) {
        if kullaniciAdi.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: kullaniciAdi.text!, password: sifre.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")

                    self.performSegue(withIdentifier: "Ev", sender: nil)
                    
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
