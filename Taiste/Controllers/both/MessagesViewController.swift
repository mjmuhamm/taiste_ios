//
//  MessagesViewController.swift
//  Taiste
//
//  Created by Malik Muhammad on 5/2/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class MessagesViewController: UIViewController {
    
    let date = Date()
    let df = DateFormatter()
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var travelFeeStack: UIStackView!
    @IBOutlet weak var travelFeeLabel: UILabel!
    
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var requestTravelFeeButton: UIButton!
    
    private var messages : [Messages] = []
    private var sortedMessages : [Messages] = []
    
    var travelFeeOrMessage = ""
    var otherUser = ""
    private var travelFeePriceText = ""
    private var userImageId = ""
    var order : Orders?
    
    @IBOutlet weak var messageText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = otherUser
        
        if chefOrUser == "Chef" {
            requestTravelFeeButton.isHidden = false
        }
        
        if travelFeeOrMessage == "travelFee" {
            loadTravelFeeMessages()
        } else {
            loadMessages()
        }
        
        df.dateFormat = "yyyy-MM-dd HH:mm"
        
    }
    
    private func loadTravelFeeMessages() {
        let storageRef = storage.reference()
        db.collection(chefOrUser).document(Auth.auth().currentUser!.uid).collection("TravelFeeMessages").addSnapshotListener { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        if let chefOrUserI = data["chefOrUser"] as? String, let user = data["user"] as? String, let message = data["message"] as? String, let date = data["date"] as? String, let userEmail = data["userEmail"] as? String, let travelFee = data["travelFee"] as? String {
                         
                            var vari = ""
                            if chefOrUserI == "Chef" {
                                vari = "chefs"
                            } else {
                                vari = "users"
                            }
                            var homeOrAway = ""
                            if userEmail == Auth.auth().currentUser!.email {
                                homeOrAway = "home"
                            } else {
                                homeOrAway = "away"
                            }
                            self.travelFeePriceText = travelFee
                            
                            storageRef.child("\(vari)/\(userEmail)/profileImage/\(user).png").getData(maxSize: 15 * 1024 * 1024) { data, error in
                                
                                let image = UIImage(data: data!)
                               
                                DispatchQueue.main.async {
                                    if self.messages.isEmpty {
                                        self.messages.append(Messages(homeOrAway: homeOrAway, pictureId: user, image: image!, message: message, date: self.df.date(from: date)!, documentId: doc.documentID, chefOrUser: "\(vari.prefix(4))", travelFee: travelFee))
                                        self.messageTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                    } else {
                                        let index = self.messages.firstIndex { $0.documentId == doc.documentID }
                                        if index == nil {
                                            self.sortedMessages = self.messages.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                                            self.messageTableView.insertRows(at: [IndexPath(item: self.sortedMessages.count - 1, section: 0)], with: .fade)
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }

    private func loadMessages() {
        let storageRef = storage.reference()
        db.collection(chefOrUser).document(Auth.auth().currentUser!.uid).collection("Messages").addSnapshotListener { documents, error in
            if error == nil {
                if documents != nil {
                    for doc in documents!.documents {
                        let data = doc.data()
                        if let chefOrUserI = data["chefOrUser"] as? String, let user = data["user"] as? String, let message = data["message"] as? String, let date = data["date"] as? String, let userEmail = data["userEmail"] as? String {
                         
                            var vari = ""
                            if chefOrUserI == "Chef" {
                                vari = "chefs"
                            } else {
                                vari = "users"
                            }
                            var homeOrAway = ""
                            if userEmail == Auth.auth().currentUser!.email {
                                homeOrAway = "home"
                            } else {
                                homeOrAway = "away"
                            }
                            
                            storageRef.child("\(vari)/\(userEmail)/profileImage/\(user).png").getData(maxSize: 15 * 1024 * 1024) { data, error in
                                
                                let image = UIImage(data: data!)
                               
                                DispatchQueue.main.async {
                                    if self.messages.isEmpty {
                                        self.messages.append(Messages(homeOrAway: homeOrAway, pictureId: user, image: image!, message: message, date: self.df.date(from: date)!, documentId: doc.documentID, chefOrUser: "\(vari.prefix(4))", travelFee: ""))
                                        self.messageTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                    } else {
                                        let index = self.messages.firstIndex { $0.documentId == doc.documentID }
                                        if index == nil {
                                            self.sortedMessages = self.messages.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
                                            self.messageTableView.insertRows(at: [IndexPath(item: self.sortedMessages.count - 1, section: 0)], with: .fade)
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func payButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func requestTravelFeeButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "MessagesToTravelFeeSegue", sender: self)
    }
    
    @IBAction func sendMessageButtonPressed(_ sender: Any) {
        let data : [String : Any] = ["chefOrUser" : chefOrUser, "user" : Auth.auth().currentUser!.uid, "message" : messageText.text, "date" : df.string(from: date), "userEmail": Auth.auth().currentUser!.email]
        
        var otherUser = ""
        var otherImageId = ""
        var travelFeeVari = ""
        
        if chefOrUser == "Chef" {
            otherUser = "User"
            otherImageId = order!.userImageId
        } else {
            otherUser = "Chef"
            otherImageId = order!.chefImageId
        }
        if travelFeeOrMessage == "travelFee" {
            travelFeeVari = "TravelFeeMessages"
        } else {
            travelFeeVari = "Messages"
        }
            self.db.collection(chefOrUser).document(Auth.auth().currentUser!.uid).collection(travelFeeVari).document().setData(data)
            self.db.collection(otherUser).document(otherImageId).collection(travelFeeVari).document().setData(data)
        
        self.showToast(message: "Message Sent", font: .systemFont(ofSize: 12))
        
    }
    
    private var chefOrUser = ""
    private var user = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessagesToProfileAsUserSegue" {
            let info = segue.destination as! ProfileAsUserViewController
            info.chefOrUser = chefOrUser
            info.user = user
        } else if segue.identifier == "MessagesToTravelFeeSegue" {
            let info = segue.destination as! TravelFeeViewController
            info.travelFeePriceText = travelFeePriceText
            info.userImageId = userImageId
        }
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-180, width: (self.view.frame.width), height: 70))
        toastLabel.backgroundColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 4
        toastLabel.layer.cornerRadius = 1;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension MessagesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "MessagesReusableCell", for: indexPath) as! MessagesTableViewCell
        var message = messages[indexPath.row]
        
        if message.homeOrAway == "home" {
            cell.awayImage.isHidden = true
            cell.awayMessage.isHidden = true
            cell.awayDate.isHidden = true
            cell.homeImage.isHidden = false
            cell.homeMessage.isHidden = false
            cell.homeDate.isHidden = false
            cell.homeImage.image = message.image
            cell.homeMessage.text = message.message
            cell.homeDate.text = "\(message.date)"
        } else {
            cell.awayImage.isHidden = false
            cell.awayMessage.isHidden = false
            cell.awayDate.isHidden = false
            cell.homeImage.isHidden = true
            cell.homeMessage.isHidden = true
            cell.homeDate.isHidden = true
            cell.awayImage.image = message.image
            cell.awayMessage.text = message.message
            cell.awayDate.text = "\(message.date)"
        }
        
        cell.profileButtonTapped = {
            self.user = message.pictureId
            self.chefOrUser = message.chefOrUser
            self.performSegue(withIdentifier: "MessagesToProfileAsUserSegue", sender: self)
        }
        
        
        
        
        
        
        
        return cell
    }
}
