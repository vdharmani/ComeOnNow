//
//  NotificationsTVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 24/06/21.
//

import UIKit

class NotificationsTVC: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var appointmentLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineView: UIView!
    @IBOutlet weak var declineLabel: UILabel!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var daysHIdeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
