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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//vddvd
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        sleep(1)
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 133.0/255.0, green: 38.0/255.0, blue:120.0/255.0, alpha: 1.0)], for: .selected)

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window = self.window
        let authToken  = getSAppDefault(key: "AuthToken") as? String ?? ""
        if authToken != ""{
           
                appDelegate?.loginToHomePage()
                
            
        }else{
            appDelegate?.logOut()
        }
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        if launchOptions != nil
        {
            // opened from a push notification when the app is closed
            let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any]
            if (userInfo != nil){
                if let apnsData = userInfo?["aps"] as? [String:Any]{
                    if let dataObj = apnsData["data"] as? [String:Any]{
                        let notificationType = dataObj["notification_type"] as? String
                        let state = UIApplication.shared.applicationState
                        if state != .active{

                            if notificationType == "1"{
                                let storyBoard = UIStoryboard.init(name:StoryboardName.Setting, bundle: nil)
                                let rootVc = storyBoard.instantiateViewController(withIdentifier:"TabBarVC") as! TabBarVC
                                rootVc.selectedIndex = 0


                                let nav =  UINavigationController(rootViewController: rootVc)
                                nav.isNavigationBarHidden = true
                                if #available(iOS 13.0, *){
                                    if let scene = UIApplication.shared.connectedScenes.first{
                                         let windowScene = (scene as? UIWindowScene)
                                        print(">>> windowScene: \(windowScene)")
                                        let window: UIWindow = UIWindow(frame: (windowScene?.coordinateSpace.bounds)!)
                                        window.windowScene = windowScene //Make sure to do this
                                        window.rootViewController = nav
                                        window.makeKeyAndVisible()
                                        self.window = window
                                    }
                                } else {
                                    self.window?.rootViewController = nav
                                    self.window?.makeKeyAndVisible()
                                }
                            }

                          else {
                                let storyBoard = UIStoryboard.init(name:StoryboardName.Setting, bundle: nil)
                                let rootVc = storyBoard.instantiateViewController(withIdentifier:"TabBarVC") as! TabBarVC
                                rootVc.selectedIndex = 2


                                let nav =  UINavigationController(rootViewController: rootVc)
                                nav.isNavigationBarHidden = true
                                if #available(iOS 13.0, *){
                                    if let scene = UIApplication.shared.connectedScenes.first{
                                         let windowScene = (scene as? UIWindowScene)
                                        print(">>> windowScene: \(windowScene)")
                                        let window: UIWindow = UIWindow(frame: (windowScene?.coordinateSpace.bounds)!)
                                        window.windowScene = windowScene //Make sure to do this
                                        window.rootViewController = nav
                                        window.makeKeyAndVisible()
                                        self.window = window
                                    }
                                } else {
                                    self.window?.rootViewController = nav
                                    self.window?.makeKeyAndVisible()
                                }
                           }
                            
                        }
                    }
                }
            }
//            if([[userInfo objectForKey:@"aps"] objectForKey:@"badge"])
//            {
//                [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badge"] intValue];
//            }
        }
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
        print("device token is \(deviceTokenString)")
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
@available(iOS 12.0, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    let notificationType = dataObj["notification_type"] as? String
                    let state = UIApplication.shared.applicationState
                }
            }
        }
        
        
        
        
        // Print full message.
        //        print("user info is \(userInfo)")
        
        // Change this to your preferred presentation option
        // completionHandler([])
        //Show Push notification in foreground
//        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String:Any]{
            print(userInfo)
            if let apnsData = userInfo["aps"] as? [String:Any]{
                if let dataObj = apnsData["data"] as? [String:Any]{
                    let notificationType = dataObj["notification_type"] as? String
                    let state = UIApplication.shared.applicationState
                    if state != .active{

                        if notificationType == "1"{
                            let storyBoard = UIStoryboard.init(name:StoryboardName.Setting, bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier:"TabBarVC") as! TabBarVC
                            rootVc.selectedIndex = 0


                            let nav =  UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                        }

                        else {
                            let storyBoard = UIStoryboard.init(name:StoryboardName.Setting, bundle: nil)
                            let rootVc = storyBoard.instantiateViewController(withIdentifier:"TabBarVC") as! TabBarVC
                            rootVc.selectedIndex = 2


                            let nav =  UINavigationController(rootViewController: rootVc)
                            nav.isNavigationBarHidden = true
                            if #available(iOS 13.0, *){
                                if let scene = UIApplication.shared.connectedScenes.first{
                                    guard let windowScene = (scene as? UIWindowScene) else { return }
                                    print(">>> windowScene: \(windowScene)")
                                    let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                                    window.windowScene = windowScene //Make sure to do this
                                    window.rootViewController = nav
                                    window.makeKeyAndVisible()
                                    self.window = window
                                }
                            } else {
                                self.window?.rootViewController = nav
                                self.window?.makeKeyAndVisible()
                            }
                       }
                    }
                }
            }
        }
        completionHandler()
    }
    
    func convertStringToDictionary(json: String) -> [String: AnyObject]? {
        if let data = json.data(using: String.Encoding.utf8) {
            let json = try? JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [String: AnyObject]
            //            if let error = error {
            //            print(error!)
            //}
            return json!
        }
        return nil
    }
    
}
