//
//  OrdersViewController.swift
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

class OrdersViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var preferences: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var pendingButton: MDCButton!
    
    @IBOutlet weak var scheduledButton: MDCButton!
    
    @IBOutlet weak var completeButton: MDCButton!
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    private let db = Firestore.firestore()
    private let user = "malik@testing.com"
    
    private var pendingOrders : [Orders] = []
    private var scheduledOrders : [Orders] = []
    private var completeOrders : [Orders] = []
    
    private var orders : [Orders] = []
    
    private var toggle = "Pending"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ordersTableView.register(UINib(nibName: "UserOrderPostTableViewCell", bundle: nil), forCellReuseIdentifier: "UserOrderPostReusableCell")
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        
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
            ordersTableView.reloadData()
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
            db.collection("User").document(Auth.auth().currentUser!.uid).collection("Orders").addSnapshotListener { documents, error in
            
            if error == nil {
                if (documents != nil) {
                for doc in documents!.documents {
                    let data = doc.data()
                    
                    if let cancelled = data["cancelled"] as? String, let chefEmail = data["chefEmail"] as? String, let chefImageId = data["chefImageId"] as? String, let chefUsername = data["chefUsername"] as? String, let city = data["city"] as? String, let state = data["state"] as? String, let distance = data["distance"] as? String, let eventDates = data["eventDates"] as? [String], let eventTimes = data["eventTimes"] as? [String], let eventNotes = data["eventNotes"] as? String, let eventQuantity = data["eventQuantity"] as? String, let eventType = data["eventType"] as? String, let itemDescription = data["itemDescription"] as? String, let itemTitle = data["itemTitle"] as? String, let location = data["location"] as? String,let menuItemId = data["menuItemId"] as? String, let numberOfEvents = data["numberOfEvents"] as? Int, let orderDate = data["orderDate"] as? String, let orderId = data["orderId"] as? String, let orderUpdate = data["orderUpdate"] as? String, let priceToChef = data["priceToChef"] as? Double, let taxesAndFees = data["taxesAndFees"] as? Double, let totalCostOfEvent = data["totalCostOfEvent"] as? Double, let travelFeeExpenseOption = data["travelExpenseOption"] as? String, let travelFee = data["travelFee"] as? String, let travelFeeAccepted = data["travelFeeAccepted"] as? String, let travelFeeRequested = data["travelFeeRequested"] as? String, let typeOfService = data["typeOfService"] as? String, let unitPrice = data["unitPrice"] as? String, let user = data["user"] as? String, let userImageId = data["userImageId"] as? String, let creditsApplied = data["creditsApplied"] as? String, let creditIds = data["creditIds"] as? [String], let userNotificationToken = data["userNotificationToken"] as? String {
                        
                        let newOrder = Orders(cancelled: cancelled, chefEmail: chefEmail, chefImageId: chefImageId, chefNotificationToken: "chefNotificationToken", chefUsername: chefUsername, city: city, distance: distance, eventDates: eventDates, eventTimes: eventTimes, eventNotes: eventNotes, eventType: eventType, eventQuantity: eventQuantity, itemDescription: itemDescription, itemTitle: itemTitle, location: location, menuItemId: menuItemId, numberOfEvents: numberOfEvents, orderDate: orderDate, orderId: orderId, orderUpdate: orderUpdate, priceToChef: priceToChef, state: state, taxesAndFees: taxesAndFees, totalCostOfEvent: totalCostOfEvent, travelFeeOption: travelFeeExpenseOption, travelFee: travelFee, travelFeeApproved: travelFeeAccepted, travelFeeRequested: travelFeeRequested, typeOfService: typeOfService, unitPrice: unitPrice, user: user, userImageId: userImageId, userNotificationToken: userNotificationToken, documentId: doc.documentID, creditsApplied: creditsApplied, creditIds: creditIds)
                        print("orderupdate \(orderUpdate)")
                        if orderUpdate == "pending" {
                            if self.toggle == "Pending" {
                            if self.pendingOrders.isEmpty  {
                                self.pendingOrders.append(newOrder)
                                self.orders = self.pendingOrders
                                self.ordersTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                            } else {
                                let index = self.pendingOrders.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.pendingOrders.append(newOrder)
                                    self.orders = self.pendingOrders
                                    self.ordersTableView.insertRows(at: [IndexPath(item: self.orders.count - 1, section: 0)], with: .fade)
                                }
                            }
                            }
                        } else if orderUpdate == "scheduled" {
                            if self.toggle == "Scheduled" {
                            print("orders happening")
                            if self.scheduledOrders.isEmpty {
                                self.scheduledOrders.append(newOrder)
                                self.orders = self.scheduledOrders
                                self.ordersTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                            } else {
                                let index = self.scheduledOrders.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.scheduledOrders.append(newOrder)
                                    self.orders = self.scheduledOrders
                                    self.ordersTableView.insertRows(at: [IndexPath(item: self.orders.count - 1, section: 0)], with: .fade)
                                }
                            }
                            }
                        } else if orderUpdate == "complete" {
                            if self.toggle == "Complete" {
                            if self.completeOrders.isEmpty {
                                self.completeOrders.append(newOrder)
                                self.orders = self.completeOrders
                                self.ordersTableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .fade)
                            } else {
                                let index = self.completeOrders.firstIndex { $0.documentId == doc.documentID }
                                if index == nil {
                                    self.completeOrders.append(newOrder)
                                    self.orders = self.scheduledOrders
                                    self.ordersTableView.insertRows(at: [IndexPath(item: self.orders.count - 1, section: 0)], with: .fade)
                                }
                            }
                            }
                        }
                    }
                }
            }
            }
        }
        } else {
            if toggle == "Pending" {
                orders = pendingOrders
            } else if toggle == "Scheduled" {
                orders = scheduledOrders
            } else if toggle == "Complete" {
                orders = completeOrders
            }
            ordersTableView.reloadData()
        }
    }
    
    @IBAction func notificationsButton(_ sender: Any) {
    }
    
    @IBAction func pendingButtonPressed(_ sender: Any) {
        
        toggle = "Pending"
        loadOrders()
        pendingButton.setTitleColor(UIColor.white, for: .normal)
        pendingButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        scheduledButton.backgroundColor = UIColor.white
        scheduledButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        completeButton.backgroundColor = UIColor.white
        completeButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func scheduledButtonPressed(_ sender: Any) {
        
        toggle = "Scheduled"
        loadOrders()
        pendingButton.backgroundColor = UIColor.white
        pendingButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        scheduledButton.setTitleColor(UIColor.white, for: .normal)
        scheduledButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
        completeButton.backgroundColor = UIColor.white
        completeButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
    }
    
    @IBAction func completeButtonPressed(_ sender: Any) {
        toggle = "Complete"
        loadOrders()
        pendingButton.backgroundColor = UIColor.white
        pendingButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        scheduledButton.backgroundColor = UIColor.white
        scheduledButton.setTitleColor(UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1), for: .normal)
        completeButton.setTitleColor(UIColor.white, for: .normal)
        completeButton.backgroundColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    }
    
    private var travelFeeOrMessage = ""
    private var orderTransfer : Orders?
    private var otherUser = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserOrdersToMessagesSegue" {
            let info = segue.destination as! MessagesViewController
            info.travelFeeOrMessage = travelFeeOrMessage
            info.order = orderTransfer
            info.otherUser = otherUser
            info.chefOrUser = "User"
        }
    }
    
}

