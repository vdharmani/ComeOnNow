//
//  EditProfileVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 24/06/21.
//

import UIKit
import SVProgressHUD
import Alamofire

class EditProfileVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate{


    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var bioView: UIView!
    
    @IBOutlet weak var phoneView: UIView!
    
    @IBOutlet weak var bioTV: UITextView!
    
    @IBOutlet weak var userImgView: UIImageView!
    var imgArray = [Data]()
    var getProfileResp: GetUserProfileData<Any>?
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
        
        
        switch textField {
        case usernameTextField:
            userNameView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        case emailTextField :
            emailView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            userNameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        case phoneNumberTF :
            phoneView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            userNameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        default:break
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            userNameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        userNameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        emailTextField.isUserInteractionEnabled = false
        emailTextField.delegate = self
         usernameTextField.delegate = self
        phoneNumberTF.delegate = self

        bioTV.delegate = self
        self.userImgView.setRounded()
        emailTextField.text = getProfileResp?.email
        bioTV.text = getProfileResp?.description
        usernameTextField.text = getProfileResp?.username
        phoneNumberTF.text = getProfileResp?.mobile_number
        var sPhotoStr = getProfileResp?.photo
        sPhotoStr = sPhotoStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
//        if sPhotoStr != ""{
            userImgView.sd_setImage(with: URL(string: sPhotoStr ?? ""), placeholderImage:UIImage(named:"img"))
        //}
        
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
        userImgView.image = chosenImage
        picker.dismiss(animated: true)

    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    
    func requestWith(endUrl: String, parameters: [AnyHashable : Any]){
        
        let url = endUrl /* your API url */
        let authToken = getSAppDefault(key: "AuthToken") as? String ?? ""

        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data",
            "token":authToken
        ]
        DispatchQueue.main.async {

        AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }

        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
            }
          
            
            for i in 0..<self.imgArray.count{
                let imageData1 = self.imgArray[i]
                debugPrint("mime type is\(imageData1.mimeType)")
                let ranStr = String.random(length: 7)
                if imageData1.mimeType == "application/pdf" ||
                    imageData1.mimeType == "application/vnd" ||
                    imageData1.mimeType == "text/plain"{
                    multipartFormData.append(imageData1, withName: "image[\(i + 1)]" , fileName: ranStr + String(i + 1) + ".pdf", mimeType: imageData1.mimeType)
                }else{
                    multipartFormData.append(imageData1, withName: "photo" , fileName: ranStr + String(i + 1) + ".jpg", mimeType: imageData1.mimeType)
                }
                
                
                
            }
            
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: headers, interceptor: nil, fileManager: .default)
        
        .uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
            
        })
        .responseJSON { (response) in
            DispatchQueue.main.async {

            AFWrapperClass.svprogressHudDismiss(view: self)
            }

            print("Succesfully uploaded\(response)")
            let respDict =  response.value as? [String : AnyObject] ?? [:]
            if respDict.count != 0{
                let signUpStepData =  ForgotPasswordData(dict: respDict)
                if signUpStepData?.status == 1{

                    self.navigationController?.popViewController(animated: true)
                }else{
                    
                }
            }else{
                
            }
            
            
        }
        
        
        
    }
    
    func editProfileApi() {
        let compressedData = (userImgView.image?.jpegData(compressionQuality: 0.3))!
        imgArray.removeAll()
       
                imgArray.append(compressedData)
        let userId = getSAppDefault(key: "UserId") as? String ?? ""

    
        let paramds = ["userName":usernameTextField.text ?? "" ,"email":emailTextField.text ?? "","description":bioTV.text ?? "","user_id":userId,"MobileNumber":phoneNumberTF.text ?? ""] as [String : Any]
        
        let strURL = kBASEURL + WSMethods.editProfile
        
        self.requestWith(endUrl: strURL , parameters: paramds)
     
        
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func uploadButton(_ sender: Any) {
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
    @IBAction func saveButton(_ sender: Any) {
        if usernameTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterName,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
      else if emailTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterEmail,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
      else  if !isEmailValid(testStr: emailTextField.text ?? ""){
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.validEmail,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
      else if phoneNumberTF.text?.trimmingCharacters(in: .whitespaces) == ""{
          Alert.present(
              title: AppAlertTitle.appName.rawValue,
              message:AppSignInForgotSignUpAlertNessage.enterPhoneNumber,
              actions: .ok(handler: {
              }),
              from: self
          )
      }
      else if phoneNumberTF.text!.count < 10 || phoneNumberTF.text!.count > 14{
          Alert.present(
              title: AppAlertTitle.appName.rawValue,
              message:AppSignInForgotSignUpAlertNessage.phoneNumberLimit,
              actions: .ok(handler: {
              }),
              from: self
          )
        
      }
        else if bioTV.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterBio,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else{
            editProfileApi()
        }
    }
}
extension EditProfileVC:UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
      
        bioView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        bioView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
      
    }
}
