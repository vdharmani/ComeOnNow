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
protocol SendingDataToBackPageDelegateProtocol {
    func sendDataToBO(childId:String,isFromEdit:Bool)
}
class AddChildVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate{
    var userDetailDict = [String:AnyHashable]()
    var imgArray = [Data]()
    var delegate: SendingDataToBackPageDelegateProtocol? = nil
    
    var isFromEditChild = Bool()
    
    @IBOutlet weak var userChildProfileImgView: UIImageView!
    
    @IBOutlet weak var navBarLbl: UILabel!
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var dOBTF: UITextField!
    
    @IBOutlet weak var genderTF: UITextField!
    
    @IBOutlet weak var firstNameTFView: UIView!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var lastNameTFView: UIView!
    
    @IBOutlet weak var dOBTFView: UIView!
    
    @IBOutlet weak var genderTFView: UIView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var deleteChildImgView: UIImageView!
    
    @IBOutlet weak var deleteChildBtn: UIButton!
    var genderArr = [AnyHashable]()
    var datePicker = UIDatePicker()
    lazy var genderPickerView = UIPickerView()
    var appointmentDetailsDict: AppointmentDetailsDict<AnyHashable>?
    var first_name:String?
    var last_name:String?
    
    var dob:String?
    var gender:String?
    var photo:String?
    var image:String?
    var appointmentTimeStr:String?
    var appointment_time_from:String?
    var appointment_time_to:String?
    var appointment_date:String?
    var childId:String?
    var desc:String?
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTF:
            firstNameTFView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        case lastNameTF:
            lastNameTFView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        case dOBTF :
            dOBTFView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
        case genderTF :
            genderTFView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            
        default:break
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        firstNameTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        dOBTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        genderTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromEditChild == true{
            navBarLbl.text = "Edit Child"
            var sPhotoStr = photo
            sPhotoStr = sPhotoStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            userChildProfileImgView.sd_setImage(with: URL(string: sPhotoStr ?? ""), placeholderImage:#imageLiteral(resourceName: "notifyplaceholderImg"))
            firstNameTF.text = first_name
            lastNameTF.text = last_name
            dOBTF.text = convertDateFormat(inputDate:dob ?? "")
            genderTF.text = gender
            saveBtn.setTitle("Update", for: .normal)
            deleteChildImgView.isHidden = false
            deleteChildBtn.isHidden = false
        }else{
            navBarLbl.text = "Add Child"
            saveBtn.setTitle("Save", for: .normal)
            deleteChildImgView.isHidden = true
            deleteChildBtn.isHidden = true
        }
        
        
        firstNameTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        dOBTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        genderTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        genderArr = ["Male","Female","Other"]
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        
        genderTF.delegate = self
        dOBTF.delegate = self
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closePicker))
        let barButtonItem1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        
        let buttons = [barButtonItem1, barButtonItem]
        toolBar.setItems(buttons, animated: false)
        genderTF.inputView = genderPickerView
        genderTF.inputAccessoryView = toolBar
        setDatePicker()
        // Do any additional setup after loading the view.
    }
    func convertDateFormat(inputDate: String) -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let oldDate = olDateFormatter.date(from: inputDate)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MM-dd-yyyy"
        if oldDate == nil{
            return ""
        }else{
            return convertDateFormatter.string(from: oldDate!)
            
        }
    }
    @objc func closePicker() {
        genderTF.resignFirstResponder()
    }
    open func setDatePicker() {
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.maximumDate = Date()
        dOBTF.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolBar.tintColor = UIColor.gray
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(showSelectedDate))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, doneBtn]
        dOBTF.inputAccessoryView = toolBar
        
    }
    @objc func showSelectedDate() {
        if dOBTF.isFirstResponder{
            let formatter = DateFormatter()
            
            formatter.dateFormat = "YYYY-MM-dd"
            dob = "\(formatter.string(from: datePicker.date))"
            formatter.dateFormat = "MM-dd-yyyy"
            dOBTF.text = "\(formatter.string(from: datePicker.date))"
            dOBTF.resignFirstResponder()
        }
        
    }
    
    @IBAction func deleteChildBtnAction(_ sender: Any) {
        let alert = UIAlertController(title:AppAlertTitle.appName.rawValue, message: "Are you sure want to delete child?", preferredStyle: .alert)
        let Ok = UIAlertAction(title: "Confirm", style: .default, handler: { [self] action in
            alert.dismiss(animated: true)
            deleteChildApi(childId: childId ?? "")
            
            
        })
        let cancel = UIAlertAction(
            title: "Cancel",
            style: .default,
            handler: { action in
                alert.dismiss(animated: true)
            })
        alert.addAction(Ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
        
    }
    open func deleteChildApi(childId:String){
        
        
        let strURL = kBASEURL + WSMethods.childDelete
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        let paramds = ["user_id":retrieveDefaults().0,"child_id":childId] as [String : Any]
        
        DispatchQueue.main.async {
            
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: paramds, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json","token":retrieveDefaults().1])
            .responseJSON { (response) in
                DispatchQueue.main.async {
                    
                    AFWrapperClass.svprogressHudDismiss(view:self)
                }
                
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON as NSDictionary)
                        let status = JSON["status"] as? Int ?? 0
                        let message = JSON["message"] as? String ?? ""
                        
                        if status == 1{
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: TabBarVC.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                
                                Alert.present(
                                    title: AppAlertTitle.appName.rawValue,
                                    message: message,
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
    
    @IBAction func addChildBtnAction(_ sender: Any) {
        let defaultImage = UIImage(named: "notifyplaceholderImg")

        if firstNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterFirstName,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if lastNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterLastName,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else if dOBTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterDOB,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if genderTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.selectGender,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
            else if userChildProfileImgView.image?.pngData() == defaultImage?.pngData(){
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.selectImage,
                actions: .ok(handler: {
                }),
                from: self
            )
        }
        else{
            addChildApi()
        }
        
        
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
    
    func requestWith(endUrl: String, parameters: [AnyHashable : Any]){
        
        let url = endUrl /* your API url */
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data",
            "token":retrieveDefaults().1
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
                    multipartFormData.append(imageData1, withName: "image" , fileName: ranStr + String(i + 1) + ".jpg", mimeType: imageData1.mimeType)
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
                    if self.isFromEditChild == true{
                        let signUpStepData =  EditChildData(dict: respDict)
                        if signUpStepData?.status == 1{
                            if self.delegate != nil{
                                self.delegate?.sendDataToBO(childId:signUpStepData?.editedCdataDict.child_id ?? "", isFromEdit: true)
                            }
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            
                        }
                    }else{
                        let signUpStepData =  ForgotPasswordData(dict: respDict)
                        if signUpStepData?.status == 1{
                            
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            
                        }
                    }
                    
                    
                }else{
                    
                }
                
                
            }
        
        
        
    }
    func addChildApi() {
        let compressedData = (userChildProfileImgView.image?.pngData())!
        imgArray.removeAll()
        
        imgArray.append(compressedData)
        
        if isFromEditChild == true{
            
            let paramds = ["dob":dob ?? "" ,"gender":genderTF.text ?? "","first_name":firstNameTF.text ?? "","last_name":lastNameTF.text ?? "","user_id":retrieveDefaults().0,"child_id":childId ?? ""] as [String : Any]
            
            let strURL = kBASEURL + WSMethods.editChild
            
            self.requestWith(endUrl: strURL , parameters: paramds)
            
        }else{
            let paramds = ["dob":dob ?? "" ,"gender":genderTF.text ?? "","first_name":firstNameTF.text ?? "","last_name":lastNameTF.text ?? "","user_id":retrieveDefaults().0] as [String : Any]
            
            let strURL = kBASEURL + WSMethods.addchildren
            
            self.requestWith(endUrl: strURL , parameters: paramds)
        }
        
        
    }
}
extension AddChildVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return genderArr[row] as? String ?? ""
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        genderTF.text = genderArr[row] as? String ?? ""
        
        
        
    }
    
    
}

