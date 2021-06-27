//
//  AppDelegate.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 21/06/21.
//

import UIKit
import IQKeyboardManagerSwift



func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//vddvd
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        sleep(1)
        window = UIWindow(frame: UIScreen.main.bounds)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2668271065, green: 0.2587364316, blue: 0.2627768517, alpha: 1)  ], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5227575898, green: 0.1487583816, blue: 0.471519649, alpha: 1) ], for: .selected)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window = self.window
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        if authToken != ""{
           
                appDelegate?.loginToHomePage()
                
            
        }else{
            appDelegate?.logOut()
        }
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
        // Override point for customization after application launch.
        return true
    }
    func logOut(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: StoryboardName.Main, bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: ViewControllerIdentifier.LogInVC) as! LogInVC
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    func loginToHomePage(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Setting", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier:"TabBarVC") as! TabBarVC
        homeViewController.selectedIndex = 0
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        setAppDefaults(deviceTokenString, key: "DeviceToken")
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
   
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene sessiif #available(iOS 13.0, *) {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
            
    }

@available(iOS 13.0, *)
func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be ca@available(iOS 13.0, *)
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
