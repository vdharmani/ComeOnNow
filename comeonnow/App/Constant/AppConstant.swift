//
//  AppConstant.swift
//  ChanceUpon
//
//  Created by Dharmani Apps mini on 11/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

import UIKit

let DeviceSize = UIScreen.main.bounds.size
//@available(iOS 13.0, *)
let appDel = (UIApplication.shared.delegate as! AppDelegate)
@available(iOS 13.0, *)
let appScene = (UIApplication.shared.delegate as! SceneDelegate)



struct WSMethods {
    static let signIn = "logIn.php"
    static let signUp = "signUpv2.php"
    static let addchildren = "addchildrenv2.php"
    static let editChild = "editChildv2.php"
    static let getChildrenDetails = "getChildrenDetails.php"
    static let getProfileDetails = "getProfileDetails.php"
    static let changePassword = "changePassword.php"
    static let resentVerficationEmail = "ResentVerficationEmail.php"

    static let notificationDetails = "notificationDetailsv2.php"
    static let getAppointmentDetails = "GetAppointmentDetails.php"
    static let approveRejectAppointment = "approveRejectAppointment.php"
    static let childDelete = "childDelete.php"
    
    static let logOut = "logOut.php"
    static let getUserDetail = "getProfileDetails.php"
    static let editProfile = "editProfilev2.php"
    static let forgotPassword = "forgetPassword.php"
    static let  getChildrenDetailsBychildId = "getChildrenDetailsBychildIdv2.php"
}

//MARK: V2 LIVE BASE URL
// https://www.comeonnow.io/v2/webservice/
//MARK: LIVE BASE URL
// https://comeonnow.io/webservice/
//MARK: STAGING BASE URL
// https://www.dharmani.com/ComeOnNow/webservice/

let kBASEURL = "https://www.comeonnow.io/v2/webservice/"

struct SettingWebLinks {
    static let privacyPolicy = "PrivacyAndPolicy.html"
    static let aboutUs = "about.html"
    static let termsAndConditions = "terms&services.html"
}
struct NavBarTitle {
    static let privacyPolicy = "Privacy Policy"
    static let aboutUs = "About"
    static let termsAndConditions = "Terms and condition"
}

struct ViewControllerIdentifier {
    static let SignUpVC = "SignUpVC"
    static let HomeTabVC = "HomeTabVC"
    static let LogInVC = "LogInVC"
    static let ForgotPasswordVC = "ForgotPasswordVC"
    static let ViewController = "ViewController"
    static let DailyInventoryListVC = "DailyInventoryListVC"
    static let BiweeklyInventoryListVC = "BiweeklyInventoryListVC"
    static let BuildOrderListVC = "BuildOrderListVC"
    static let BuildOrderDetailVC = "BuildOrderDetailVC"
    static let AddBuildOrderVC = "AddBuildOrderVC"
    static let NotificationVC = "NotificationVC"

    
    
    
    static let EditProfileVC = "EditProfileVC"
    static let ProfileChildTabVC = "ProfileChildTabVC"
    static let DailyInventoryDetailVC = "DailyInventoryDetailVC"
    static let BiweeklyInventoryDetailVC = "BiweeklyInventoryDetailVC"
    static let AddBiweeklyInventoryVC = "AddBiweeklyInventoryVC"
    static let AddDailyInventoryVC = "AddDailyInventoryVC"
    static let LinksWebVC = "LinksWebVC"
    static let ChildDetailVC = "ChildDetailVC"
    static let ProductListVC = "ProductListVC"
    static let AddProductVC = "AddProductVC"
    static let IngredientListVC = "IngredientListVC"
    static let AddIngredientVC = "AddIngredientVC"
    static let AddIngredientForkastVC = "AddIngredientForkastVC"
    static let ProductMappingVC = "ProductMappingVC"
    static let PopUpListVC = "PopUpListVC"

    
}
struct StoryboardName {
    static let Main = "Main"
    static let Setting = "Setting"
    static let BiweekelyInventory = "BiweekelyInventory"
    static let ProductIngredients = "ProductIngredients"
    static let BuildOrder = "BuildOrder"

}


