//
//  ChatCell.swift
//  Randis1
//
//  Created by Davut Peker on 16.06.2019.
//  Copyright © 2019 Davut Peker. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    enum bubbleType {
        case incoming
        case outgoing
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        chatTextBubble.layer.cornerRadius = 15
        // Initialization code
    }
    
    @IBOutlet weak var chatTextBubble: UIView!
    @IBOutlet weak var chatStack: UIStackView!
    @IBOutlet weak var kullaniciLabel: UILabel!
    @IBOutlet weak var mesajTextView: UITextView!
    
    func setMesajData(mesaj: Mesaj){
        kullaniciLabel.text = mesaj.gönderici
        mesajTextView.text = mesaj.mesajText
    }
    
    func setBubbleType(type:bubbleType){
        if(type == .incoming){
            chatStack.alignment = .leading
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.3846400374, green: 1, blue: 0.3120013357, alpha: 1)
            mesajTextView.textColor = .black
        }else if(type == .outgoing){
            chatStack.alignment = .trailing
            chatTextBubble.backgroundColor = #colorLiteral(red: 0.5880775753, green: 0.6877527388, blue: 1, alpha: 1)
            mesajTextView.textColor = .white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
