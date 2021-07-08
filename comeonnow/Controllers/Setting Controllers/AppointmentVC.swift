//
//  AppointmentVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 23/06/21.
//

import UIKit
import SVProgressHUD
import Alamofire
import KRPullLoader

class AppointmentVC: UIViewController {
    var lastChildId = "0"
    var loaderBool = Bool()

    var appointmentType = String()
    @IBOutlet weak var appointmentTableView: UITableView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var allDownLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var confirmedDownLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var pendingDownLabel: UILabel!
    @IBOutlet weak var noDataFoundView: UIView!
    
    var appointmentArray = [AppointmentsListData<Any>]()
    var appointmentNUArray = [AppointmentsListData<Any>]()
    
    var confirmedAppointmentArray = [AppointmentsListData<Any>]()
    var confirmedAppointmentNUArray = [AppointmentsListData<Any>]()
    var pendingAppointmentArray = [AppointmentsListData<Any>]()
    var pendingAppointmentNUArray = [AppointmentsListData<Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentType = "2"
        self.noDataFoundView.isHidden = true
        
        appointmentTableView.dataSource = self
        appointmentTableView.delegate = self
        
        appointmentTableView.register(UINib(nibName: "AppointmentTVC", bundle: nil), forCellReuseIdentifier: "AppointmentTVC")
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        appointmentTableView.addPullLoadableView(loadMoreView, type: .loadMore)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.appointmentArray.removeAll()
        if loaderBool == false{
            if appointmentType == "2"{
                self.appointmentNUArray.removeAll()
            lastChildId = ""
            getAppointmentListApi(type: "2")
            }
            else if appointmentType == "1"{
                self.confirmedAppointmentNUArray.removeAll()
                lastChildId = ""
                getAppointmentListApi(type: "1")
            }else{
                self.pendingAppointmentNUArray.removeAll()
                lastChildId = ""
                getAppointmentListApi(type: "0")
            }
        }else{
            appointmentTableView.reloadData()
            loaderBool = false
        }
       
    }
    
