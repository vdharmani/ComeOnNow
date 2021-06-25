//
//  ChildDetailVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 25/06/21.
//

import UIKit

class ChildDetailVC: UIViewController {

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var name:String?
    var dob:String?
    var gender:String?
    var image:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        ageLabel.text = dob
        genderLabel.text = gender
        var sPhotoStr = image
        sPhotoStr = sPhotoStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if sPhotoStr != ""{
            mainImg.sd_setImage(with: URL(string: sPhotoStr ?? ""), placeholderImage:nil)
        }
        
    }
    

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func calendarButton(_ sender: Any) {
    }
    
}
