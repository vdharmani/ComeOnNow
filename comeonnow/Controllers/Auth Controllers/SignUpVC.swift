//
//  SignUpVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 21/06/21.
//

import UIKit
import SVProgressHUD

class SignUpVC: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var phoneNumTF: UITextField!
    
    @IBOutlet weak var phoneView: UIView!
    
    @IBOutlet weak var checkUncheckBtn: UIButton!
    
    
    
    let rest = RestManager()

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case userTextField:
            userView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        case emailTextField:
            emailView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            userView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        case phoneNumTF :
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            userView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            phoneView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)

        case passwordTextField :
            passwordView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            userView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

       
        default:break
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
            userView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
           phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        emailTextField.delegate = self
                userTextField.delegate = self
        passwordTextField.delegate = self


    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func termOfServiceBtnAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Setting", bundle: nil)

        let CMDVC = storyBoard.instantiateViewController(withIdentifier:"WebVC") as? WebVC
        CMDVC?.linkurl = kBASEURL + SettingWebLinks.termsAndConditions
        CMDVC?.linkLblText = "Terms of service"

        if let CMDVC = CMDVC {
            navigationController?.pushViewController(CMDVC, animated: true)
        }
    }
    
    @IBAction func checkUncheckBtnAction(_ sender: UIButton) {
        if sender.tag == 0{
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            sender.tag = 1
        }else{
            sender.setImage(#imageLiteral(resourceName: "unCheck"), for: .normal)
            sender.tag = 0
        }
    }
    
    
    
    @IBAction func signUpButton(_ sender: Any) {
  
        if userTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterUserName,
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
                message:AppSignInForgotSignUpAlertNessage.validEmail,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if phoneNumTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:AppSignInForgotSignUpAlertNessage.enterPhoneNumber,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if phoneNumTF.text!.count < 10 || phoneNumTF.text!.count > 14{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:AppSignInForgotSignUpAlertNessage.phoneNumberLimit,
                actions: .ok(handler: {
                }),
                from: self
            )
          
        }
        else if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:AppSignInForgotSignUpAlertNessage.enterPassword,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if passwordTextField.text!.count < 6 {
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:AppSignInForgotSignUpAlertNessage.passwordLimit,
                actions: .ok(handler: {
                }),
                from: self
            )
          
        }
//        let defaultImage = UIImage(named: "addBtnImage.png")
//        if firstBtnImage?.pngData() != defaultImage?.pngData(){
        else if checkUncheckBtn.currentImage?.pngData() == UIImage(named:"unCheck")?.pngData() {
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:AppSignInForgotSignUpAlertNessage.allowTermsConditionMessage,
                actions: .ok(handler: {
                }),
                from: self
            )
          
        }
        else{
            signUpApi()
        }
    }
    open func signUpApi(){
        guard let url = URL(string: kBASEURL + WSMethods.signUp) else { return }
        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: emailTextField.text ?? "", forKey: "email")
        rest.httpBodyParameters.add(value: passwordTextField.text ?? "", forKey: "password")
        rest.httpBodyParameters.add(value: userTextField.text ?? "", forKey: "userName")
        rest.httpBodyParameters.add(value: phoneNumTF.text ?? "", forKey: "MobileNumber")

        rest.httpBodyParameters.add(value: deviceToken, forKey: "deviceToken")
        rest.httpBodyParameters.add(value: "1", forKey: "deviceType")
        DispatchQueue.main.async {

        AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            DispatchQueue.main.async {

            AFWrapperClass.svprogressHudDismiss(view: self)
            }

            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                //                    let dataString = String(data: data, encoding: .utf8)
                //                    let jsondata = dataString?.data(using: .utf8)
                //                    let decoder = JSONDecoder()
                //                    let jobUser = try? decoder.decode(LoginData, from: jsondata!)
                //
                let loginResp =   LoginSignUpData.init(dict: jsonResult ?? [:])
                if loginResp?.status == 1{
                    setAppDefaults(loginResp?.user_id, key: "UserId")
                    setAppDefaults(loginResp?.authtoken, key: "AuthToken")
                    setAppDefaults(loginResp?.username, key: "UserName")
                DispatchQueue.main.async {
                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: loginResp?.alertMessage ?? "",
                        actions: .ok(handler: {
                            self.navigationController?.popViewController(animated: true)
                        }),
                        from: self
                    )
                }
                }else{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: loginResp?.alertMessage ?? "",
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

    @IBAction func signInButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
