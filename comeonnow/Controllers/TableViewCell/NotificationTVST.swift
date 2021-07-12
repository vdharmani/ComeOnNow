//
//  NotificationTVST.swift
//  comeonnow
//
//  Created by Apple on 09/07/21.
//

import UIKit

class NotificationTVST: UITableViewCell {

    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var appointmentLabel: UILabel!

    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
