//
//  ChefOrdersViewController.swift
//  Taiste
//
//  Created by Malik Muhammad on 2/23/22.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import MaterialComponents.MaterialButtons
import MaterialComponents

class ChefOrdersViewController: UIViewController {
    
    let date = Date()
    let df = DateFormatter()
    private let db = Firestore.firestore()
//    private let chef = Auth.auth().currentUser!.email!

    @IBOutlet weak var chefName: UILabel!
    @IBOutlet weak var education: UILabel!
    @IBOutlet weak var chefPassion: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var chefImage: UIImageView!
    
    @IBOutlet weak var pendingButton: MDCButton!
    @IBOutlet weak var scheduledButton: MDCButton!
    @IBOutlet weak var completeButton: MDCButton!
    
    private var toggle = "Pending"

    private var pendingOrders : [Orders] = []
    private var scheduledOrders : [Orders] = []
    private var completeOrders : [Orders] = []
    
    private var orders : [Orders] = []
    
    @IBOutlet weak var orderTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        orderTableView.register(UINib(nibName: "ChefOrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "ChefOrdersReusableCell")
        orderTableView.delegate = self
        orderTableView.dataSource = self
        
        loadOrders()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = UIColor.white
    }

    private func loadOrders() {
        
        if !orders.isEmpty {
            orders.removeAll()
            orderTableView.reloadData()
        }
        
        var ordersI : [Orders]
        if toggle == "Pending" {
            ordersI = pendingOrders
        } else if toggle == "Scheduled" {
            ordersI = scheduledOrders
        } else {
            ordersI = completeOrders
        }
        if ordersI.isEmpty {
            db.collection("Chef").document(Auth.auth().currentUser!.uid).collection("Orders").addSnapshotListener ({ documents, error in
            
            if error == nil {
                if (documents != nil) {
                for doc in documents!.documents {
                    let data = doc.data()
                    
                    print("orders happening 2")
                    
                    if let cancelled = data["cancelled"] as? String, let chefEmail = data["chefEmail"] as? String, let chefImageId = data["chefImageId"] as? String, let chefUsername = data["chefUsername"] as? String, let city = data["city"] as? String, let state = data["state"] as? String, let distance = data["distance"] as? String, let eventDates = data["eventDates"] as? [String], let eventTimes = data["eventTimes"] as? [String], let eventNotes = data["eventNotes"] as? String, let eventQuantity = data["eventQuantity"] as? String, let eventType = data["eventType"] as? String, let itemDescription = data["itemDescription"] as? String, let itemTitle = data["itemTitle"] as? String, let location = data["location"] as? String, let menuItemId = data["menuItemId"] as? String, let numberOfEvents = data["numberOfEvents"] as? Int, let orderDate = data["orderDate"] as? String, let orderId = data["orderId"] as? String, let orderUpdate = data["orderUpdate"] as? String, let priceToChef = data["priceToChef"] as? Double, let taxesAndFees = data["taxesAndFees"] as? Double, let totalCostOfEvent = data["totalCostOfEvent"] as? Double, let travelFeeExpenseOption = data["travelExpenseOption"] as? String, let travelFee = data["travelFee"] as? String, let travelFeeAccepted = data["travelFeeAccepted"] as? String, let travelFeeRequested = data["travelFeeRequested"] as? String, let typeOfService = data["typeOfService"] as? String, let unitPrice = data["unitPrice"] as? String, let user = data["user"] as? String, let userImageId = data["userImageId"] as? String, let creditsApplied = data["creditsApplied"] as? String, let creditIds = data["creditIds"] as? [String], let userNotificationToken = data["userNotificationToken"] as? String, let paymentId = data["paymentIntent"] as? String {
                        
                        print("orders happening 3")
                        let newOrder = Orders(cancelled: cancelled, chefEmail: chefEmail, chefImageId: chefImageId, chefNotificationToken: "chefNotificationToken", chefUsername: chefUsername, city: city, distance: distance, eventDates: eventDates, eventTimes: eventTimes, eventNotes: eventNotes, eventType: eventType, eventQuantity: eventQuantity, itemDescription: itemDescription, itemTitle: itemTitle, location: location, menuItemId: menuItemId, numberOfEvents: numberOfEvents, orderDate: orderDate, orderId: orderId, orderUpdate: orderUpdate, priceToChef: priceToChef, state: state, taxesAndFees: taxesAndFees, totalCostOfEvent: totalCostOfEvent, travelFeeOption: travelFeeExpenseOption, travelFee: travelFee, travelFeeApproved: travelFeeAccepted, travelFeeRequested: travelFeeRequested, typeOfService: typeOfService, unitPrice: unitPrice, user: user, userImageId: userImageId, userNotificationToken: userNotificationToken, documentId: doc.documentID, creditsApplied: creditsApplied, creditIds: creditIds, paymentId: paymentId)
                        
                        if orderUpdate == "pending" {
                            
                            if self.pendingOrders.isEmpty  {
                                self.pendingOrders.append(newOrder)
                                if self.toggle == "Pending" {
                                self.orders = self.pendingOrders
                                self.orderTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                }
                            } else {
                                let index = self.pendingOrders.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.pendingOrders.append(newOrder)
                                    if self.toggle == "Pending" {
                                    self.orders = self.pendingOrders
                                    self.orderTableView.insertRows(at: [IndexPath(item: self.orders.count - 1, section: 0)], with: .fade)
                                }
                            }
                            }
                        } else if orderUpdate == "scheduled" {
                            if self.scheduledOrders.isEmpty {
                                self.scheduledOrders.append(newOrder)
                                if self.toggle == "Scheduled" {
                                self.orders = self.scheduledOrders
                                self.orderTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                }
                            } else {
                                let index = self.scheduledOrders.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.scheduledOrders.append(newOrder)
                                    if self.toggle == "Scheduled" {
                                    self.orders = self.scheduledOrders
                                    self.orderTableView.insertRows(at: [IndexPath(item: self.orders.count - 1, section: 0)], with: .fade)
                                }
                                }
                            }
                        } else if orderUpdate == "complete" {
                            if self.completeOrders.isEmpty {
                                self.completeOrders.append(newOrder)
                                if self.toggle == "Complete" {
                                self.orders = self.completeOrders
                                self.orderTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                                }
                            } else {
                                let index = self.completeOrders.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.completeOrders.append(newOrder)
                                    if self.toggle == "Complete" {
                                    self.orders = self.completeOrders
                                    self.orderTableView.insertRows(at: [IndexPath(item: self.orders.count - 1, section: 0)], with: .fade)
                                }
                            }
                            }
                        }
                    }
                }
            }
            }
        })
        } else {
            if toggle == "Pending" {
                orders = pendingOrders
            } else if toggle == "Scheduled" {
                orders = scheduledOrders
            } else if toggle == "Complete" {
                orders = completeOrders
            }
            orderTableView.reloadData()
        }
    }
    
    private func refundOrder(paymentId: String, amount: Double, orderId: String, userImageId: String, chefImageId: String) {
        let json: [String: Any] = ["paymentId": paymentId,"amount" : amount]
            
        
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            // MARK: Fetch the Intent client secret, Ephemeral Key secret, Customer ID, and publishable key
            var request = URLRequest(url: URL(string: "https://ruh.herokuapp.com/refund")!)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jsonData
            let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data,response, error) in
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let refundId = json["refund_id"],
                    let self = self else {
                // Handle error
                return
                }
                
                DispatchQueue.main.async {
                   
                    let data : [String: Any] = ["refundId" : refundId, "paymentIntent" : paymentId, "orderId" : orderId, "date" : self.df.string(from: Date()), "userImageId" : userImageId, "chefImageId" : chefImageId]
                    let data1 : [String: Any] = ["orderUpdate" : "refunded"]
                    self.db.collection("Refunds").document(orderId).setData(data)
                    self.db.collection("Chef").document(chefImageId).collection("Orders").document(orderId).updateData(data1)
                    self.db.collection("User").document(userImageId).collection("Orders").document(orderId)
                    self.showToast(message: "Item Canceled.", font: .systemFont(ofSize: 12))
                    }
            })
            task.resume()
            
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
    
    @IBAction func pendingOrdersButtonPressed(_ sender: Any) {
        
        toggle = "Pending"
        loadOrders()
        pendingButton.setTitleColor(UIColor.white, for: .normal)
        pendingButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        scheduledButton.backgroundColor = UIColor.white
        scheduledButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        completeButton.backgroundColor = UIColor.white
        completeButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func scheduledOrdersButtonPressed(_ sender: Any) {
        
        toggle = "Scheduled"
        loadOrders()
        pendingButton.backgroundColor = UIColor.white
        pendingButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        scheduledButton.setTitleColor(UIColor.white, for: .normal)
        scheduledButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        completeButton.backgroundColor = UIColor.white
        completeButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func completeOrdersButtonPressed(_ sender: Any) {
        
            toggle = "Complete"
            loadOrders()
            pendingButton.backgroundColor = UIColor.white
            pendingButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
            scheduledButton.backgroundColor = UIColor.white
            scheduledButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
            completeButton.setTitleColor(UIColor.white, for: .normal)
            completeButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    }
    
}

extension ChefOrdersViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: "ChefOrdersReusableCell", for: indexPath) as! ChefOrdersTableViewCell
        var order = orders[indexPath.row]
        
        var service = ""
        if order.typeOfService == "Cater Items" {
            service = "Cater Item"
        } else if order.typeOfService == "Executive Items" {
            service = "Personal Chef Item"
        } else if order.typeOfService == "MealKit Items" {
            service = "MealKit Item"
        }
        cell.itemType.text = service
        cell.orderDate.text = "Order Date: \(order.orderDate)"
        cell.itemTitle.text = order.itemTitle
        cell.eventTypeAndQauntity.text = "Event Type: \(order.eventType)   Event Quantity: \(order.eventQuantity)"
        cell.location.text = "Location: \(order.location)"
        cell.costOfEventText.text = "$\(String(format: "%.2f", order.totalCostOfEvent))"
        cell.taxesAndFeesText.text = "$\(String(format: "%.2f", order.totalCostOfEvent * 0.05))"
        cell.takeHomeText.text = "$\(String(format: "%.2f", (order.totalCostOfEvent - (order.totalCostOfEvent * 0.05))))"
        
        if order.travelFeeOption == "No" {
            cell.messagesForTravelFeeButton.isHidden = true
//            cell.showNotesConstraint.constant = 8
//            cell.cancelConstraint.constant = 8
//            cell.messageConstraint.constant = 8
        } else {
            cell.messagesForTravelFeeButton.isHidden = false
//            cell.showNotesConstraint.constant = 48
//            cell.cancelConstraint.constant = 48
//            cell.messageConstraint.constant = 48
        }
        
        if toggle == "Pending" {
            cell.messagesButton.setTitle("Accept", for: .normal)
            cell.messagesButton.isUppercaseTitle = false
        } else {
            cell.messagesButton.setTitle("Messages", for: .normal)
            cell.messagesButton.isUppercaseTitle = false
        }
        if toggle == "Scheduled" {
            cell.messagesForTravelFeeButton.isHidden = true
        }
        cell.showDatesButtonTapped = {
            cell.showInfoView.isHidden = false
            cell.showInfoLabel.text = "Date(s) of Event"
            for i in 0..<order.eventDates.count {
                if i == 0 {
                    cell.showInfoText.text = "Dates: \(order.eventDates[i]) \(order.eventTimes[i])"
                } else {
                    cell.showInfoText.text = "\(cell.showInfoText.text!), \(order.eventDates[i]) \(order.eventTimes[i])"
                }
            }
            
        }
        
        cell.messagesForTravelFeeButtonTapped = {
            print("user \(order.user)")
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as? MessagesViewController  {
                vc.otherUser = order.user
                vc.chefOrUser = "Chef"
                vc.order = order
                vc.travelFeeOrMessage = "travelFee"
                self.present(vc, animated: true, completion: nil)
            }
            //        ChefOrdersToMessagesSegue
        }
        
        cell.messagesButtonTapped = {
            let month = "\(self.df.string(from: Date()))".prefix(7).suffix(2)
            let year = "\(self.df.string(from: Date()))".prefix(4)
            let yearMonth = "\(year), \(month)"
            print("date \(self.df.string(from: Date()))")
            print("month \(month)")
            print("year \(year)")
            print("yearMonth \(yearMonth)")
            
            let calendar = Calendar(identifier: .gregorian)
            let currentWeek = calendar.component(.weekOfMonth, from: Date())
            let data3: [String: Any] = ["totalPay" : (order.totalCostOfEvent - (order.totalCostOfEvent * 0.05))]
            let data2: [String: Any] = ["orderUpdate" : "scheduled"]
            
            if self.toggle == "Pending" {
                self.db.collection("User").document(order.userImageId).collection("Orders").document(order.documentId).updateData(data2)
                self.db.collection("Chef").document(Auth.auth().currentUser!.uid).collection("Orders").document(order.documentId).updateData(data2)
                self.db.collection("Orders").document(order.documentId).updateData(data2)
                
                self.db.collection("Chef").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(order.typeOfService).collection(order.menuItemId).document("Month").collection(yearMonth).document("Week").collection("Week \(currentWeek)").document().setData(data3)
                
                self.db.collection("Chef").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(order.typeOfService).collection(order.menuItemId).document("Month").collection(yearMonth).document("Total").getDocument(completion: { document, error in
                    if error == nil {
                        if document != nil {
                            let data = document!.data()
                            if data != nil {
                            if let total = data!["Total"] as? Double {
                                let data5 : [String : Any] = ["totalPay" : total + Double(order.totalCostOfEvent)]
                                self.db.collection("Chef").document(order.chefImageId).collection("Dashboard").document(order.typeOfService).collection(order.menuItemId).document("Month").collection(yearMonth).document("Total").updateData(data5)
                            }
                            } else {
                                let data5 : [String : Any] = ["totalPay" : Double(order.totalCostOfEvent)]
                                self.db.collection("Chef").document(order.chefImageId).collection("Dashboard").document(order.typeOfService).collection(order.menuItemId).document("Month").collection(yearMonth).document("Total").setData(data5)
                            }
                        }
                    }
                })
                self.db.collection("Chef").document(Auth.auth().currentUser!.uid).collection("Dashboard").document(order.typeOfService).getDocument { document, error in
                    if error == nil {
                        if document != nil {
                            let data = document!.data()
                            if data != nil {
                            if let total = data!["Total"] as? Double {
                                let data5 : [String : Any] = ["totalPay" : total + Double(order.totalCostOfEvent)]
                                self.db.collection("Chef").document(order.chefImageId).collection("Dashboard").document(order.typeOfService).updateData(data5)
                            }
                            } else {
                                let data5 : [String : Any] = ["totalPay" : Double(order.totalCostOfEvent)]
                                self.db.collection("Chef").document(order.chefImageId).collection("Dashboard").document(order.typeOfService).setData(data5)
                            }
                        }
                    }
                }
                
                if let index = self.orders.firstIndex(where: { $0.documentId == order.documentId }) {
                    self.scheduledOrders.append(self.orders[index])
                    self.orders.remove(at: index)
                    self.pendingOrders.remove(at: index)
                    self.orderTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                }
               
                
               
            } else {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Messages") as? MessagesViewController  {
                vc.otherUser = order.user
                vc.chefOrUser = "Chef"
                vc.order = order
                vc.travelFeeOrMessage = "messages"
                self.present(vc, animated: true, completion: nil)
            }
            }
        }
        
        cell.showNotesButtonTapped = {
            cell.showInfoView.isHidden = false
            cell.showInfoLabel.text = "Notes of Event"
            cell.showInfoText.text = order.eventNotes
        }
        
        cell.showInfoOkButtonTapped = {
            cell.showInfoView.isHidden = true
        }
        
        cell.cancelButtonTapped = {
            if self.toggle == "Pending" {
                self.refundOrder(paymentId: order.paymentId, amount: order.totalCostOfEvent + order.taxesAndFees, orderId: order.documentId, userImageId: order.userImageId, chefImageId: order.chefImageId)
                if let index = self.orders.firstIndex(where: { $0.documentId == order.documentId }) {
                    self.orders.remove(at: index)
                    self.pendingOrders.remove(at: index)
                    self.orderTableView.deleteRows(at: [IndexPath(item:index, section: 0)], with: .fade)
                }
            }
        }
        
        return cell
    }
}

