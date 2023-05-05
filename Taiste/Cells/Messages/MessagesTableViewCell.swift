//
//  MessagesTableViewCell.swift
//  Taiste
//
//  Created by Malik Muhammad on 5/2/23.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var awayMessage: UILabel!
    @IBOutlet weak var awayDate: UILabel!
    
    @IBOutlet weak var awayButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var homeMessage: UILabel!
    @IBOutlet weak var homeDate: UILabel!
    
    
    var profileButtonTapped : (() -> ()) = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func awayButtonPressed(_ sender: Any) {
        profileButtonTapped()
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        profileButtonTapped()
    }
}
