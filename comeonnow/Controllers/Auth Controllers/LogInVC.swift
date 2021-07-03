//
//  LogInVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 21/06/21.
//

import UIKit
import SVProgressHUD

class LogInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    let rest = RestManager()

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            emailView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        case passwordTextField :
            passwordView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        default:break
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        textField.resignFirstResponder()
       
        return true
    }
    

    @IBAction func forgotPasswordButton(_ sender: Any) {
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logInButton(_ sender: Any) {
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
        }else if passwordTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterPassword,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        
        else{
           
            loginApi()
        }
        

      

    }
    open func resendEmailVerificationApi(){
        
        
        guard let url = URL(string: WS_Staging + WSMethods.resentVerficationEmail) else { return }
    
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value:emailTextField.text ?? "", forKey:"email")

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
    open func loginApi(){
        guard let url = URL(string: kBASEURL + WSMethods.signIn) else { return }
        var deviceToken  = getSAppDefault(key: "DeviceToken") as? String ?? ""
        if deviceToken == ""{
            deviceToken = "123"
        }
        
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.httpBodyParameters.add(value: emailTextField.text ?? "", forKey: "email")
        rest.httpBodyParameters.add(value: passwordTextField.text ?? "", forKey: "password")
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

                DispatchQueue.main.async {
                 
                            
                       
                            
                          let storyBoard = UIStoryboard(name: "Setting", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier:"TabBarVC") as? TabBarVC
                            if let vc = vc {
                              self.navigationController?.pushViewController(vc, animated: true)
                            }
                       
                }
                }
                
              else if loginResp?.status == 2{
                DispatchQueue.main.async {

//                    Alert.present(title: <#T##String?#>, message: <#T##String#>, actions: .retry(handler: {
//
//                    }),.ok(handler: {
//
//                    }), from: self)
                    
                    
                let alert = UIAlertController(title: AppAlertTitle.appName.rawValue, message: loginResp?.alertMessage, preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "Skip", style: UIAlertAction.Style.default, handler: { _ in
                           //Cancel Action
                       }))
                       alert.addAction(UIAlertAction(title: "Resend",
                                                     style: UIAlertAction.Style.destructive,
                                                     handler: {(_: UIAlertAction!) in
                                                       //Sign out action
                                                        self.resendEmailVerificationApi()
                       }))
                       self.present(alert, animated: true, completion: nil)
                }
              }
                else{
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
    @IBAction func signUpButton(_ sender: Any) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
