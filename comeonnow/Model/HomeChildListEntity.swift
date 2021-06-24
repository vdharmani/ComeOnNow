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
struct ChildListData<T>{
    var child_id:String
    var user_id:String
    var name:String
    var dob:String
    var gender:String
    var image:String
    var created_at:String
    init?(dataDict:[String:T]) {
   
        let child_id = dataDict["child_id"] as? String ?? ""
        let user_id = dataDict["user_id"] as? String ?? ""
        let name = dataDict["name"] as? String ?? ""
        let dob = dataDict["dob"] as? String ?? ""
        let gender = dataDict["gender"] as? String ?? ""
        let image = dataDict["image"] as? String ?? ""
        let created_at = dataDict["created_at"] as? String ?? ""

       
      
        self.child_id = child_id
        self.user_id = user_id
        self.name = name
        self.dob = dob
        self.gender = gender
        self.image = image
        self.created_at = created_at
    }

}
