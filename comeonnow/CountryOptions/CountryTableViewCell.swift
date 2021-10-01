//
//  CountryTableViewCell.swift
//  TamimiEcom
//
//  Created by Ansh on 16/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var codeLbl: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    @IBOutlet weak var widthImageConst: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setDataInfo(dict:NSDictionary) {
        titleLbl.text = dict.object(forKey: "name") as? String
        if let code = dict.object(forKey: "code") as? String {
            if let dial_code = dict.object(forKey: "dial_code") as? String {
                codeLbl.text = "\(code) (\(dial_code))"
            }
            self.widthImageConst.constant = 0.0

            if let nameImage = dict.object(forKey: "nameImage") as? String {
                if let image = UIImage(named: nameImage) {
                    self.widthImageConst.constant = 30.0
                    self.flagImage.image = image
                }
            }
    }
    }
}
