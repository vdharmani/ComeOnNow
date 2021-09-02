//
//  ChildDetailVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 25/06/21.
//

import UIKit
import Alamofire
protocol SendingAddBOToBOMainPageDelegateProtocol {
    func sendDataToBO(myData: Bool)
}
class ChildDetailVC: UIViewController {
    var delegate: SendingAddBOToBOMainPageDelegateProtocol? = nil
    
    
    @IBOutlet weak var appointmentTBViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var parentGuardianLbl: UILabel!
    
    
    @IBOutlet weak var appointmentChildTBView: UITableView!
    
    @IBOutlet weak var appointmentChildDetailView: UIView!
    
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var navBarLbl: UILabel!
    
    @IBOutlet weak var descStaticLbl: UILabel!
    
    @IBOutlet weak var editBtnImgView: UIImageView!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var seeMoreViewObj: UIView!
    
    var name:String?
    var dob:String?
    var actualDob:String?
    
    var gender:String?
    var image:String?
    var photo:String?
    
    var appointment_time_from:String?
    var appointment_time_to:String?
    var appointment_date:String?
    var childId:String?
    var desc:String?
    var appointmentDetailsDict: AppointmentDetailsDict<AnyHashable>?
    var childDetailsData = ChildDetailData<Any>(dict: [:])
    var appointmentDetailArr = [AppointmentCDetailsDict<Any>]()

    var isFromAppointment = Bool()
    var isFromEdit = Bool()
    var isFromNotification = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isFromNotification == true{
            editBtn.isHidden = true
            editBtnImgView.isHidden = true
            getChildDetailByIdApi(childId: childId ?? "")
            seeMoreViewObj.isHidden = false

        }else{
            if isFromAppointment == true{
                editBtn.isHidden = true
                editBtnImgView.isHidden = true
                //            descriptionView.isHidden = true
                navBarLbl.text = "Appointment Detail"
                descriptionLbl.text = ""
                descStaticLbl.text = ""
                if appointment_date != ""{
                    appointmentChildDetailView.isHidden = false
                    appointmentTBViewHeightConstraint.constant = 79.0
                    appointmentChildTBView.isHidden = true
                    seeMoreViewObj.isHidden = true
                }else{
                    appointmentChildDetailView.isHidden = true
                    appointmentChildTBView.isHidden = true
                    seeMoreViewObj.isHidden = true
                    appointmentTBViewHeightConstraint.constant = 0
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
                    //(\(String(describing: hourMin)))
                }
                
            }else{
                seeMoreViewObj.isHidden = false

                editBtn.isHidden = false
                editBtnImgView.isHidden = false
                if desc != ""{
                    descriptionLbl.text = desc
                }else{
                    descriptionLbl.text = ""
                    descStaticLbl.text = ""
                }
                
                if appointmentDetailsDict?.appointment_date != ""{
//                    appointmentChildDetailView.isHidden = false
//                    appointmentViewHeightConstraint.constant = 79.0
                    getChildDetailByIdApi(childId: childId ?? "")

//                    appointmentChildDetailView.isHidden = true
//                    appointmentViewHeightConstraint.constant = 0
                }else{
//                    appointmentChildDetailView.isHidden = true
//                    appointmentViewHeightConstraint.constant = 0
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
                    //            descriptionView.isHidden = false
                    navBarLbl.text = "Child Detail"
                }
            }
            nameLabel.text = name
            ageLabel.text = dob
            genderLabel.text = gender
            let userName = getSAppDefault(key:"UserName") as? String ?? ""
            parentGuardianLbl.text = userName
            
            photo = image
            photo = photo?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            //        if sPhotoStr != ""{
            mainImg.downloadImage(url:  photo ?? "")
            //            mainImg.sd_setImage(with: URL(string: sPhotoStr ?? ""), placeholderImage:#imageLiteral(resourceName: "notifyplaceholderImg"))
            // }
        }
        
        
        
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
        if self.isFromEdit == true{
            vc.name = childDetailsData?.name
            vc.dob = childDetailsData?.actual_dob
            vc.gender = childDetailsData?.gender
            vc.photo = childDetailsData?.image
            vc.childId = childDetailsData?.child_id
        }else{
            vc.name = name
            vc.dob = actualDob
            vc.gender = gender
            vc.photo = photo
            vc.childId = childId
        }
        
        vc.isFromEditChild = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        if self.isFromEdit == true{
            if self.delegate != nil{
                self.delegate?.sendDataToBO(myData: false)
            }
            isFromEdit = false
        }
        else if self.isFromNotification == true{
            if self.delegate != nil{
                self.delegate?.sendDataToBO(myData: true)
            }
        }
        
        else{
            if self.delegate != nil{
                self.delegate?.sendDataToBO(myData: true)
            }
        }
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func calendarButton(_ sender: Any) {
    }
    
