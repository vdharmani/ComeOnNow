//
//  ProfileVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 23/06/21.
//

import UIKit
import SVProgressHUD
import Alamofire




class ProfileVC: UIViewController {

    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var ProfileArray = [ProfileData]()
    var appDel = AppDelegate()
    var getProfileResp: GetUserProfileData<Any>?

    var userDetailDict = [String:AnyHashable]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.setRounded()
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.register(UINib(nibName: "ProfileTVC", bundle: nil), forCellReuseIdentifier: "ProfileTVC")
        self.ProfileArray.append(ProfileData(image: "lock", name: "Change Password"))
        self.ProfileArray.append(ProfileData(image: "about", name: "About"))
        self.ProfileArray.append(ProfileData(image: "privacy", name: "Privacy Policy"))
        self.ProfileArray.append(ProfileData(image: "term", name: "Terms"))
        self.ProfileArray.append(ProfileData(image: "logout", name: "Logout"))
    }
    

    @IBAction func editButton(_ sender: Any) {
        let vc = EditProfileVC.instantiate(fromAppStoryboard: .Setting)
        vc.getProfileResp = self.getProfileResp
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    @IBAction func profileButton(_ sender: Any) {
    }
    
    
 
    
  
    open func setUIValuesUpdate(dict:GetUserProfileData<Any>?){
        nameLabel.text = dict?.username ?? ""
        emailLabel.text = dict?.email ?? ""
       
        var sPhotoStr = dict?.photo ?? ""
        sPhotoStr = sPhotoStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//        if sPhotoStr != ""{
            profileImage.sd_setImage(with: URL(string: sPhotoStr), placeholderImage:UIImage(named: "img"))
       // }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.tabBarController?.tabBar.isHidden = false
        getProfileDetail()

    }
//    @IBAction func editProfileBtnAction(_ sender: Any) {
//        let CMDVC = self.storyboard?.instantiateViewController(withIdentifier: ViewControllerIdentifier.EditProfileVC) as? EditProfileVC
//        CMDVC?.userDetailDict = self.userDetailDict
//        if let CMDVC = CMDVC {
//            navigationController?.pushViewController(CMDVC, animated: true)
//        }
//    }
    open func logOutApi(){
        
        let userId = getSAppDefault(key: "UserId") as? String ?? ""

        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""

        let paramds = ["user_id":userId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.logOut
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":authToken])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let getProfileResp =  ForgotPasswordData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if getProfileResp?.status == 1{
                            removeAppDefaults(key:"AuthToken")
                    
                            self.appDel.logOut()
                          
                           
                            
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
//                    DispatchQueue.main.async {
//
//                    Alert.present(
//                        title: AppAlertTitle.appName.rawValue,
//                        message: AppAlertTitle.connectionError.rawValue,
//                        actions: .ok(handler: {
//                        }),
//                        from: self
//                    )
//                    }
                }
            }
     
        
    }
    open func getProfileDetail(){
        
        let userId = getSAppDefault(key: "UserId") as? String ?? ""

        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""

        let paramds = ["user_id":userId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.getUserDetail
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":authToken])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        self.getProfileResp =  GetUserProfileData.init(dict: JSON )
                        
                        if self.getProfileResp?.status == 1{
//                            let userDetailDict = getProfileResp?.user_detail as? [String:AnyHashable] ?? [:]
//                            self.userDetailDict = getProfileResp?.user_detail as? [String:AnyHashable] ?? [:]
                            
                            self.setUIValuesUpdate(dict:self.getProfileResp)


                        }else{
                            DispatchQueue.main.async {

                            Alert.present(
                                title: AppAlertTitle.appName.rawValue,
                                message: self.getProfileResp?.message ?? "",
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
extension ProfileVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVC", for: indexPath) as! ProfileTVC
        cell.mainImg.image = UIImage(named: ProfileArray[indexPath.row].image)
        cell.detailLabel.text = ProfileArray[indexPath.row].name
        DispatchQueue.main.async {
            self.heightTableView.constant = self.profileTableView.contentSize.height
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UIScreen.main.bounds.size.height * 0.09
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch indexPath.row {
            case 0:
                let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Setting)
                          self.navigationController?.pushViewController(vc, animated: false)
            case 1:
                if let url = URL(string:kBASEURL + SettingWebLinks.aboutUs) {
                    UIApplication.shared.open(url)
                }
            case 2:
                if let url = URL(string:kBASEURL + SettingWebLinks.privacyPolicy) {
                    UIApplication.shared.open(url)
                }
            case 3:
                if let url = URL(string:kBASEURL + SettingWebLinks.termsAndConditions) {
                    UIApplication.shared.open(url)
                }
            case 4:
                let alert = UIAlertController(title: AppAlertTitle.appName.rawValue, message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                           //Cancel Action
                       }))
                       alert.addAction(UIAlertAction(title: "Sign out",
                                                     style: UIAlertAction.Style.destructive,
                                                     handler: {(_: UIAlertAction!) in
                                                       //Sign out action
                                                        self.logOutApi()

                       }))
                       self.present(alert, animated: true, completion: nil)
            default:
                break
            }
        
        }
    
}
struct ProfileData {
    var image : String
    var name : String
  
    init(image : String, name : String) {
        self.image = image
        self.name = name
       
    }
}
