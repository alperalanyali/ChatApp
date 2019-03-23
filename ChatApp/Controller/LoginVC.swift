//
//  LoginVC.swift
//  ChatApp
//
//  Created by Alper on 21.03.2019.
//  Copyright © 2019 Alper. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showChatRoom", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChatRoom" {
            if let destination = segue.destination as? ChatVC {
                guard let userName = nameTextField.text else {return}
                destination.userName = userName
            }
        }
    }

}
