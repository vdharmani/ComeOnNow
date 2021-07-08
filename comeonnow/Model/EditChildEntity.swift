//
//  EditChildEntity.swift
//  comeonnow
//
//  Created by Apple on 08/07/21.
//

import Foundation
//Succesfully uploadedsuccess({
//    data =     {
//        "child_id" = 6;
//        "created_at" = 1625571957;
//        dob = "2003-07-08";
//        gender = Girl;
//        image = "https://www.dharmani.com/ComeOnNow/webservice/childrenImg/60e692454636d.png";
//        name = "Lovepreet ";
//        "update_at" = 1625723461;
//        "user_id" = 79;
//    };
//    message = "Updated children Successfully";
//    status = 1;
//})
struct EditChildData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var editedCdataDict:EditChildDict<T>
   

    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let  dataDict = dict["data"] as? [String:T] ?? [:]
     
        self.status = status
        self.message = alertMessage
        self.editedCdataDict = EditChildDict(dataDict:dataDict)!
    }
}

//"appointmentDetails": {
//               "id": "2",
//               "user_id": "16",
//               "child_id": "23",
//               "title": "Vaccine against Hepatitis B",
//               "appointment_date": "2021-06-29",
//               "appointment_time_to": "10:00 AM",
//               "appointment_time_from": "11:00 AM",
//               "status": "0",
//               "create_date": "1624877778"
//           }

struct EditChildDict<T>{

    var user_id:String
    var child_id:String
    var dob:String
    var gender:String
    var image:String
    var name:String
    var update_at:String
    var created_at:String
    init?(dataDict:[String:T]) {
        let user_id = dataDict["user_id"] as? String ?? ""
        let child_id = dataDict["child_id"] as? String ?? ""
        let dob = dataDict["dob"] as? String ?? ""
        let gender = dataDict["gender"] as? String ?? ""
        let image = dataDict["image"] as? String ?? ""
        let name = dataDict["name"] as? String ?? ""
        let update_at = dataDict["update_at"] as? String ?? ""
        let created_at = dataDict["created_at"] as? String ?? ""

        
        self.user_id = user_id
        self.child_id = child_id
        self.dob = dob
        self.gender = gender
        self.image = image
        self.name = name
        self.update_at = update_at
        self.created_at = created_at

    }

}
