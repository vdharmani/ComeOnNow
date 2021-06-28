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
    var appointmentDetailsDict: AppointmentDetailsDict<AnyHashable>?
    
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
        dateLabel.text = appointmentDetailsDict?.appointment_date
        let time1 = appointmentDetailsDict?.appointment_time_to ?? ""
           let time2 = appointmentDetailsDict?.appointment_time_from ?? ""
        if time1 != "" && time2 != ""{
           let formatter = DateFormatter()
           formatter.dateFormat = "h:mma"

           let date1 = formatter.date(from: time1)!
           let date2 = formatter.date(from: time2)!

           let elapsedTime = date2.timeIntervalSince(date1)

           // convert from seconds to hours, rounding down to the nearest hour
           let hours = floor(elapsedTime / 60 / 60)

           // we have to subtract the number of seconds in hours from minutes to get
           // the remaining minutes, rounding down to the nearest minute (in case you
           // want to get seconds down the road)
           let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)

           print("\(Int(hours)) hr and \(Int(minutes)) min")
           let hourMin = (hours != 0 ? "\(hours) hr" : "\(minutes) min")
        timeLabel.text = "\(appointmentDetailsDict?.appointment_time_to ?? "") - \(appointmentDetailsDict?.appointment_time_from ?? "")(\(String(describing: hourMin)))"
        }
    }
    

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func calendarButton(_ sender: Any) {
    }
    
}
