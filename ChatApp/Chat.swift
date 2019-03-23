//
//  Chat.swift
//  ChatApp
//
//  Created by Alper on 22.03.2019.
//  Copyright © 2019 Alper. All rights reserved.
//

import UIKit

class Chat {
    var userName: String?
    var text: String?
    var datePost: String?
    
    init(userName:String,text: String, datePost: String){
    
        self.userName = userName
        self.text = text
        self.datePost = datePost
        
    }
}
