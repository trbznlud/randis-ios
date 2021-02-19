//
//  HomeController.swift
//  Randis1
//
//  Created by Davut Peker on 14.06.2019.
//  Copyright © 2019 Davut Peker. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase

class HomeController: UIViewController,UITableViewDelegate,UITableViewDataSource{
   
    @IBOutlet weak var tableView: UITableView!
    var roomName = ""
    /**/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRoom = self.rooms[indexPath.row]
        let chatRoomView = self.storyboard?.instantiateViewController(withIdentifier: "chatRoom") as! ChatRoomViewController
        chatRoomView.room = selectedRoom
        roomName = selectedRoom.konu!
        self.performSegue(withIdentifier: "chatRoom", sender: nil)
    }
    
    @IBAction func konuEkle(_ sender: Any) {
        let alert = UIAlertController(title: "Konu Ekle", message: nil, preferredStyle: .alert)
        alert.addTextField{(snapshot) in
            snapshot.placeholder = "Konuyu Giriniz..."
        }
        let action = UIAlertAction(title: "Ekle", style: .default){(_) in
            guard let konu = alert.textFields?.first?.text, konu.isEmpty == false else{
                return
            }
            
            let databaseRef = Database.database().reference()
            let konular = databaseRef.child("ChatSubjects").childByAutoId()
            
            let dataArray:[String: Any] = ["konu":konu.uppercased()]
            konular.setValue(dataArray)
        }
        
        alert.addAction(action)
        present(alert,animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatRoom"{
            let destinationVC = segue.destination as! ChatRoomViewController
            destinationVC.roomName = roomName
        }
    }
    
    var rooms = [Room]()
    /**/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        observeRooms()
    }
    
    
    func observeRooms(){
        let ref = Database.database().reference()
        ref.child("ChatSubjects").observe(.childAdded) { (snapshot) in
            if let dataArray = snapshot.value as? [String: Any]{
                if let roomName = dataArray["konu"] as? String {
                    let room = Room.init(konu:roomName)
                    self.rooms.append(room)
                    self.tableView.reloadData()
                }
            }
        }
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = self.rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = room.konu
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.rooms.count
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
