//
//  ChildDetailEntity.swift
//  comeonnow
//
//  Created by Apple on 08/07/21.
//

import Foundation
//{
//    data =     {
//        appointmentDetails =         {
//            "appointment_date" = "07-09-2021";
//            "appointment_time_from" = "07:00 AM";
//            "appointment_time_to" = "06:00 AM";
//            "child_id" = 6;
//            "create_date" = 1625638682;
//            description = "Test injection";
//            id = 7;
//            status = 2;
//            title = "Tesst appointment";
//            "user_id" = 79;
//        };
//        "child_id" = 6;
//        "created_at" = 1625571957;
//        dob = "2021 years, 7 months";
//        gender = Girl;
//        image = "https://www.dharmani.com/ComeOnNow/webservice/childrenImg/60e6a5a6f13ae.png";
//        name = "Lovepreet ";
//        "update_at" = 1625728422;
//        "user_id" = 79;
//    };
//    message = "child details";
//    status = 1;
//}
struct ChildDetailData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var childDetailDict:ChildDetail<T>
   

    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let  dataDict = dict["data"] as? [String:T] ?? [:]
     
        self.status = status
        self.message = alertMessage
        self.childDetailDict = ChildDetail(dataDict:dataDict)!

    }
}


struct ChildDetail<T>{
    var child_id:String
    var user_id:String
    var name:String
    var dob:String
    var gender:String
    var image:String
    var created_at:String
    var update_at:String
    var actual_dob:String
    var appointmentDetailsDict:AppointmentCDetailsDict<T>
    init?(dataDict:[String:T]) {
   
        let child_id = dataDict["child_id"] as? String ?? ""
        let user_id = dataDict["user_id"] as? String ?? ""
        let name = dataDict["name"] as? String ?? ""
        let dob = dataDict["dob"] as? String ?? ""
        let gender = dataDict["gender"] as? String ?? ""
        let image = dataDict["image"] as? String ?? ""
        let created_at = dataDict["created_at"] as? String ?? ""
        let update_at = dataDict["update_at"] as? String ?? ""
        let actual_dob = dataDict["actual_dob"] as? String ?? ""

        let appointmentDetailsDict = dataDict["appointmentDetails"] as? [String :T] ?? [:]

       
      
        self.child_id = child_id
        self.user_id = user_id
        self.name = name
        self.dob = dob
        self.gender = gender
        self.image = image
        self.created_at = created_at
        self.update_at = update_at
        self.actual_dob = actual_dob
        self.appointmentDetailsDict = AppointmentCDetailsDict(dataDict:appointmentDetailsDict)!
    }

}
struct AppointmentCDetailsDict<T>{

    var id:String
    var user_id:String
    var child_id:String
    var title:String
    var appointment_date:String
    var appointment_time_to:String
    var appointment_time_from:String
    var description:String
    var status:String
    var create_date:String
    init?(dataDict:[String:T]) {
        let id = dataDict["id"] as? String ?? ""
        let user_id = dataDict["user_id"] as? String ?? ""
        let child_id = dataDict["child_id"] as? String ?? ""
        let title = dataDict["title"] as? String ?? ""
        let appointment_date = dataDict["appointment_date"] as? String ?? ""
        let appointment_time_to = dataDict["appointment_time_to"] as? String ?? ""
        let appointment_time_from = dataDict["appointment_time_from"] as? String ?? ""
        let status = dataDict["status"] as? String ?? ""
        let create_date = dataDict["create_date"] as? String ?? ""
        let description = dataDict["description"] as? String ?? ""

        
        self.id = id
        self.user_id = user_id
        self.child_id = child_id
        self.title = title
        self.appointment_date = appointment_date
        self.appointment_time_to = appointment_time_to
        self.appointment_time_from = appointment_time_from
        self.status = status
        self.create_date = create_date
        self.description = description

    }

}
