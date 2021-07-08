//
//  ChildDetailVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 25/06/21.
//

import UIKit
protocol SendingAddBOToBOMainPageDelegateProtocol {
    func sendDataToBO(myData: Bool)
}
class ChildDetailVC: UIViewController {
    var delegate: SendingAddBOToBOMainPageDelegateProtocol? = nil

    
    @IBOutlet weak var appointmentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var parentGuardianLbl: UILabel!
    
    @IBOutlet weak var appointmentChildDetailView: UIView!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var navBarLbl: UILabel!
    
    @IBOutlet weak var descStaticLbl: UILabel!
    var name:String?
    var dob:String?
    var gender:String?
    var image:String?
    var appointment_time_from:String?
    var appointment_time_to:String?
    var appointment_date:String?

    var desc:String?
    var appointmentDetailsDict: AppointmentDetailsDict<AnyHashable>?
    var isFromAppointment = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromAppointment == true{
//            descriptionView.isHidden = true
            navBarLbl.text = "Appointment Detail"
            descriptionLbl.text = ""
            descStaticLbl.text = ""
            if appointmentDetailsDict?.appointment_date != ""{
                appointmentChildDetailView.isHidden = false
                appointmentViewHeightConstraint.constant = 79.0
            }else{
                appointmentChildDetailView.isHidden = true
                appointmentViewHeightConstraint.constant = 0
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
            timeLabel.text = "\(appointmentDetailsDict?.appointment_time_to ?? "") - \(appointmentDetailsDict?.appointment_time_from ?? "")"
                //(\(String(describing: hourMin)))
            }
            
        }else{
            descriptionLbl.text = desc
            if appointment_date != ""{
                appointmentChildDetailView.isHidden = false
                appointmentViewHeightConstraint.constant = 79.0
            }else{
                appointmentChildDetailView.isHidden = true
                appointmentViewHeightConstraint.constant = 0
            }
            
            dateLabel.text = appointment_date
            let time1 = appointment_time_to ?? ""
               let time2 = appointment_time_from ?? ""
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
            timeLabel.text = "\(appointment_time_to ?? "") - \(appointment_time_from ?? "")"
//            descriptionView.isHidden = false
            navBarLbl.text = "Child Detail"
        }
        }
        nameLabel.text = name
        ageLabel.text = dob
        genderLabel.text = gender
       let userName = getSAppDefault(key:"UserName") as? String ?? ""
        parentGuardianLbl.text = userName
        
        var sPhotoStr = image
        sPhotoStr = sPhotoStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//        if sPhotoStr != ""{
        mainImg.downloadImage(url:  sPhotoStr ?? "")
//            mainImg.sd_setImage(with: URL(string: sPhotoStr ?? ""), placeholderImage:#imageLiteral(resourceName: "notifyplaceholderImg"))
       // }
        
    }
    
    @IBAction func editChildDetailBtnAction(_ sender: Any) {
        
        let vc = AddChildVC.instantiate(fromAppStoryboard: .Setting)
//        if isFromAppointment == true{
//
//
//
//            vc.appointment_date = appointmentDetailsDict?.appointment_date
//            let time1 = appointmentDetailsDict?.appointment_time_to ?? ""
//               let time2 = appointmentDetailsDict?.appointment_time_from ?? ""
//            if time1 != "" && time2 != ""{
//               let formatter = DateFormatter()
//               formatter.dateFormat = "h:mma"
//
//               let date1 = formatter.date(from: time1)!
//               let date2 = formatter.date(from: time2)!
//
//               let elapsedTime = date2.timeIntervalSince(date1)
//
//               // convert from seconds to hours, rounding down to the nearest hour
//               let hours = floor(elapsedTime / 60 / 60)
//
//               // we have to subtract the number of seconds in hours from minutes to get
//               // the remaining minutes, rounding down to the nearest minute (in case you
//               // want to get seconds down the road)
//               let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
//
//               print("\(Int(hours)) hr and \(Int(minutes)) min")
//               let hourMin = (hours != 0 ? "\(hours) hr" : "\(minutes) min")
//                vc.appointmentTimeStr = "\(appointmentDetailsDict?.appointment_time_to ?? "") - \(appointmentDetailsDict?.appointment_time_from ?? "")"
//                //(\(String(describing: hourMin)))
//            }
//
//        }else{
//            vc.desc = desc
//
//
//            vc.appointment_date = appointment_date
//            let time1 = appointment_time_to ?? ""
//               let time2 = appointment_time_from ?? ""
//            if time1 != "" && time2 != ""{
//               let formatter = DateFormatter()
//               formatter.dateFormat = "h:mma"
//
//               let date1 = formatter.date(from: time1)!
//               let date2 = formatter.date(from: time2)!
//
//               let elapsedTime = date2.timeIntervalSince(date1)
//
//               // convert from seconds to hours, rounding down to the nearest hour
//               let hours = floor(elapsedTime / 60 / 60)
//
//               // we have to subtract the number of seconds in hours from minutes to get
//               // the remaining minutes, rounding down to the nearest minute (in case you
//               // want to get seconds down the road)
//               let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
//
//               print("\(Int(hours)) hr and \(Int(minutes)) min")
//               let hourMin = (hours != 0 ? "\(hours) hr" : "\(minutes) min")
//                vc.appointmentTimeStr = "\(appointment_time_to ?? "") - \(appointment_time_from ?? "")"
////            descriptionView.isHidden = false
//            navBarLbl.text = "Child Detail"
//        }
//        }
        vc.name = name
        vc.dob = dob
        vc.gender = gender
        vc.
        vc.isFromEditChild = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        if self.delegate != nil{
            self.delegate?.sendDataToBO(myData: true)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func calendarButton(_ sender: Any) {
    }
    
}
