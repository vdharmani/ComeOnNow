//
//  AppointmentVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 23/06/21.
//

import UIKit
import SVProgressHUD
import Alamofire

class AppointmentVC: UIViewController {
    var lastChildId = "0"
    var refreshControl =  UIRefreshControl()
    var isFromPagination = false
    @IBOutlet weak var appointmentTableView: UITableView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var allDownLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var confirmedDownLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var pendingDownLabel: UILabel!
    var appointmentArray = [AppointmentsListData<Any>]()
    var appointmentNUArray = [AppointmentsListData<Any>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentTableView.dataSource = self
        appointmentTableView.delegate = self

        appointmentTableView.register(UINib(nibName: "AppointmentTVC", bundle: nil), forCellReuseIdentifier: "AppointmentTVC")
        let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 0))
        appointmentTableView.insertSubview(refreshView, at: 0)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadtV), for: .valueChanged)
        refreshView.addSubview(refreshControl)
//        self.AppointArray.append(AppointmentData(image: "baby1", name: "Jose Montero", age: "3 years 10 month", gender: "Girl",date: "28,Jan 2019" ,time: "10:00 AM - 10:30AM (30 min))"))
//        self.AppointArray.append(AppointmentData(image: "baby2", name: "Eischens", age: "5 years 8 month", gender: "Boy",date: "12,Jan 2019",time: "11:00 AM - 11:30AM (30 min)"))
//        self.AppointArray.append(AppointmentData(image: "baby3", name: "Alexander", age: "4 years 5 month", gender: "Girl",date: "28,Jan 2019",time: "10:00 AM - 10:30AM (30 min)"))
       
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lastChildId = ""
        getAppointmentListApi(type: "2")
    }
    @objc func reloadtV() {
        getAppointmentListApi(type: "2")
        isFromPagination = true
        self.refreshControl.endRefreshing()
    }
    open func getAppointmentListApi(type:String){
        
        let userId = getSAppDefault(key: "UserId") as? String ?? ""

        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
       
        let paramds = ["user_id":userId,"last_id":lastChildId,"type":type] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.getAppointmentDetails
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":authToken])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let getProfileResp =  AppointmentListData.init(dict: JSON )
                        
                        if getProfileResp?.status == 1{
                            self.appointmentTableView.isHidden = false

                            self.isFromPagination = false
                            self.lastChildId = getProfileResp!.appointmentArray.last?.child_id ?? ""
                            if self.lastChildId == ""{
                                self.appointmentArray = getProfileResp!.appointmentArray
                            }else{
                                let hArr = getProfileResp!.appointmentArray
                                if hArr.count != 0{
                                    for i in 0..<hArr.count {
                                        self.appointmentNUArray.append(hArr[i])
                                    }
                                    self.appointmentNUArray.sort {
                                        $0.create_date > $1.create_date
                                    }
                                    let uniquePosts = self.appointmentNUArray.unique{$0.child_id}

                                    self.appointmentArray = uniquePosts
                                }
                            }
                           

                        DispatchQueue.main.async {
                            self.appointmentTableView.reloadData()
                        }
                            


                        }else{
                            DispatchQueue.main.async {
                                self.appointmentTableView.isHidden = true
                            Alert.present(
                                title: AppAlertTitle.appName.rawValue,
                                message: getProfileResp?.message ?? "",
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
    @IBAction func allButton(_ sender: Any) {
        self.allLabel.textColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
        self.allDownLabel.backgroundColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
        self.confirmedLabel.textColor = #colorLiteral(red: 0.3725051284, green: 0.3725742996, blue: 0.3725007772, alpha: 1)
        self.confirmedDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.pendingLabel.textColor = #colorLiteral(red: 0.3725051284, green: 0.3725742996, blue: 0.3725007772, alpha: 1)
        self.pendingDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        getAppointmentListApi(type: "2")

    }
    
    @IBAction func confirmedButton(_ sender: Any) {
              self.allLabel.textColor = #colorLiteral(red: 0.3725051284, green: 0.3725742996, blue: 0.3725007772, alpha: 1)
              self.allDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
              self.confirmedLabel.textColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
              self.confirmedDownLabel.backgroundColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
              self.pendingLabel.textColor = #colorLiteral(red: 0.3725051284, green: 0.3725742996, blue: 0.3725007772, alpha: 1)
              self.pendingDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        getAppointmentListApi(type: "1")

    }
    
    @IBAction func pendingButton(_ sender: Any) {
        self.allLabel.textColor = #colorLiteral(red: 0.3725051284, green: 0.3725742996, blue: 0.3725007772, alpha: 1)
              self.allDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
              self.confirmedLabel.textColor = #colorLiteral(red: 0.3725051284, green: 0.3725742996, blue: 0.3725007772, alpha: 1)
              self.confirmedDownLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
              self.pendingLabel.textColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
              self.pendingDownLabel.backgroundColor = #colorLiteral(red: 0.5030716658, green: 0.1234851256, blue: 0.4518293738, alpha: 1)
        getAppointmentListApi(type: "0")

    }
}

extension AppointmentVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentTVC", for: indexPath) as! AppointmentTVC
        cell.nameLabel.text = appointmentArray[indexPath.row].childDetailsDict.name
        cell.ageLabel.text = appointmentArray[indexPath.row].childDetailsDict.dob
        cell.genderLabel.text = appointmentArray[indexPath.row].childDetailsDict.gender
        
        var sPhotoStr = appointmentArray[indexPath.row].childDetailsDict.image
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//        if sPhotoStr != ""{
            cell.mainImage.sd_setImage(with: URL(string: sPhotoStr ), placeholderImage:nil)
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
            cell.timeLabel.text = "\(appointmentArray[indexPath.row].appointment_time_to ) - \(appointmentArray[indexPath.row].appointment_time_from )(\(String(describing: hourMin)))"
        
    }
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}

