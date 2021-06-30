//
//  ChangePasswordVC.swift
//  comeonnow
//
//  Created by Arshdeep Singh on 24/06/21.
//

import UIKit
import SVProgressHUD

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var currentPasswordView: UIView!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewView: UIView!
    @IBOutlet weak var confirmNewTextField: UITextField!
    let restCP = RestManager()
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    open func changePasswordApi(){
        guard let url = URL(string: kBASEURL + WSMethods.changePassword) else { return }
    
        let userId  = getSAppDefault(key: "UserId") as? String ?? ""
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        restCP.requestHttpHeaders.add(value: authToken, forKey: "token")
        restCP.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restCP.httpBodyParameters.add(value:userId, forKey: "user_id")
        restCP.httpBodyParameters.add(value:newPasswordTextField.text ?? "", forKey: "newPassword")
        restCP.httpBodyParameters.add(value:currentPasswordTextField.text ?? "", forKey: "oldPassword")
        restCP.httpBodyParameters.add(value:confirmNewTextField.text ?? "", forKey: "confirmPassword")

        SVProgressHUD.show()

        restCP.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
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
        else if currentPasswordTextField.text?.trimmingCharacters(in: .whitespaces) == newPasswordTextField.text?.trimmingCharacters(in: .whitespaces){
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:"New & old password should be different",
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
