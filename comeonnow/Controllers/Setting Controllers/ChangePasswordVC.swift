//
//  ChangePasswordVC.swift
//  comeonnow
//
//  Created by Arshdeep Singh on 24/06/21.
//

import UIKit
import SVProgressHUD

class ChangePasswordVC: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var currentPasswordView: UIView!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewView: UIView!
    @IBOutlet weak var confirmNewTextField: UITextField!
    
    @IBOutlet weak var seenCPImgView: UIImageView!
    @IBOutlet weak var seenNPImgView: UIImageView!
    @IBOutlet weak var seenCNPImgView: UIImageView!
    
    
    
    let restCP = RestManager()
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case currentPasswordTextField:
            currentPasswordView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        case newPasswordTextField :
            newPasswordView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        case confirmNewTextField :
            confirmNewView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        default:break
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        currentPasswordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        newPasswordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        confirmNewView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPasswordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        newPasswordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        confirmNewView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        currentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmNewTextField.delegate = self
        
    }
    open func changePasswordApi(){
        guard let url = URL(string: kBASEURL + WSMethods.changePassword) else { return }
        
        
        restCP.requestHttpHeaders.add(value: retrieveDefaults().1, forKey: "token")
        restCP.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restCP.httpBodyParameters.add(value:retrieveDefaults().0, forKey: "user_id")
        restCP.httpBodyParameters.add(value:newPasswordTextField.text ?? "", forKey: "newPassword")
        restCP.httpBodyParameters.add(value:currentPasswordTextField.text ?? "", forKey: "oldPassword")
        restCP.httpBodyParameters.add(value:confirmNewTextField.text ?? "", forKey: "confirmPassword")
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        
        
        restCP.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            DispatchQueue.main.async {
                
                AFWrapperClass.svprogressHudDismiss(view: self)
            }
            
            
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                
                let logOutResp =   ForgotPasswordData.init(dict: jsonResult ?? [:])
                if logOutResp?.status == 1{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: logOutResp?.message ?? "",
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
                            message: logOutResp?.message ?? "",
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
    
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seenUnseenCPBtnAction(_ sender: UIButton) {
        if sender.tag == 0{
            sender.tag = 1
            seenCPImgView.image = #imageLiteral(resourceName: "eyeshow")
            currentPasswordTextField.isSecureTextEntry = false
        }else{
            sender.tag = 0
            seenCPImgView.image = #imageLiteral(resourceName: "eye")
            currentPasswordTextField.isSecureTextEntry = true
        }
        
    }
    
    
    @IBAction func ssenUnseenNPBtnAction(_ sender: UIButton) {
        if sender.tag == 0{
            sender.tag = 1
            seenNPImgView.image = #imageLiteral(resourceName: "eyeshow")
            newPasswordTextField.isSecureTextEntry = false
        }else{
            sender.tag = 0
            seenNPImgView.image = #imageLiteral(resourceName: "eye")
            newPasswordTextField.isSecureTextEntry = true
        }
    }
    
    
    @IBAction func seenUnseenCNPBtnAction(_ sender: UIButton) {
        if sender.tag == 0{
            sender.tag = 1
            seenCNPImgView.image = #imageLiteral(resourceName: "eyeshow")
            confirmNewTextField.isSecureTextEntry = false
        }else{
            sender.tag = 0
            seenCNPImgView.image = #imageLiteral(resourceName: "eye")
            confirmNewTextField.isSecureTextEntry = true
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if currentPasswordTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: "Please enter current password",
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if newPasswordTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:"Please enter new password",
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if confirmNewTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:"Please enter confirm password",
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if comparePasswordValidation(strPassword: newPasswordTextField.text ?? "", strConfirmPassword: confirmNewTextField.text ?? "") == false{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.passwordNotMatched,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        
        else{
            changePasswordApi()
        }
    }
}
