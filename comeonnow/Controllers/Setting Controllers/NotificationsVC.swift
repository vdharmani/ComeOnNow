//
//  NotificationsVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 24/06/21.
//

import UIKit
import SVProgressHUD
import Alamofire

class NotificationsVC: UIViewController {

    @IBOutlet weak var notificationsTableView: UITableView!
    var lastChildId = "0"
    var refreshControl =  UIRefreshControl()
    var isFromPagination = false
    var notificationArray = [NotificationListData<Any>]()
    var notificationNUArray = [NotificationListData<Any>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self

        notificationsTableView.register(UINib(nibName: "NotificationsTVC", bundle: nil), forCellReuseIdentifier: "NotificationsTVC")
        let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 0))
        notificationsTableView.insertSubview(refreshView, at: 0)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadtV), for: .valueChanged)
        refreshView.addSubview(refreshControl)
//        self.NotificationsArray.append(NotificationsData(image: "baby1", days: "3 days ago", hideDays: "" , selected: true))
//        self.NotificationsArray.append(NotificationsData(image: "baby2", days: "", hideDays: "2 days ago",selected: false))
//        self.NotificationsArray.append(NotificationsData(image: "baby1", days: "3 mins ago", hideDays: "",selected: true))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lastChildId = ""
        getNotificationListApi()
    }
    @objc func reloadtV() {
        getNotificationListApi()
        isFromPagination = true
        self.refreshControl.endRefreshing()
    }

    open func getNotificationListApi(){
        
        let userId = getSAppDefault(key: "UserId") as? String ?? ""

        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        
        let paramds = ["user_id":userId,"last_notification_id":lastChildId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.notificationDetails
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":authToken])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let getProfileResp =  NotificationsListData.init(dict: JSON )
                        
                        if getProfileResp?.status == 1{
                            self.isFromPagination = false
                            self.lastChildId = getProfileResp!.notificationArray.last?.notification_id ?? ""
                            if self.lastChildId == ""{
                                self.notificationArray = getProfileResp!.notificationArray
                            }else{
                                let hArr = getProfileResp!.notificationArray
                                if hArr.count != 0{
                                    for i in 0..<hArr.count {
                                        self.notificationNUArray.append(hArr[i])
                                    }
                                    self.notificationNUArray.sort {
                                        $0.created > $1.created
                                    }
                                    let uniquePosts = self.notificationNUArray.unique{$0.notification_id }

                                    self.notificationArray = uniquePosts
                                }
                            }
                           

                        DispatchQueue.main.async {
                            self.notificationsTableView.reloadData()
                        }
                            


                        }else{
                            DispatchQueue.main.async {

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
}
extension NotificationsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as! NotificationsTVC
        var sPhotoStr = notificationArray[indexPath.row].image
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//        if sPhotoStr != ""{
            cell.mainImage.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:UIImage(named:"img"))
        //}
        cell.appointmentLabel.text = notificationArray[indexPath.row].description
        
        let createdDate : String = notificationArray[indexPath.row].created //time stamp
        var createdDataDisplayString: String {
            let date = Date(timeIntervalSince1970: Double(createdDate) ?? 0.0).timeAgoSinceDate()
            return "\(date)"
        }
        
        cell.daysLabel.text = createdDataDisplayString
        
        cell.daysHIdeLabel.text = createdDataDisplayString
        if notificationArray[indexPath.row].notification_type == "2"{
            cell.stackView.isHidden = false
            cell.daysHIdeLabel.isHidden = true

        }else{
            cell.stackView.isHidden = true
            cell.daysHIdeLabel.isHidden = false
            cell.daysLabel.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
   
  
    
}

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }

        return "just now"
    }
}