    open func getAppointmentListApi(type:String){
        appointmentType = type
        let userId = getSAppDefault(key: "UserId") as? String ?? ""
        
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let paramds = ["user_id":userId,"last_id":lastChildId,"type":type] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.getAppointmentDetails
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        DispatchQueue.main.async {

        AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }

        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":authToken])
            .responseJSON { (response) in
                DispatchQueue.main.async {

                AFWrapperClass.svprogressHudDismiss(view:self)
                }

                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let getProfileResp =  AppointmentListData.init(dict: JSON )
                        
                        if getProfileResp?.status == 1{
                            
                            self.appointmentTableView.isHidden = false
                            
                            self.lastChildId = getProfileResp!.appointmentArray.last?.child_id ?? ""
                            if type == "2"{
                                if self.lastChildId == ""{
                                    self.appointmentArray = getProfileResp!.appointmentArray
                                }else{
                                    let hArr = getProfileResp!.appointmentArray
                                    if hArr.count != 0{
                                        DispatchQueue.main.async {
                                            self.noDataFoundView.isHidden = true
                                        }
                                        
                                        
                                        for i in 0..<hArr.count {
                                            self.appointmentNUArray.append(hArr[i])
                                        }
                                        self.appointmentNUArray.sort {
                                            $0.create_date > $1.create_date
                                        }
                                        let uniquePosts = self.appointmentNUArray.unique{$0.id}
                                        
                                        self.appointmentArray = uniquePosts
                                    }else{
                                        DispatchQueue.main.async {
                                            self.noDataFoundView.isHidden = false
                                        }
                                    }
                                }
                            }else if type == "1"{
                                if self.lastChildId == ""{
                                    self.confirmedAppointmentArray = getProfileResp!.appointmentArray
                                }else{
                                    let hArr = getProfileResp!.appointmentArray
                                    if hArr.count != 0{
                                        DispatchQueue.main.async {
                                            self.noDataFoundView.isHidden = true
                                        }
                                        
                                        
                                        for i in 0..<hArr.count {
                                            self.confirmedAppointmentNUArray.append(hArr[i])
                                        }
                                        self.confirmedAppointmentNUArray.sort {
                                            $0.create_date > $1.create_date
                                        }
                                        let uniquePosts = self.confirmedAppointmentNUArray.unique{$0.id}
                                        
                                        self.confirmedAppointmentArray = uniquePosts
                                    }else{
                                        DispatchQueue.main.async {
                                            self.noDataFoundView.isHidden = false
                                        }
                                    }
                                }
                            }else if type == "0"{
                                if self.lastChildId == ""{
                                    self.pendingAppointmentArray = getProfileResp!.appointmentArray
                                }else{
                                    let hArr = getProfileResp!.appointmentArray
                                    if hArr.count != 0{
                                        DispatchQueue.main.async {
                                            self.noDataFoundView.isHidden = true
                                        }
                                        
                                        
                                        for i in 0..<hArr.count {
                                            self.pendingAppointmentNUArray.append(hArr[i])
                                        }
                                        self.pendingAppointmentNUArray.sort {
                                            $0.create_date > $1.create_date
                                        }
                                        let uniquePosts = self.pendingAppointmentNUArray.unique{$0.id}
                                        
                                        self.pendingAppointmentArray = uniquePosts
                                    }else{
                                        DispatchQueue.main.async {
                                            self.noDataFoundView.isHidden = false
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            DispatchQueue.main.async {
                                self.appointmentTableView.reloadData()
                            }
                            
                            
                            
                        }else{
                            
                            if type == "2"{

                                if self.appointmentArray.count>0{
                                    DispatchQueue.main.async {

                                    self.noDataFoundView.isHidden = true
                                    }
                                }else{
                                    DispatchQueue.main.async {

                                    self.noDataFoundView.isHidden = false
                                    }
                                }
                            }else if type == "1"{
                                if self.confirmedAppointmentArray.count>0{
                                    DispatchQueue.main.async {

                                    self.noDataFoundView.isHidden = true
                                    }
                                }else{
                                    DispatchQueue.main.async {

                                    self.noDataFoundView.isHidden = false
                                    }
                                }
                            }else if type == "0"{
                                self.pendingAppointmentArray.removeAll()
                                if self.pendingAppointmentArray.count>0{
                                    DispatchQueue.main.async {

                                    self.noDataFoundView.isHidden = true
                                    }
                                }else{
                                    DispatchQueue.main.async {

                                    self.noDataFoundView.isHidden = false
                                    }
                                }
                            }
                            
                         
                            
                         
//                            DispatchQueue.main.async {
//                                self.appointmentTableView.isHidden = true
//                                Alert.present(
//                                    title: AppAlertTitle.appName.rawValue,
//                                    message: getProfileResp?.message ?? "",
//                                    actions: .ok(handler: {
//
//                                    }),
//                                    from: self
//                                )
//                            }
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
    @IBAction func allButton(_ sender: Any) {
        self.allLabel.textColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
        self.allDownLabel.backgroundColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
        self.confirmedLabel.textColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        self.confirmedDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.pendingLabel.textColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        self.pendingDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.appointmentNUArray.removeAll()
        self.appointmentArray.removeAll()
        lastChildId = ""
        getAppointmentListApi(type: "2")
        
    }
    
    @IBAction func confirmedButton(_ sender: Any) {
        self.allLabel.textColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        self.allDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.confirmedLabel.textColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
        self.confirmedDownLabel.backgroundColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
        self.pendingLabel.textColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        self.pendingDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.confirmedAppointmentNUArray.removeAll()
        self.confirmedAppointmentArray.removeAll()
        lastChildId = ""
        getAppointmentListApi(type: "1")
        
    }
    
    @IBAction func pendingButton(_ sender: Any) {
        self.allLabel.textColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        self.allDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.confirmedLabel.textColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        self.confirmedDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.pendingLabel.textColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
        self.pendingDownLabel.backgroundColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
        self.pendingAppointmentNUArray.removeAll()
        self.pendingAppointmentArray.removeAll()
        lastChildId = ""
        getAppointmentListApi(type: "0")
        
    }
}

extension AppointmentVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appointmentType == "2"{
            return appointmentArray.count
        }else if appointmentType == "1"{
            return confirmedAppointmentArray.count
        }else{
            return pendingAppointmentArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentTVC", for: indexPath) as! AppointmentTVC
        if appointmentType == "2"{

        cell.nameLabel.text = appointmentArray[indexPath.row].childDetailsDict.name
        cell.ageLabel.text = appointmentArray[indexPath.row].childDetailsDict.dob
        cell.genderLabel.text = appointmentArray[indexPath.row].childDetailsDict.gender
        
        var sPhotoStr = appointmentArray[indexPath.row].childDetailsDict.image
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        //        if sPhotoStr != ""{
        cell.mainImage.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"notifyplaceholderImg"))
        //}
        cell.dateLabel.text = appointmentArray[indexPath.row].appointment_date
        let time1 = appointmentArray[indexPath.row].appointment_time_to
        let time2 = appointmentArray[indexPath.row].appointment_time_from
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
            cell.timeLabel.text = "\(appointmentArray[indexPath.row].appointment_time_to ) - \(appointmentArray[indexPath.row].appointment_time_from )"
            //(\(String(describing: hourMin)))
            
        }
        }else if appointmentType == "1"{
            
            cell.nameLabel.text = confirmedAppointmentArray[indexPath.row].childDetailsDict.name
            cell.ageLabel.text = confirmedAppointmentArray[indexPath.row].childDetailsDict.dob
            cell.genderLabel.text = confirmedAppointmentArray[indexPath.row].childDetailsDict.gender
            
            var sPhotoStr = confirmedAppointmentArray[indexPath.row].childDetailsDict.image
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            //        if sPhotoStr != ""{
            cell.mainImage.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"notifyplaceholderImg"))
            //}
            cell.dateLabel.text = confirmedAppointmentArray[indexPath.row].appointment_date
            let time1 = confirmedAppointmentArray[indexPath.row].appointment_time_to
            let time2 = confirmedAppointmentArray[indexPath.row].appointment_time_from
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
                cell.timeLabel.text = "\(confirmedAppointmentArray[indexPath.row].appointment_time_to ) - \(confirmedAppointmentArray[indexPath.row].appointment_time_from )"
                
            }
        }else{
            
            cell.nameLabel.text = pendingAppointmentArray[indexPath.row].childDetailsDict.name
            cell.ageLabel.text = pendingAppointmentArray[indexPath.row].childDetailsDict.dob
            cell.genderLabel.text = pendingAppointmentArray[indexPath.row].childDetailsDict.gender
            
            var sPhotoStr = pendingAppointmentArray[indexPath.row].childDetailsDict.image
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            //        if sPhotoStr != ""{
            cell.mainImage.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:UIImage(named:"notifyplaceholderImg"))
            //}
            cell.dateLabel.text = pendingAppointmentArray[indexPath.row].appointment_date
            let time1 = pendingAppointmentArray[indexPath.row].appointment_time_to
            let time2 = pendingAppointmentArray[indexPath.row].appointment_time_from
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
                cell.timeLabel.text = "\(pendingAppointmentArray[indexPath.row].appointment_time_to ) - \(pendingAppointmentArray[indexPath.row].appointment_time_from )"
                
            }
            }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if appointmentType == "2"{
            let vc = ChildDetailVC.instantiate(fromAppStoryboard: .Setting)
            vc.name = appointmentArray[indexPath.row].childDetailsDict.name
            vc.dob = appointmentArray[indexPath.row].childDetailsDict.dob
            vc.gender = appointmentArray[indexPath.row].childDetailsDict.gender
            vc.image = appointmentArray[indexPath.row].childDetailsDict.image
            vc.isFromAppointment = true
            vc.desc = appointmentArray[indexPath.row].description
            vc.appointment_time_to = appointmentArray[indexPath.row].appointment_time_to
            vc.appointment_time_from = appointmentArray[indexPath.row].appointment_time_from
            vc.appointment_date = appointmentArray[indexPath.row].appointment_date

            vc.delegate = self
//            vc.appointmentDetailsDict = appointmentArray[indexPath.row].appointmentDetailsDict
            
            self.navigationController?.pushViewController(vc, animated: false)
        }else if appointmentType == "1"{
            let vc = ChildDetailVC.instantiate(fromAppStoryboard: .Setting)
            vc.delegate = self
            vc.name = confirmedAppointmentArray[indexPath.row].childDetailsDict.name
            vc.dob = confirmedAppointmentArray[indexPath.row].childDetailsDict.dob
            vc.gender = confirmedAppointmentArray[indexPath.row].childDetailsDict.gender
            vc.image = confirmedAppointmentArray[indexPath.row].childDetailsDict.image
            vc.isFromAppointment = true
            vc.desc = confirmedAppointmentArray[indexPath.row].description
            vc.appointment_time_to = confirmedAppointmentArray[indexPath.row].appointment_time_to
            vc.appointment_time_from = confirmedAppointmentArray[indexPath.row].appointment_time_from
            vc.appointment_date = appointmentArray[indexPath.row].appointment_date

//            vc.appointmentDetailsDict = appointmentArray[indexPath.row].appointmentDetailsDict
            
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
            let vc = ChildDetailVC.instantiate(fromAppStoryboard: .Setting)
            vc.delegate = self
            vc.name = pendingAppointmentArray[indexPath.row].childDetailsDict.name
            vc.dob = pendingAppointmentArray[indexPath.row].childDetailsDict.dob
            vc.gender = pendingAppointmentArray[indexPath.row].childDetailsDict.gender
            vc.image = pendingAppointmentArray[indexPath.row].childDetailsDict.image
            vc.isFromAppointment = true
            vc.appointment_time_to = pendingAppointmentArray[indexPath.row].appointment_time_to
            vc.appointment_time_from = pendingAppointmentArray[indexPath.row].appointment_time_from

            vc.desc = pendingAppointmentArray[indexPath.row].description
            vc.appointment_date = appointmentArray[indexPath.row].appointment_date

//            vc.appointmentDetailsDict = appointmentArray[indexPath.row].appointmentDetailsDict
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height * 0.2
        
    }
    
}

extension AppointmentVC:KRPullLoadViewDelegate{
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    
                    self.getAppointmentListApi(type: "2")
                    
                }
            default: break
            }
            return
        }
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case let .pulling(offset, threshould):
            if offset.y > threshould {
                pullLoadView.messageLabel.text = "Pull more. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            } else {
                pullLoadView.messageLabel.text = "Release to refresh. offset: \(Int(offset.y)), threshould: \(Int(threshould)))"
            }
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = "Updating..."
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                completionHandler()
                self.getAppointmentListApi(type: "2")
                
            }
        }
    }
    
    
}
extension AppointmentVC:SendingAddBOToBOMainPageDelegateProtocol{
    
    func sendDataToBO(myData: Bool) {
        loaderBool = myData

    }
    
    
    
}