    @IBAction func seeMoreBtnAction(_ sender: Any) {
        let vc = ChildAppointmentListVC.instantiate(fromAppStoryboard: .Setting)
        vc.appointmentDetailArr = appointmentDetailArr
        vc.childDetailsData = childDetailsData
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
extension ChildDetailVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointmentDetailArr.count > 0{
        return 3
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppointmentChildDetailTBCell
        cell.dateLbl.text = appointmentDetailArr[indexPath.row].appointment_date
        let time1 = appointmentDetailArr[indexPath.row].appointment_time_to
        let time2 = appointmentDetailArr[indexPath.row].appointment_time_from
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
            cell.timeLbl.text = "\(appointmentDetailArr[indexPath.row].appointment_time_to) - \(appointmentDetailArr[indexPath.row].appointment_time_from)"
            cell.appointmentTypeLbl.text = appointmentDetailArr[indexPath.row].appointments_type
            cell.appointmentTitleLbl.text  = appointmentDetailArr[indexPath.row].title
            DispatchQueue.main.async {
                self.appointmentTBViewHeightConstraint.constant = self.appointmentChildTBView.contentSize.height

            }

        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChildDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.name = childDetailsData?.name
        vc.dob = childDetailsData?.actual_dob
        vc.gender = childDetailsData?.gender
        vc.image = childDetailsData?.image
        vc.isFromAppointment = true
        vc.desc = appointmentDetailArr[indexPath.row].description
        vc.appointment_time_to = appointmentDetailArr[indexPath.row].appointment_time_to
        vc.appointment_time_from = appointmentDetailArr[indexPath.row].appointment_time_from
        vc.appointment_date = appointmentDetailArr[indexPath.row].appointment_date

//        vc.delegate = self
//            vc.appointmentDetailsDict = appointmentArray[indexPath.row].appointmentDetailsDict
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.size.height * 0.13
        return UITableView.automaticDimension
        
    }
    
}
extension ChildDetailVC:SendingDataToBackPageDelegateProtocol{
    
    
    
    func sendDataToBO(childId: String, isFromEdit: Bool) {
        self.childId = childId
        getChildDetailByIdApi(childId: childId)
        self.isFromEdit = isFromEdit
    }
    open func setUIValuesUpdate(dict:ChildDetailData<Any>?){
        descriptionLbl.text = dict?.appointmentDetailArr[0].description
        if appointment_date != ""{
//            appointmentChildDetailView.isHidden = false
//            appointmentViewHeightConstraint.constant = 79.0
        }else{
//            appointmentChildDetailView.isHidden = true
//            appointmentViewHeightConstraint.constant = 0
        }
        
        dateLabel.text = dict?.appointmentDetailArr[0].appointment_date
        let time1 = dict?.appointmentDetailArr[0].appointment_time_to ?? ""
        let time2 = dict?.appointmentDetailArr[0].appointment_time_from ?? ""
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
            timeLabel.text = "\(dict?.appointmentDetailArr[0].appointment_time_to ?? "") - \(dict?.appointmentDetailArr[0].appointment_time_from ?? "")"
            //            descriptionView.isHidden = false
            if isFromNotification == true{
                navBarLbl.text = "Notification Detail"
            }else{
                navBarLbl.text = "Child Detail"
            }
        }
        
        nameLabel.text = dict?.name
        ageLabel.text = dict?.dob
        genderLabel.text = dict?.gender
        let userName = getSAppDefault(key:"UserName") as? String ?? ""
        parentGuardianLbl.text = userName
        
        var sPhotoStr = dict?.image
        sPhotoStr = sPhotoStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        //        if sPhotoStr != ""{
        mainImg.downloadImage(url:  sPhotoStr ?? "")
    }
    open func getChildDetailByIdApi(childId:String){
        
        let userId = getSAppDefault(key: "UserId") as? String ?? ""
        
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let paramds = ["user_id":userId,"child_id":childId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.getChildrenDetailsBychildId
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        DispatchQueue.main.async {
            
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":authToken])
            .responseJSON { (response) in
                DispatchQueue.main.async {
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                }
                
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        self.childDetailsData =  ChildDetailData(dict:JSON)
                        
                        if self.childDetailsData?.status == 1{
                            //                            let userDetailDict = getProfileResp?.user_detail as? [String:AnyHashable] ?? [:]
                            //                            self.userDetailDict = getProfileResp?.user_detail as? [String:AnyHashable] ?? [:]
                            self.setUIValuesUpdate(dict:self.childDetailsData)
                            self.appointmentDetailArr = self.childDetailsData!.appointmentDetailArr
                            self.appointmentChildTBView.reloadData()
                            
                            
                        }
                        else if  self.childDetailsData?.status == 3{
                            DispatchQueue.main.async {
                                
                                Alert.present(
                                    title: AppAlertTitle.appName.rawValue,
                                    message:  self.childDetailsData?.message ?? "",
                                    actions: .ok(handler: {
                                        removeAppDefaults(key:"AuthToken")
                                        removeAppDefaults(key:"UserName")
                                        
                                        
                                        appDel.logOut()
                                        
                                    }),
                                    from: self
                                )
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                
                                Alert.present(
                                    title: AppAlertTitle.appName.rawValue,
                                    message: self.childDetailsData?.message ?? "",
                                    actions: .ok(handler: {
                                        
                                    }),
                                    from: self
                                )
                            }
                        }
                        
                        
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    print(error)
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: AppAlertTitle.connectionError.rawValue,
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
                    }
                }
            }
        
        
    }
    
    
    
}