extension OrdersViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "UserOrderPostReusableCell", for: indexPath) as! UserOrderPostTableViewCell
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
        cell.eventTypeAndQuantity.text = "Event Type: \(order.eventType)   Event Quantity: \(order.eventQuantity)"
        cell.location.text = "Location: \(order.location)"
        
        
        if toggle == "Scheduled" {
            cell.messagesForTravelFeeButton.isHidden = true
            cell.messageButtonPressed.isHidden = false
        } else if toggle == "Pending" {
            cell.messagesForTravelFeeButton.isHidden = false
            cell.messageButtonPressed.isHidden = true
        }
        
        if order.travelFeeOption == "No" {
            cell.messagesForTravelFeeButton.isHidden = true
            cell.cancelConstraint.constant = 8
            cell.messageConstraint.constant = 8
        } else {
            cell.messagesForTravelFeeButton.isHidden = false
            cell.cancelConstraint.constant = 48
            cell.messageConstraint.constant = 48
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
            self.travelFeeOrMessage = "travelFee"
            self.orderTransfer = order
            self.otherUser = order.chefUsername
            self.performSegue(withIdentifier: "UserOrdersToMessagesSegue", sender: self)
        }
        
        cell.showNotesButtonTapped = {
            cell.showInfoView.isHidden = false
            cell.showInfoLabel.text = "Notes of Event"
            cell.showInfoText.text = order.eventNotes
        }
        
        cell.showInfoOkButtonTapped = {
            cell.showInfoView.isHidden = true
            
        }
        
        
        
        
    
        
        return cell
    }
}
