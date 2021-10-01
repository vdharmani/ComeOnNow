//
//  GetUserProfileDetailEntity.swift
//  comeonnow
//
//  Created by Arshdeep Singh on 24/06/21.
//

import Foundation
//{
//    "status": 1,
//    "message": "user details",
//    "data": {
//        "user_id": "16",
//        "username": "arsh",
//        "email": "dharmaniz.arshdeepsingh@gmail.com",
//        "password": "6072b431c0518f43904ec62aece5c862",
//        "photo": "",
//        "description": "",
//        "verified": "1",
//        "verificate_code": "&U7Rg?",
//        "created_at": "1624423927",
//        "disabled": "0",
//        "allow_push": "0",
//        "device_type": "1",
//        "device_token": "123",
//        "authtoken": "wFtjXLBx$ELPiIpX*VaS"
//    }
//}
struct GetUserProfileData<T>{
  
  
    
    var status: Int
    var message: String
    var user_id: String
    var username: String
    var email: String
    var password: String
    var photo: String
    var description: String
    var verified: String
    var verificate_code: String
    var created_at: String
    var disabled: String
    var allow_push: String
    var device_type: String
    var device_token: String
    var authtoken: String
    var mobile_number:String
    var country_code:String


    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let  dataDict = dict["data"] as? [String:T] ?? [:]
        let user_id = dataDict["user_id"] as? String ?? ""
        let username = dataDict["username"] as? String ?? ""
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
        let country_code = dataDict["country_code"] as? String ?? ""

        self.status = status
        self.message = alertMessage
        self.user_id = user_id
        self.username = username
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
        self.country_code = country_code

    }
}
