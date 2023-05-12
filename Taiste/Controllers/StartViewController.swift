//
//  ViewController.swift
//  Taiste
//
//  Created by Malik Muhammad on 2/23/22.
//

import UIKit
import Firebase
import FirebaseAuth
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming


class StartViewController: UIViewController {
    
    let date = Date()
    let df = DateFormatter()
    @IBOutlet weak var termsOfServiceText: UILabel!
    

    @IBOutlet weak var termsOfServiceButton: UIButton!
    @IBOutlet weak var userButton: MDCButton!
    @IBOutlet weak var chefButton: MDCButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        userButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        chefButton.applyOutlinedTheme(withScheme: globalContainerScheme())
        userButton.layer.cornerRadius = 2
        chefButton.layer.cornerRadius = 2
        
        print("date \(Int(Date().timeIntervalSince1970))")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = df.string(from: date)
        let year = dateString.prefix(4)
        let month = dateString.prefix(7).suffix(2)
//        print("date \(year), \(month)")
        
        var normalText = "Please review our "

        var boldText  = "Terms of Service"
        
        var secondNormalText = " and "
        var secondBoldText = "Privacy Policy"
        var thirdNormalText = " before continuing."

        var attributedString = NSMutableAttributedString(string:normalText)

        var attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13)]
        
        var boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        
        var secondAttributedString = NSMutableAttributedString(string:secondNormalText)
        
        var secondBoldString = NSMutableAttributedString(string: secondBoldText, attributes:attrs)
        
        var thirdAttributedString = NSMutableAttributedString(string:thirdNormalText)
        

        
        attributedString.append(boldString)
        attributedString.append(secondAttributedString)
        attributedString.append(secondBoldString)
        attributedString.append(thirdAttributedString)
        
        
        
        
        termsOfServiceText.attributedText = attributedString
        
                                      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc : UITabBarController = UserTabViewController()
//        if Auth.auth().currentUser != nil {
//            if Auth.auth().currentUser!.displayName! == "User" {
//                 //your view controller
//                self.performSegue(withIdentifier: "StartToUserTabSegue", sender: self)
//            } else {
//                let vc = ChefTabViewController() //your view controller
//                self.present(vc, animated: true, completion: nil)
//                self.performSegue(withIdentifier: "StartToChefTabSegue", sender: self)
//
//            }
//        }
    }
    
    
    
    @IBAction func termsOfServiceButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "StartToTermsOfService", sender: self)
    }
    
    @IBAction func privacyPolicyButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "StartToPrivacyPolicy", sender: self)
    }
}





func globalContainerScheme() -> MDCContainerScheming {
  let containerScheme = MDCContainerScheme()
  // Customize containerScheme here...
    let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
    colorScheme.primaryColor = UIColor(red: 98/255, green: 99/255, blue: 72/255, alpha: 1)
    colorScheme.secondaryColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    containerScheme.colorScheme = colorScheme
    
  return containerScheme
}

func secondGlobalContainerScheme() -> MDCContainerScheming {
  let containerScheme = MDCContainerScheme()
  // Customize containerScheme here...
    let colorScheme = MDCSemanticColorScheme(defaults: .material201804)
    colorScheme.primaryColor = UIColor.red
    colorScheme.secondaryColor = UIColor(red: 160/255, green: 162/255, blue: 104/255, alpha: 1)
    containerScheme.colorScheme = colorScheme
    
  return containerScheme
}


