//
//  SignUpVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 21/06/21.
//

import UIKit
import SVProgressHUD
import SKCountryPicker

class SignUpVC: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    
    @IBOutlet weak var seenUnseenPasswordImgView: UIImageView!
    
    
    @IBOutlet weak var phoneNumTF: UITextField!
    
    @IBOutlet weak var phoneView: UIView!
    
    @IBOutlet weak var checkUncheckBtn: UIButton!
    
    
    @IBOutlet weak var countryCodeBtn: UIButton!
    
    let rest = RestManager()
    var agreeTerms = false
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            firstNameView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        case lastNameTextField:
            lastNameView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        case emailTextField:
            emailView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        case phoneNumTF :
            phoneView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        case passwordTextField :
            passwordView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        default:break
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        firstNameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
           phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true

        firstNameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        emailView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        passwordView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        phoneView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        emailTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        passwordTextField.delegate = self
        self.countryCodeBtn.contentHorizontalAlignment = .center
        guard let country = CountryManager.shared.currentCountry else {
            return
        }
        countryCodeBtn.setTitle(country.countryCode, for: .highlighted)
        countryCodeBtn.clipsToBounds = true
//        setAppDefaults(country.countryName, key: "countryName")
        setAppDefaults("United States", key: "countryName")

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func flag(country:String) -> String {
        let base = 127397
        var usv = String.UnicodeScalarView()
        for i in country.utf16 {
            usv.append(UnicodeScalar(base + Int(i))!)
        }
        return String(usv)
    }
    
    @IBAction func countryCodePickerBtnAction(_ sender: Any) {
        
        
        
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            let selectedCountryCode = country.dialingCode
            let selectedCountryName = self.flag(country:country.countryCode)
            let selectedCountryVal = "\(selectedCountryName)" + "\(selectedCountryCode ?? "")"
            self.countryCodeBtn.setTitle(selectedCountryVal, for: .normal)
            
            setAppDefaults(country.countryName, key: "countryName")

            
        }
        
        countryController.detailColor = UIColor.red
        
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
        sender.isSelected = !sender.isSelected
        self.agreeTerms = sender.isSelected
        sender.setImage(agreeTerms == true ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "unCheck"), for: .normal)
        

    }
    
    @IBAction func passwordSeenUnseenBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.agreeTerms = sender.isSelected
        seenUnseenPasswordImgView.image = agreeTerms == true ? #imageLiteral(resourceName: "eyeshow") : #imageLiteral(resourceName: "eye")
        passwordTextField.isSecureTextEntry = agreeTerms == true ? false : true

      
    }
    
 
    
    @IBAction func signUpButton(_ sender: Any) {
  
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterFirstName,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if lastNameTextField.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterLastName,
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
        else if agreeTerms == false{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message:AppSignInForgotSignUpAlertNessage.allowTermsConditionMessage,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
     
//        let defaultImage = UIImage(named: "addBtnImage.png")
//        if firstBtnImage?.pngData() != defaultImage?.pngData(){
//        else if checkUncheckBtn.currentImage?.pngData() == UIImage(named:"unCheck")?.pngData() {
//            Alert.present(
//                title: AppAlertTitle.appName.rawValue,
//                message:AppSignInForgotSignUpAlertNessage.allowTermsConditionMessage,
//                actions: .ok(handler: {
//                }),
//                from: self
//            )
//
//        }
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
        rest.httpBodyParameters.add(value: firstNameTextField.text ?? "", forKey: "first_name")
        rest.httpBodyParameters.add(value: lastNameTextField.text ?? "", forKey: "last_name")

        rest.httpBodyParameters.add(value: phoneNumTF.text ?? "", forKey: "MobileNumber")
        rest.httpBodyParameters.add(value: getSAppDefault(key: "countryName") as? String ?? "", forKey: "country_code")

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
          
                //
                let loginResp =   LoginSignUpData.init(dict: jsonResult ?? [:])
                if loginResp?.status == 1{
                    self.saveDefaults(userId: loginResp?.user_id ?? "", authToken: loginResp?.authtoken ?? "", userName: "\(loginResp?.last_name ?? "") \( loginResp!.first_name)")


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
