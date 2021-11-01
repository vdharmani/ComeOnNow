//
//  HomeChildListEntity.swift
//  comeonnow
//
//  Created by Arshdeep Singh on 24/06/21.
//

import Foundation

//{
//    "status": 1,
//    "message": "child details",
//    "data": [
//        {
//            "child_id": "19",
//            "user_id": "16",
//            "name": "kumud",
//            "dob": "1 days old!",
//            "gender": "male",
//            "c": "",
//            "created_at": "1624513104"
//        }
//
//    ]
//}
struct HomeChildListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var homeArray:[ChildListData<T>]
   

    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let  dataArr = dict["data"] as? [[String:T]] ?? [[:]]
     
        self.status = status
        self.message = alertMessage
        var hArray = [ChildListData<T>]()
        for obj in dataArr{
            let childListObj = ChildListData(dataDict:obj)!
            hArray.append(childListObj)
        }
        self.homeArray = hArray
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
struct ChildListData<T>{
    var child_id:String
    var user_id:String
    var name:String
    var first_name:String
    var last_name:String

    var dob:String
    var gender:String
    var image:String
    var created_at:String
    var update_at:String
    var actual_dob:String
    
    var appointmentDetailsDict:AppointmentDetailsDict<T>
    init?(dataDict:[String:T]) {
   
        let child_id = dataDict["child_id"] as? String ?? ""
        let user_id = dataDict["user_id"] as? String ?? ""
        let name = dataDict["name"] as? String ?? ""
        let first_name = dataDict["first_name"] as? String ?? ""
        let last_name = dataDict["last_name"] as? String ?? ""

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
        self.first_name = first_name
        self.last_name = last_name

        self.dob = dob
        self.gender = gender
        self.image = image
        self.created_at = created_at
        self.update_at = update_at
        self.actual_dob = actual_dob

        self.appointmentDetailsDict = AppointmentDetailsDict(dataDict:appointmentDetailsDict)!
    }

}
struct AppointmentDetailsDict<T>{

    var id:String
    var user_id:String
    var child_id:String
    var title:String
    var appointment_date:String
    var appointment_time_to:String
    var appointment_time_from:String
    var status:String
    var create_date:String
    var description:String

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
