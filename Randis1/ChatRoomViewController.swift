//
//  ChatRoomViewController.swift
//  Randis1
//
//  Created by Davut Peker on 16.06.2019.
//  Copyright © 2019 Davut Peker. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var chatMesaj = [Mesaj]()
    
    func observeMessage(){
        let databaseRef = Database.database().reference()
        databaseRef.child("ChatSubjects").child(roomName).child("mesaj").observe(.childAdded){(snapshot) in
            if let dataArray = snapshot.value as? [String: Any]{
                guard let gönderici = dataArray["gönderici"] as? String, let mesajText = dataArray["mesajText"] as? String, let userId = dataArray["kullaniciId"] as? String else {
                    return
                }
                let mesaj = Mesaj.init(mesajKey: snapshot.key, gönderici: gönderici, mesajText: mesajText, kullaniciId: userId)
                self.chatMesaj.append(mesaj)
                self.chatTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMesaj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mesaj = self.chatMesaj[indexPath.row]
        
        let chatCell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as! ChatCell
        chatCell.setMesajData(mesaj:mesaj)
        
        if(mesaj.kullaniciId==Auth.auth().currentUser!.uid){
            chatCell.setBubbleType(type: .outgoing)
        }else{
            chatCell.setBubbleType(type: .incoming)
        }
        return chatCell
    }
    
 
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    var room:Room?
    var roomName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false
        observeMessage()
    }
    
    func mesajGönderme(text:String, completion: @escaping (_ isSuccess: Bool)-> ()){
       
        let databaseRef = Database.database().reference()
        let user = Auth.auth().currentUser
        
        if let userName = user?.email, let userId = Auth.auth().currentUser?.uid {
            let dataArray: [String: Any] = ["gönderici":userName, "mesajText":text, "kullaniciId":userId]
            
            let room = databaseRef.child("ChatSubjects").child(roomName)
            room.child("mesaj").childByAutoId().setValue(dataArray,withCompletionBlock: {(error,ref) in
                if(error == nil){
                    completion(true)
                    
                }
                else{
                    completion(false)
                }
            })
            
        }
    }
   
    @IBAction func sendButton(_ sender: UIButton) {
        guard let chatText = self.chatTextField.text, chatText.isEmpty == false else {
            return
        }
        mesajGönderme(text: chatText) { (isSuccess) in
            if(isSuccess){
                self.chatTextField.text=""
            }
        }
        
    }
    
    @IBAction func logOut(_ sender: Any) {
            do{
                try Auth.auth().signOut()
            }
            catch let signOutError as NSError{
                print("Error signing out : %@",signOutError)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initial = storyboard.instantiateInitialViewController()
            UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
   
    

}
