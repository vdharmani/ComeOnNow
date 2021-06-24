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
    @IBOutlet weak var homeTableView: UITableView!
    var homeArray = [ChildListData<AnyHashable>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        homeTableView.delegate = self

        homeTableView.register(UINib(nibName: "HomeTVC", bundle: nil), forCellReuseIdentifier: "HomeTVC")
        
//        self.homeArray.append(HomeChildListData(image: "baby2", name: "Eischens", age: "5 years 8 month", gender: "Boy"))
       
        
    }
    open func homeChildListApi(){
        guard let url = URL(string: kBASEURL + WSMethods.getChildrenDetails) else { return }
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""

        
        restHCL.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restHCL.requestHttpHeaders.add(value: authToken, forKey: "Token")

        restHCL.httpBodyParameters.add(value: userId, forKey: "user_id")
        restHCL.httpBodyParameters.add(value:"" , forKey: "lastChildId")
    
        
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
                    self.homeArray = loginResp!.homeArray

                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                }
                }else{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: loginResp?.message ?? "",
                            actions: .ok(handler: {
                            }),
                            from: self
                        )
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
        cell.mainImage.image = UIImage(named: homeArray[indexPath.row].image)
        cell.nameLabel.text = homeArray[indexPath.row].name
        cell.ageLabel.text = homeArray[indexPath.row].dob
        cell.genderLabel.text = homeArray[indexPath.row].gender
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
        
    }
    
    
}

