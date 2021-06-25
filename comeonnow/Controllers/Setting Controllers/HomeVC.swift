//
//  HomeVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 22/06/21.
//

import UIKit
import SVProgressHUD

class HomeVC: UIViewController {
     let restHCL = RestManager()
    var lastChildId = "0"
    var refreshControl =  UIRefreshControl()
    var isFromPagination = false

    @IBOutlet weak var homeTableView: UITableView!
    var homeArray = [ChildListData<AnyHashable>]()
    var homeNUArray = [ChildListData<AnyHashable>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        homeTableView.delegate = self

        homeTableView.register(UINib(nibName: "HomeTVC", bundle: nil), forCellReuseIdentifier: "HomeTVC")
        let refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 0))
        homeTableView.insertSubview(refreshView, at: 0)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadtV), for: .valueChanged)
        refreshView.addSubview(refreshControl)
//        self.homeArray.append(HomeChildListData(image: "baby2", name: "Eischens", age: "5 years 8 month", gender: "Boy"))
       
        
    }
    @objc func reloadtV() {
        homeChildListApi()
        isFromPagination = true
        self.refreshControl.endRefreshing()
    }

    open func homeChildListApi(){
        guard let url = URL(string: kBASEURL + WSMethods.getChildrenDetails) else { return }
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""

        
        restHCL.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restHCL.requestHttpHeaders.add(value: authToken, forKey: "token")

        restHCL.httpBodyParameters.add(value: userId, forKey: "user_id")
        restHCL.httpBodyParameters.add(value:lastChildId , forKey: "lastChildId")
    
        
        SVProgressHUD.show()
        restHCL.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            SVProgressHUD.dismiss()

            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                //                    let dataString = String(data: data, encoding: .utf8)
                //                    let jsondata = dataString?.data(using: .utf8)
                //                    let decoder = JSONDecoder()
                //                    let jobUser = try? decoder.decode(LoginData, from: jsondata!)
                //
                let loginResp =   HomeChildListData.init(dict: jsonResult ?? [:])
                if loginResp?.status == 1{
                    self.isFromPagination = false

//                    if self.homeArray.count > 20{
//                    if self.isFromPagination == true{
//                        self.lastChildId = loginResp!.homeArray.last?.child_id ?? ""
//                    }else{
//
//                    }
                    //}
                    self.lastChildId = loginResp!.homeArray.last?.child_id ?? ""
                    if self.lastChildId == ""{
                        self.homeArray = loginResp!.homeArray
                    }else{
                        let hArr = loginResp!.homeArray
                        if hArr.count != 0{
                            for i in 0..<hArr.count {
                                self.homeNUArray.append(hArr[i])
                            }
                            self.homeNUArray.sort {
                                $0.created_at > $1.created_at
                            }
                            let uniquePosts = self.homeNUArray.unique{$0.child_id }

                            self.homeArray = uniquePosts
                        }
                    }
                   

                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                }
                }else{
//                    DispatchQueue.main.async {
//                        Alert.present(
//                            title: AppAlertTitle.appName.rawValue,
//                            message: loginResp?.message ?? "",
//                            actions: .ok(handler: {
//                            }),
//                            from: self
//                        )
//                    }
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
        lastChildId = ""
        homeChildListApi()
    }
    @IBAction func addChildBtnAction(_ sender: Any) {
        let vc = AddChildVC.instantiate(fromAppStoryboard: .Setting)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension HomeVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        var sPhotoStr = homeArray[indexPath.row].image
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if sPhotoStr != ""{
            cell.mainImage.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:UIImage(named:"img"))
        }
        cell.nameLabel.text = homeArray[indexPath.row].name
        cell.ageLabel.text = homeArray[indexPath.row].dob
        cell.genderLabel.text = homeArray[indexPath.row].gender
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChildDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.name = homeArray[indexPath.row].name
        vc.dob = homeArray[indexPath.row].dob
        vc.gender = homeArray[indexPath.row].gender
        vc.image = homeArray[indexPath.row].image

        
                  self.navigationController?.pushViewController(vc, animated: false)
    }
    
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
