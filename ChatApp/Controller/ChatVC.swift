//
//  ViewController.swift
//  ChatApp
//
//  Created by Alper on 21.03.2019.
//  Copyright © 2019 Alper. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    

    
    //Variables
    var reference = DatabaseReference.init()
    var userName: String?
    var listOfChat = [Chat]()
    var keyboardHeight: CGFloat = 260
    var popupLocation:CGFloat = 70
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableView Delegation and DataSource
        tableView.delegate = self
        tableView.dataSource = self
        //MARK: chatTextField Delegation
        chatTextField.delegate = self
        //MARK: Hide Keyboard Tap Gesture Recognizer
        let hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGR)
        
        //Create Firebase Database Reference
        reference = Database.database().reference()
        //Calling loginAnnoy
        loginAnnony()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //MARK: Get the height of Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    //MARK: IBAction for Send Button
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        
        guard let text = chatTextField.text else {return}
        //Create dictionary for Firebase Database
        let dic = ["name": userName!,"text":text,"post-date": ServerValue.timestamp()] as [String : Any]
        reference.child("chat").childByAutoId().setValue(dic)
        chatTextField.text = ""
        chatTextField.placeholder = "Enter Text"
        
        
    }
    //MARK: Function for login Annonymously
    func loginAnnony(){
        Auth.auth().signInAnonymously(){
            (user,error) in
            
            if let error = error {
                print("Cannot login \(error)")
            } else {
                print("User UIID: \(String(describing: user?.user.uid))")
                self.loadChats()
            }
        }
        
    }
    //MARK: Function for getting the data from Firebase
    func loadChats(){
        
        reference.child("chat").queryOrdered(byChild: "postDate").observe(.value) { (snapshot) in
            
            self.listOfChat.removeAll()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshot{
                    
                    if let postData = snap.value as? [String:AnyObject]{
                        //                        print(postData)
                        let userName = postData["name"] as? String
                        let text = postData["text"] as? String
                        
                        var postDate: CLong?
                        
                        if let postDateIn = postData["post-date"] as? CLong {
                            postDate = postDateIn
                        }
                        self.listOfChat.append(Chat(userName: userName!, text: text!, datePost: "\(postDate)"))
                    }
                }
                self.tableView.reloadData()
                let indexPath = IndexPath(row: self.listOfChat.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    // Hide Keyboard Function
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    //MARK:Function for getting the height of keyboard
    @objc func keyboardWillShow(notification: Notification){
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        self.keyboardHeight = keyboardSize.height
        print(self.keyboardHeight)
        
        
    }
    
    //MARK: TableView's Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        cell.setChat(chat: listOfChat[indexPath.row])
        
        return cell
    }
    
    
}

extension ChatVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        loginAnnony()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        print("Text Field did begin editing")
        self.view.bringSubviewToFront(textField)
        var heightToAnimate = -keyboardHeight + 40
      
        textField.animateView(transform: CGAffineTransform(translationX: 0, y: -keyboardHeight), duration: 0.58)
        self.sendButton.animateView(transform: CGAffineTransform(translationX: 0, y: -keyboardHeight), duration: 0.58)
        self.tableView.animateView(transform: CGAffineTransform(translationX: 0, y: -keyboardHeight), duration: 0.58)
        heightToAnimate -= 60
        print(heightToAnimate)
        
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("Text Field did end editing")
       
        UIView.animate(withDuration: 0.35) {
            self.view.layoutIfNeeded()
        }
        textField.animateView(transform: CGAffineTransform(translationX: 0, y: 0), duration: 0.58)
        self.sendButton.animateView(transform: CGAffineTransform(translationX: 0, y: 0), duration: 0.58)
        self.tableView.animateView(transform: CGAffineTransform(translationX: 0, y: 0), duration: 0.58)
        
    }
    
    
}

extension UIView {
    
    func animateView(transform: CGAffineTransform, duration: TimeInterval){
        UIView.animate(withDuration: duration  , delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = transform
        }, completion: nil)
    }
}
