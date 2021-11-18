//
//  HomeVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 22/06/21.
//

import UIKit
import SVProgressHUD
import SDWebImage
import KRPullLoader
import Alamofire

class HomeVC: UIViewController{
    
    
    @IBOutlet weak var noDataFoundView: UIView!
    let restHCL = RestManager()
    var lastChildId = "0"
    @IBOutlet weak var homeTableView: UITableView!
    var homeArray = [ChildListData<AnyHashable>]()
    var homeNUArray = [ChildListData<AnyHashable>]()
    var loaderBool = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noDataFoundView.isHidden = true
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        homeTableView.register(UINib(nibName: "HomeTVC", bundle: nil), forCellReuseIdentifier: "HomeTVC")
        let loadMoreView = KRPullLoadView()
        loadMoreView.delegate = self
        homeTableView.addPullLoadableView(loadMoreView, type: .loadMore)
        
        
    }
    
    open func homeChildListApi(){
        guard let url = URL(string: kBASEURL + WSMethods.getChildrenDetails) else { return }
        restHCL.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restHCL.requestHttpHeaders.add(value: retrieveDefaults().1, forKey: "token")
        restHCL.httpBodyParameters.add(value: retrieveDefaults().0, forKey: "user_id")
        restHCL.httpBodyParameters.add(value:lastChildId , forKey: "lastChildId")
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        
        restHCL.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
            }
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                
                
                let loginResp =   HomeChildListData.init(dict: jsonResult ?? [:])
                if loginResp?.status == 1{
              
                    self.lastChildId = loginResp!.homeArray.last?.child_id ?? ""
                    
                    let hArr = loginResp!.homeArray
                    if hArr.count != 0{
                        DispatchQueue.main.async {
                            
                            self.noDataFoundView.isHidden = true
                        }
                        for i in 0..<hArr.count {
                            self.homeNUArray.append(hArr[i])
                        }
                        self.homeNUArray.sort {
                            $0.created_at > $1.created_at
                        }
                        let uniquePosts = self.homeNUArray.unique{$0.child_id }
                        
                        self.homeArray = uniquePosts
                    }else{
                        DispatchQueue.main.async {
                            
                            self.noDataFoundView.isHidden = false
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
                    }
                }
                else if loginResp?.status == 3{
                    DispatchQueue.main.async {
                        
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: loginResp?.message ?? "",
                            actions: .ok(handler: {
                                
                                self.removeDefaults()
                                
                                
                                appDel.logOut()
                                
                            }),
                            from: self
                        )
                    }
                }
                else{
                    if self.homeArray.count>0{
                        DispatchQueue.main.async {
                            self.noDataFoundView.isHidden = true
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.noDataFoundView.isHidden = false
                        }
                    }
                }
            }else{
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if loaderBool == false{
            homeArray.removeAll()
            homeNUArray.removeAll()
            lastChildId = ""
            homeChildListApi()
        }else{
            homeTableView.reloadData()
            loaderBool = false
        }
        
    }
    open func deleteChildApi(childId:String){
        
        
        let strURL = kBASEURL + WSMethods.childDelete
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        let paramds = ["user_id":retrieveDefaults().0,"child_id":childId] as [String : Any]
        
        
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":retrieveDefaults().1])
            .responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let status = JSON["status"] as? Int ?? 0
                        let message = JSON["message"] as? String ?? ""
                        
                        if status == 1{
                            self.homeArray.removeAll()
                            self.homeNUArray.removeAll()
                            self.lastChildId = ""
                            self.homeChildListApi()
                        }else{
                            DispatchQueue.main.async {
                                
                                Alert.present(
                                    title: AppAlertTitle.appName.rawValue,
                                    message: message,
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
    @IBAction func addChildBtnAction(_ sender: Any) {
        let vc = AddChildVC.instantiate(fromAppStoryboard: .Setting)
        vc.isFromEditChild = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension HomeVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        let sPhotoStr = homeArray[indexPath.row].image
        cell.mainImage.downloadImage(url:  sPhotoStr)
        cell.nameLabel.text = "\(homeArray[indexPath.row].last_name) \(homeArray[indexPath.row].first_name)"
        cell.ageLabel.text = homeArray[indexPath.row].dob
        cell.genderLabel.text = homeArray[indexPath.row].gender
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height * 0.12
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChildDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.first_name = homeArray[indexPath.row].first_name
        vc.last_name = homeArray[indexPath.row].last_name
        vc.dob = homeArray[indexPath.row].dob
        vc.actualDob = homeArray[indexPath.row].actual_dob
        vc.gender = homeArray[indexPath.row].gender
        vc.image = homeArray[indexPath.row].image
        vc.appointmentDetailsDict = homeArray[indexPath.row].appointmentDetailsDict
        vc.childId = homeArray[indexPath.row].child_id
        vc.isFromAppointment = false
        vc.desc = homeArray[indexPath.row].appointmentDetailsDict.description
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: false)
    }
    //    func tableView(_ tableView: UITableView,
    //                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //
    //
    //        // Trash action
    //        let trash = UIContextualAction(style: .destructive,
    //                                       title: "Delete") { [weak self] (action, view, completionHandler) in
    //            let alert = UIAlertController(title:AppAlertTitle.appName.rawValue, message: "Are you sure want to delete child?", preferredStyle: .alert)
    //            let Ok = UIAlertAction(title: "Confirm", style: .default, handler: { [self] action in
    //                alert.dismiss(animated: true)
    //                let childId = self?.homeArray[indexPath.row].child_id ?? ""
    //                self?.deleteChildApi(childId:childId)
    ////                self?.deleteDraftInvoiceApi(indexPath: indexPath)
    //
    //            })
    //                let cancel = UIAlertAction(
    //                    title: "Cancel",
    //                    style: .default,
    //                    handler: { action in
    //                        alert.dismiss(animated: true)
    //                    })
    //                alert.addAction(Ok)
    //                alert.addAction(cancel)
    //            self?.present(alert, animated: true)
    //
    //                                    completionHandler(true)
    //
    //        }
    //        trash.backgroundColor = UIColor(red: 255.0/255.0, green: 248.0/255.0, blue: 254.0/255.0, alpha: 1.0)
    ////        trash.image = UIImage(named: "deleteFT")
    //
    //        UIButton.appearance().setTitleColor(UIColor.purple, for: .normal)
    //        let configuration = UISwipeActionsConfiguration(actions: [trash])
    //
    //        return configuration
    //
    //        // ...
    //    }
    
}

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}
extension HomeVC:KRPullLoadViewDelegate{
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    completionHandler()
                    //                    self.index += 1
                    //                    self.tableView.reloadData()
                    self.homeChildListApi()
                    
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
                self.homeChildListApi()
                //                self.index += 1
                //                self.tableView.reloadData()
            }
        }
    }
}
extension HomeVC:SendingAddBOToBOMainPageDelegateProtocol{
    func sendDataToBO(myData: Bool) {
        loaderBool = myData
    }
}
