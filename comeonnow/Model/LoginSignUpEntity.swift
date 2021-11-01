//
//  LoginSignUpEntity.swift
//  comeonnow
//
//  Created by Arshdeep Singh on 23/06/21.
//

import Foundation

struct LoginSignUpData<T>{
  
    var status:Int
    var alertMessage:String
    var user_id:String
    var username:String
    var first_name:String
    var last_name:String
    var email:String
    var password:String
    var photo:String
    var description:String
    var verified:String
    var verificate_code:String
    var created_at:String
    var disabled:String
    var allow_push:String
    var device_type:String
    var device_token:String
    var authtoken:String
    var mobile_number:String

    
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
       
       let  dataDict = dict["data"] as? [String:T] ?? [:]
       
        
        let user_id = dataDict["user_id"] as? String ?? ""
        let username = dataDict["username"] as? String ?? ""
        let first_name = dataDict["first_name"] as? String ?? ""
        let last_name = dataDict["last_name"] as? String ?? ""

        let email = dataDict["email"] as? String ?? ""
        let password = dataDict["password"] as? String ?? ""
        let photo = dataDict["photo"] as? String ?? ""
        let description = dataDict["description"] as? String ?? ""
        let verified = dataDict["verified"] as? String ?? ""
        let verificate_code = dataDict["verificate_code"] as? String ?? ""
        let created_at = dataDict["created_at"] as? String ?? ""
        let disabled = dataDict["disabled"] as? String ?? ""
        let allow_push = dataDict["allow_push"] as? String ?? ""
        let device_type = dataDict["device_type"] as? String ?? ""
        let device_token = dataDict["device_token"] as? String ?? ""
        let authtoken = dataDict["authtoken"] as? String ?? ""
        let mobile_number = dataDict["mobile_number"] as? String ?? ""

        self.status = status
        self.alertMessage = alertMessage
        self.user_id = user_id
        self.username = username
        self.first_name = first_name
        self.last_name = last_name

        self.email = email
        self.password = password
        self.photo = photo
        self.description = description
        self.verified = verified
        self.verificate_code = verificate_code
        self.created_at = created_at
        self.disabled = disabled
        self.allow_push = allow_push
        self.device_type = device_type
        self.device_token = device_token
        self.authtoken = authtoken
        self.mobile_number = mobile_number


    }
}

extension LoginSignUpData {

    enum CodingKeys: CodingKey {
        case status
        case alertMessage
        case user_id
        case username
        case email
        case password
        case photo
        case description
        case verified
        case verificate_code
        case created_at
        case disabled
        case allow_push
        case device_type
        case device_token
        case authtoken
        case mobile_number

        }
}
