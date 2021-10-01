//
//  ForgotPasswordVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 21/06/21.
//

import UIKit
import SVProgressHUD

class ForgotPasswordVC: UIViewController,UITextFieldDelegate {
    let restF = RestManager()

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField ==  emailTextField {
            emailView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        }
        else {}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
        
       return true
    }
    open func forgotPasswordApi(){
        
        
        guard let url = URL(string: kBASEURL + WSMethods.forgotPassword) else { return }
    
        restF.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        restF.httpBodyParameters.add(value:emailTextField.text ?? "", forKey:"email")
        DispatchQueue.main.async {

       
        AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }

        restF.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            DispatchQueue.main.async {

            AFWrapperClass.svprogressHudDismiss(view: self)
            }
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                
                let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyHashable] ?? [:]
                
                let forgotResp = ForgotPasswordData.init(dict: jsonResult ?? [:])

                if forgotResp?.status == 1{
                    DispatchQueue.main.async {
                        Alert.present(
                            title: AppAlertTitle.appName.rawValue,
                            message: forgotResp?.message ?? "",
                            actions: .ok(handler: {
                                self.navigationController?.popViewController(animated: true)
                            }),
                            from: self
                        )
                    }                }else{
                    DispatchQueue.main.async {

                    Alert.present(
                        title: AppAlertTitle.appName.rawValue,
                        message: forgotResp?.message ?? "",
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
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitButton(_ sender: Any) {
        if emailTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
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
        }else{
        forgotPasswordApi()
        }
    }
    
}
