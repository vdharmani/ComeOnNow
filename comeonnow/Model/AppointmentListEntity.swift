//
//  AppointmentListEntity.swift
//  comeonnow
//
//  Created by Apple on 29/06/21.
//

import Foundation

struct AppointmentListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var appointmentArray:[AppointmentsListData<T>]
   

    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let  dataArr = dict["data"] as? [[String:T]] ?? [[:]]
     
        self.status = status
        self.message = alertMessage
        var hArray = [AppointmentsListData<T>]()
        for obj in dataArr{
            let notifyListObj = AppointmentsListData(dataDict:obj)!
            hArray.append(notifyListObj)
        }
        self.appointmentArray = hArray
    }
}
struct AppointmentsListData<T>{
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

    var childDetailsDict: ChildDetailDict<T>
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

        let detailsDict = dataDict["childDetails"] as? [String:T] ?? [:]

       
      
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
        self.childDetailsDict =  ChildDetailDict(dataDict:detailsDict)!
    }

}


struct ChildDetailDict<T>{

    var user_id:String
    var child_id:String
    var name:String
    var dob:String
    var gender:String
    var image:String
    var created_at:String
    init?(dataDict:[String:T]) {
        let user_id = dataDict["user_id"] as? String ?? ""
        let child_id = dataDict["child_id"] as? String ?? ""
        let name = dataDict["name"] as? String ?? ""
        let dob = dataDict["dob"] as? String ?? ""
        let gender = dataDict["gender"] as? String ?? ""
        let image = dataDict["image"] as? String ?? ""
        let created_at = dataDict["created_at"] as? String ?? ""

        
        self.user_id = user_id
        self.child_id = child_id
        self.name = name
        self.dob = dob
        self.gender = gender
        self.image = image
        self.created_at = created_at

    }

}
