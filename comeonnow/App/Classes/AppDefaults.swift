//
//  AppDefaults.swift
//  BumpAppReplica
//
//  Created by Dharmesh Avaiya on 21/01/20..
//  Copyright © 2018 iOSDeveloper. All rights reserved.
//

import Foundation
import UIKit

struct AppDefaults {
    static let selectedSecurityQues = "selectedSecurityQues"
    static let requestFromKnowMore = "requestFromKnowMore"
    static let isUserLoggedIn = "isUserLoggedIn"
}

func setAppDefaults<T>(_ value:T,key: String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func getAppDefaults<T>(key:String) -> T? {
    guard let value = UserDefaults.standard.value(forKey: key) as? T else {
        return nil
    }
    return value
}
func getSAppDefault(key:String) -> Any{
    let value = UserDefaults.standard.value(forKey: key)
    return value as Any
}
func removeAppDefaults(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

let MAppName : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "comeonnow"
let IDefaults = UserDefaults.standard

class colorsApp:NSObject{
    static let appColor = colorsApp()
    let appcolor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    let whiteColor = UIColor.white
    let appButtonColor = #colorLiteral(red: 0.6742971539, green: 0.5286002755, blue: 0.1826787293, alpha: 1)
    let blackColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

func AppDel() -> AppDelegate{
    return UIApplication.shared.delegate as! AppDelegate
}

func window() -> UIWindow{
    return AppDel().window!
}

func userId()->String{
    return IDefaults.string(forKey: "id") ?? ""
}

extension String{
    var trimWhiteSpace: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIViewController{
    func saveDefaults(userId:String,authToken:String,userName:String){
        IDefaults.set(userId, forKey: "UserId")
        IDefaults.set(authToken, forKey: "AuthToken")
        IDefaults.set(userName, forKey: "UserName")

        IDefaults.synchronize()
    }
    func retrieveDefaults()->(String,String,String){
        let userId = IDefaults.string(forKey: "UserId") ?? ""
        let authToken = IDefaults.string(forKey: "AuthToken") ?? ""
        let userName = IDefaults.string(forKey: "UserName") ?? ""

        return (userId,authToken,userName)
    }
    func removeDefaults(){
        IDefaults.removeObject(forKey: "UserId")
        IDefaults.removeObject(forKey: "AuthToken")
        IDefaults.removeObject(forKey: "UserName")

    }
}
