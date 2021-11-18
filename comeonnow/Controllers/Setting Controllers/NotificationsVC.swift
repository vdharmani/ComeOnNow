//
//  NotificationsVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 24/06/21.
//

import UIKit
import SVProgressHUD
import Alamofire
import KRPullLoader

class NotificationsVC: UIViewController {
    var delegate: SendingAddBOToBOMainPageDelegateProtocol? = nil
    var loaderBool = Bool()
    
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var noDataFoundView: UIView!
    
    var lastChildId = "0"
    var notificationArray = [NotificationListData<Any>]()
    var notificationNUArray = [NotificationListData<Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noDataFoundView.isHidden = true
        
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.register(UINib(nibName: "NotificationsTVC", bundle: nil), forCellReuseIdentifier: "NotificationsTVC")
        
        //        notificationsTableView.register(UINib(nibName: "NotificationTVST", bundle: nil), forCellReuseIdentifier: "NotificationTVST")
        
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        notificationsTableView.addPullLoadableView(loadMoreView, type: .loadMore)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if loaderBool == false{
            notificationArray.removeAll()
            notificationNUArray.removeAll()
            lastChildId = ""
            getNotificationListApi()
        }else{
            notificationsTableView.reloadData()
            loaderBool = false
        }
        
    }
    
    
    open func getNotificationListApi(){
        
        
        let paramds = ["user_id":retrieveDefaults().0,"last_notification_id":lastChildId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.notificationDetails
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        DispatchQueue.main.async {
            
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":retrieveDefaults().1])
            .responseJSON { (response) in
                DispatchQueue.main.async {
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                }
                
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let getProfileResp =  NotificationsListData.init(dict: JSON )
                        
                        if getProfileResp?.status == 1{
                            self.lastChildId = getProfileResp!.notificationArray.last?.notification_id ?? ""
                            
                            let hArr = getProfileResp!.notificationArray
                            if hArr.count != 0{
                                DispatchQueue.main.async {
                                    self.noDataFoundView.isHidden = true
                                }
                                for i in 0..<hArr.count {
                                    self.notificationNUArray.append(hArr[i])
                                }
                                self.notificationNUArray.sort {
                                    $0.created > $1.created
                                }
                                let uniquePosts = self.notificationNUArray.unique{$0.notification_id }
                                
                                self.notificationArray = uniquePosts
                            }else{
                                DispatchQueue.main.async {
                                    self.noDataFoundView.isHidden = false
                                }
                            }
                            
                            
                            DispatchQueue.main.async {
                                self.notificationsTableView.reloadData()
                            }
                            
                            
                            
                        }
                        else if getProfileResp?.status == 3{
                            DispatchQueue.main.async {
                                
                                Alert.present(
                                    title: AppAlertTitle.appName.rawValue,
                                    message: getProfileResp?.message ?? "",
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
                            if self.notificationArray.count>0{
                                DispatchQueue.main.async {
                                    
                                    self.noDataFoundView.isHidden = true
                                }
                            }else{
                                DispatchQueue.main.async {
                                    
                                    self.noDataFoundView.isHidden = false
                                }
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
    open func acceptRejectApi(status:String,id:String,notificationId:String){
        
        
        
        let paramds = ["user_id":retrieveDefaults().0,"id":id,"status":status,"notification_id":notificationId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.approveRejectAppointment
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        DispatchQueue.main.async {
            
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":retrieveDefaults().1])
            .responseJSON { (response) in
                DispatchQueue.main.async {
                    
                    AFWrapperClass.svprogressHudDismiss(view: self)
                }
                
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let getProfileResp =  ForgotPasswordData.init(dict: JSON )
                        
                        
                        if getProfileResp?.status == 1{
                            
                            for i in 0..<self.notificationArray.count {
                                
                                let bhh = self.notificationArray[i].notification_id
                                if bhh == notificationId{
                                    if status == "2"{
                                        self.notificationArray.remove(at:i)
                                    }else{
                                        self.notificationArray[i].notification_type = "3"
                                    }
                                    break
                                }
                                
                            }
                            self.notificationsTableView.reloadData()
                            
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
                   
                }
            }
        
        
    }
    @objc func acceptBtnAction(_ sender: UIButton?) {
        var parentCell = sender?.superview
        
        while !(parentCell is NotificationsTVC) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
        let cell1 = parentCell as? NotificationsTVC
        indexPath = notificationsTableView.indexPath(for: cell1!)
        let detailId = notificationArray[indexPath!.row].detail_id
        
        let notificationId = notificationArray[indexPath!.row].notification_id
        acceptRejectApi(status: "1", id: detailId,notificationId: notificationId)
        
        
    }
    @objc func rejectBtnAction(_ sender: UIButton?) {
        var parentCell = sender?.superview
        
        while !(parentCell is NotificationsTVC) {
            parentCell = parentCell?.superview
        }
        var indexPath: IndexPath? = nil
        let cell1 = parentCell as? NotificationsTVC
        indexPath = notificationsTableView.indexPath(for: cell1!)
        
        let detailId = notificationArray[indexPath!.row].detail_id
        
        let notificationId = notificationArray[indexPath!.row].notification_id
        acceptRejectApi(status: "2", id: detailId,notificationId: notificationId)
        
        
    }
    
}
extension NotificationsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as! NotificationsTVC
        if notificationArray.count > 0{
            var sPhotoStr = notificationArray[indexPath.row].image
            sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
          
            cell.acceptButton.addTarget(self, action: #selector(acceptBtnAction(_:)), for: .touchUpInside)
            cell.declineButton.addTarget(self, action: #selector(rejectBtnAction(_:)), for: .touchUpInside)
            
            
            let createdDate : String = notificationArray[indexPath.row].created //time stamp
            var createdDataDisplayString: String {
                let date = Date(timeIntervalSince1970: Double(createdDate) ?? 0.0).timeAgoSinceDate()
                return "\(date)"
            }
            
            cell.daysLabel.text = createdDataDisplayString
            
            if notificationArray[indexPath.row].notification_type == "1" && notificationArray[indexPath.row].document != ""{
                cell.docImgView.image = #imageLiteral(resourceName: "docs")
            }else if notificationArray[indexPath.row].notification_type == "1" && notificationArray[indexPath.row].document == ""{
                cell.docImgView.image = #imageLiteral(resourceName: "logo")
            }else{
                cell.docImgView.image = #imageLiteral(resourceName: "appointment")
                
            }
            
            cell.datehideLbl.text = notificationArray[indexPath.row].description
            
            if notificationArray[indexPath.row].notification_type == "2"{
                cell.appointmentLabel.text = notificationArray[indexPath.row].description
                cell.stackView.isHidden = false
                cell.stackViewHeightConstraint.constant = 25
                cell.datehideLbl.isHidden = true
                cell.mainImage.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:UIImage(named:"notifyplaceholderImg"))
                
            }else{
                cell.appointmentLabel.text = notificationArray[indexPath.row].title
                cell.mainImage.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:UIImage(named:"AppIcN"))
                
                cell.stackView.isHidden = true
                cell.stackViewHeightConstraint.constant = 0

                cell.datehideLbl.isHidden = false
                cell.daysLabel.isHidden = false
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        //        if notificationArray[indexPath.row].notification_type == "2"{
        return UITableView.automaticDimension
        //        }else{
        //            return UIScreen.main.bounds.size.height * 0.1
        //        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notificationArray[indexPath.row].notification_type != "2" && notificationArray[indexPath.row].notification_type != "1" {
            let vc = ChildDetailVC.instantiate(fromAppStoryboard: .Setting)
            vc.isFromNotification = true
            vc.childId = notificationArray[indexPath.row].detailDicts.child_id
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: false)
        }else{
            if notificationArray[indexPath.row].document != ""{
                let vc = NotificationDetailVC.instantiate(fromAppStoryboard: .Setting)
                vc.navBarTitleString = "Document"
                
                vc.webLinkUrlString = notificationArray[indexPath.row].document
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
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
extension NotificationsVC:KRPullLoadViewDelegate{
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    
                    self.getNotificationListApi()
                    
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
                self.getNotificationListApi()
                
            }
        }
    }
    
    
}
extension NotificationsVC:SendingAddBOToBOMainPageDelegateProtocol{
    func sendDataToBO(myData: Bool) {
        loaderBool = myData
    }
    
    
}
