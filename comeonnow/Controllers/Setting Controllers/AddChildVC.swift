//
//  AddChildVC.swift
//  comeonnow
//
//  Created by Arshdeep Singh on 23/06/21.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Alamofire

class AddChildVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    var userDetailDict = [String:AnyHashable]()

    @IBOutlet weak var userChildProfileImgView: UIImageView!
    
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var dOBTF: UITextField!
    
    @IBOutlet weak var genderTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openGenderPickerBtnAction(_ sender: Any) {
        
    }
    
    
    @IBAction func addChildBtnAction(_ sender: Any) {
    }
    
    open func takePhoto() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            let alert = UIAlertController(
                title: "Error",
                message: "Device has no camera",
                preferredStyle: .alert)
            
            let cancel = UIAlertAction(
                title: "OK",
                style: .default,
                handler: { action in
                    alert.dismiss(animated: true)
                })
            alert.addAction(cancel)
            present(alert, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            present(picker, animated: true)
        }
    }
    open func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        userChildProfileImgView.image = chosenImage
        picker.dismiss(animated: true)

    }
    @IBAction func choosePhotoBtnAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
            // Cancel button tappped do nothing.
            actionSheet.dismiss(animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
            // take photo button tapped.
            self.takePhoto()
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            
            // choose photo button tapped.
            self.choosePhoto()
            
        }))
        
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            actionSheet.modalPresentationStyle = .popover
            let popPresenter = actionSheet.popoverPresentationController
            let directions = UIPopoverArrowDirection(rawValue: 0)
            actionSheet.popoverPresentationController?.permittedArrowDirections = directions
            
            popPresenter?.sourceView = view
            popPresenter?.sourceRect = CGRect(x: view.bounds.size.width / 2.0, y: view.bounds.size.height / 2.0, width: 1.0, height: 1.0) // You can set position of popover
            present(actionSheet, animated: true)
        } else {
            present(actionSheet, animated: true)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func saveEditProfileBtnAction(_ sender: Any) {
        if userNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterName,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
//      else if emailTF.text?.trimmingCharacters(in: .whitespaces) == ""{
//            Alert.present(
//                title: AppAlertTitle.appName.rawValue,
//                message: AppSignInForgotSignUpAlertNessage.enterEmail,
//                actions: .ok(handler: {
//                }),
//                from: self
//            )
//        }
//        else  if !validateEmail(strEmail: emailTF.text ?? ""){
//            Alert.present(
//                title: AppAlertTitle.appName.rawValue,
//                message: AppSignInForgotSignUpAlertNessage.validEmail,
//                actions: .ok(handler: {
//                }),
//                from: self
//            )
//        }
        else if phoneNumberTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterPhonenumber,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else{
            editProfileApi()
        }
    }
    func editProfileApi() {
        let compressedData = userChildProfileImgView.image?.jpegData(compressionQuality: 0.2)
        let base64:String = compressedData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        debugPrint("base64------> \(base64)")
        let userId = getSAppDefault(key: "UserId") as? String ?? ""

        let token = getSAppDefault(key: "AuthToken") as? String ?? ""
    
        let paramds = ["name":userNameTF.text ?? "" ,"email":emailTF.text ?? "","phone_number":phoneNumberTF.text ?? "","country":"","image":base64,"country_image":"","userId":userId] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.editProfile
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        SVProgressHUD.show()
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","Token":token])
            .responseJSON { (response) in
                SVProgressHUD.dismiss()

                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let editProfileResp =  LoginData.init(dict: JSON )
                        
                        //                let status = jsonResult?["status"] as? Int ?? 0
                        if editProfileResp?.status == 1{
                            self.navigationController?.popViewController(animated: true)

                            
                        }else{
                            DispatchQueue.main.async {

                            Alert.present(
                                title: AppAlertTitle.appName.rawValue,
                                message: editProfileResp?.message ?? "",
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
