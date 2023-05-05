//
//  MessagesViewController.swift
//  Taiste
//
//  Created by Malik Muhammad on 5/2/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MessagesViewController: UIViewController {

    let db = Firestore.firestore()
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var travelFeeStack: UIStackView!
    @IBOutlet weak var travelFeeLabel: UILabel!
    
    @IBOutlet weak var messageTableView: UITableView!
    
    private var messages : [Messages] = []
    
    var travelFeeOrMessage = ""
    var otherUser = ""
    
    @IBOutlet weak var messageText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = otherUser
        
    }
    
    

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payButtonPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        
    }
    
}

extension MessagesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessagesReusableCell", for: indexPath) as! MessagesTableViewCell
        var message = messages[indexPath.row]
        
        return cell
    }
}
