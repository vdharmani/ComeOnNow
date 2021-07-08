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
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var dOBTF: UITextField!
    
    @IBOutlet weak var genderTF: UITextField!
    
    @IBOutlet weak var nameTFView: UIView!
    
    @IBOutlet weak var dOBTFView: UIView!
    
    @IBOutlet weak var genderTFView: UIView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    
    var genderArr = [AnyHashable]()
     var datePicker = UIDatePicker()
    lazy var genderPickerView = UIPickerView()
    var appointmentDetailsDict: AppointmentDetailsDict<AnyHashable>?
    var name:String?
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
        case userNameTF:
            nameTFView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            dOBTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            genderTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)


        case dOBTF :
            nameTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            dOBTFView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)
            genderTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        case genderTF :
            nameTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            dOBTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            genderTFView.borderColor = #colorLiteral(red: 0.5187928081, green: 0.1490950882, blue: 0.4675421715, alpha: 1)

        default:break
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        nameTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dOBTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        genderTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromEditChild == true{
            navBarLbl.text = "Edit Child"
            var sPhotoStr = photo
            sPhotoStr = sPhotoStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    //        if sPhotoStr != ""{
            userChildProfileImgView.sd_setImage(with: URL(string: sPhotoStr ?? ""), placeholderImage:#imageLiteral(resourceName: "notifyplaceholderImg"))
            userNameTF.text = name
            dOBTF.text = dob
            genderTF.text = gender
            saveBtn.setTitle("Update", for: .normal)
            
        }else{
            navBarLbl.text = "Add Child"
            saveBtn.setTitle("Save", for: .normal)

        }
        
        
        nameTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dOBTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        genderTFView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        genderArr = ["Boy","Girl","Other"]
        userNameTF.delegate = self
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
//            datePlaceholderLbl.isHidden = true
            let formatter = DateFormatter()
            
            //   [formatter setDateFormat:@"dd MMMM yyyy"];
            formatter.dateFormat = "YYYY-MM-dd"
            dOBTF.text = "\(formatter.string(from: datePicker.date))"
            dOBTF.resignFirstResponder()
        }
        
    }
 
    
    
    @IBAction func addChildBtnAction(_ sender: Any) {
        if userNameTF.text?.trimmingCharacters(in: .whitespaces) == ""{
            Alert.present(
                title: AppAlertTitle.appName.rawValue,
                message: AppSignInForgotSignUpAlertNessage.enterName,
                actions: .ok(handler: {
                }),
                from: self
            )
        }else if dOBTF.text?.trimmingCharacters(in: .whitespaces) == ""{
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
        }else{
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
//        let compressedData = (userChildProfileImgView.image?.pngData(compressionQuality: 0.3))!
        let compressedData = (userChildProfileImgView.image?.pngData())!
        imgArray.removeAll()
       
                imgArray.append(compressedData)
        
        let userId = getSAppDefault(key: "UserId") as? String ?? ""
        if isFromEditChild == true{

            let paramds = ["dob":dOBTF.text ?? "" ,"gender":genderTF.text ?? "","name":userNameTF.text ?? "","user_id":userId,"child_id":childId ?? ""] as [String : Any]
    
        let strURL = kBASEURL + WSMethods.editChild

            self.requestWith(endUrl: strURL , parameters: paramds)
            
        }else{
            let paramds = ["dob":dOBTF.text ?? "" ,"gender":genderTF.text ?? "","name":userNameTF.text ?? "","user_id":userId] as [String : Any]
        
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

