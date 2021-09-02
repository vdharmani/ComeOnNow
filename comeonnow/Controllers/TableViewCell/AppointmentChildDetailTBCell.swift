//
//  AppointmentChildDetailTBCell.swift
//  comeonnow
//
//  Created by Apple on 02/09/21.
//

import UIKit

class AppointmentChildDetailTBCell: UITableViewCell {

    @IBOutlet weak var appointmentTitleLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var appointmentTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
