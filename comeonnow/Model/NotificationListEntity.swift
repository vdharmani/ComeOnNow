//
//  NotificationListEntity.swift
//  comeonnow
//
//  Created by Apple on 28/06/21.
//

import Foundation

//{
//    "status": 1,
//    "message": "Notification details",
//    "data": [
//        {
//            "notification_id": "2",
//            "title": "Hello you have an appointment schedule.",
//            "description": "Appointment is scheduled for 30th june,21.",
//            "notification_type": "3",
//            "user_id": "16",
//            "detail_id": "1",
//            "notification_read_status": "0",
//            "created": "1624877778",
//            "image": "https://www.dharmani.com/ComeOnNow/webservice/childrenImg/60d5b63ca4d5b.png",
//            "details": {
//                "id": "1",
//                "user_id": "16",
//                "child_id": "50",
//                "title": "Vaccine against Hepatitis B",
//                "appointment_date": "2021-06-30",
//                "appointment_time_to": "10:00 AM",
//                "appointment_time_from": "11:00 AM",
//                "status": "0",
//                "create_date": "1624877778"
//            }
//        },
//        {
//            "notification_id": "1",
//            "title": "Hello you have an appointment.",
//            "description": "Your appointment is schedule for 30th june,21.",
//            "notification_type": "2",
//            "user_id": "16",
//            "detail_id": "1",
//            "notification_read_status": "0",
//            "created": "1624877778",
//            "image": "https://www.dharmani.com/ComeOnNow/webservice/childrenImg/60d5b63ca4d5b.png",
//            "details": {
//                "id": "1",
//                "user_id": "16",
//                "child_id": "50",
//                "title": "Vaccine against Hepatitis B",
//                "appointment_date": "2021-06-30",
//                "appointment_time_to": "10:00 AM",
//                "appointment_time_from": "11:00 AM",
//                "status": "0",
//                "create_date": "1624877778"
//            }
//        }
//    ]
//}





struct NotificationsListData<T>{
  
  
    //{
    //    "status": 1,
    //    "message": "New password has been sent to the entered email, please check your email."
    //}
    var status: Int
    var message: String
    var notificationArray:[NotificationListData<T>]
   

    init?(dict:[String:T]) {
        let status  = dict["status"] as? Int ?? 0
        let alertMessage = dict["message"] as? String ?? ""
        let  dataArr = dict["data"] as? [[String:T]] ?? [[:]]
     
        self.status = status
        self.message = alertMessage
        var hArray = [NotificationListData<T>]()
        for obj in dataArr{
            let notifyListObj = NotificationListData(dataDict:obj)!
            hArray.append(notifyListObj)
        }
        self.notificationArray = hArray
    }
}
struct NotificationListData<T>{
    var notification_id:String
    var title:String
    var description:String
    var notification_type:String
    var user_id:String
    var detail_id:String
    var notification_read_status:String
    var created:String
    var image:String
    var document:String
    var detailDicts: NotificationDetailDict<T>
    init?(dataDict:[String:T]) {
   
        let notification_id = dataDict["notification_id"] as? String ?? ""
        let title = dataDict["title"] as? String ?? ""
        let description = dataDict["description"] as? String ?? ""
        let notification_type = dataDict["notification_type"] as? String ?? ""
        let user_id = dataDict["user_id"] as? String ?? ""
        let detail_id = dataDict["detail_id"] as? String ?? ""
        let notification_read_status = dataDict["notification_read_status"] as? String ?? ""
        let created = dataDict["created"] as? String ?? ""
        let image = dataDict["image"] as? String ?? ""
        let document = dataDict["document"] as? String ?? ""

        let detailsDict = dataDict["details"] as? [String:T] ?? [:]

       
      
        self.notification_id = notification_id
        self.title = title
        self.description = description
        self.notification_type = notification_type
        self.user_id = user_id
        self.detail_id = detail_id
        self.notification_read_status = notification_read_status
        self.created = created
        self.image = image
        self.document = document
        self.detailDicts =  NotificationDetailDict(dataDict:detailsDict)!
    }

}
struct NotificationDetailDict<T>{

    var id:String
    var user_id:String
    var child_id:String
    var title:String
    var appointment_date:String
    var appointment_time_to:String
    var appointment_time_from:String
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

        
        self.id = id
        self.user_id = user_id
        self.child_id = child_id
        self.title = title
        self.appointment_date = appointment_date
        self.appointment_time_to = appointment_time_to
        self.appointment_time_from = appointment_time_from
        self.status = status
        self.create_date = create_date

    }

}
