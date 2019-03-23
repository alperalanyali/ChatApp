//
//  ChatCell.swift
//  ChatApp
//
//  Created by Alper on 22.03.2019.
//  Copyright © 2019 Alper. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setChat(chat: Chat){
        userNameLbl.text = chat.userName!
        textView.text = chat.text!
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
