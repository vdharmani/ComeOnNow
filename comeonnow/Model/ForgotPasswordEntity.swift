//
//  ForgotPasswordEntity.swift
//  comeonnow
//
//  Created by Arshdeep Singh on 23/06/21.
//

import Foundation

struct ForgotPasswordData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
   
    
    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
       
       
        self.status = status
        self.message = alertMessage
      

    }
}
