//
//  AppAlert.swift
//  BumpAppReplica
//
//  Created by Dharmesh Avaiya on 21/01/20..
//  Copyright © 2018 iOSDeveloper. All rights reserved.
//

import Foundation
import UIKit

enum AppAlertTitle : String {
    case appName = "Chance Upon"
    case connectionError = "Connection Error"
    
}

struct AppHomeTabAlertMessage {
    static let userLocationError = "Error getting the users location"
    static let appleLoginSupport = "Apple login support in iOS 13 and above"
}



struct AppSignInForgotSignUpAlertNessage {
    static let enterEmail = "Please enter email"
    static let validEmail = "Please enter valid email"
    static let enterPassword = "Please enter password"
    static let enterConfirmPassword = "Please enter confirm password"
    static let passwordNotMatched = "Password doesn’t match"
    static let enterDOB = "Please enter D.O.B"
    static let enterName = "Please enter name"
    static let selectInterestedGender = "Please select interested gender"
    static let selectGender = "Please select gender"
    static let selectCategory = "Please select category"
    static let enterText = "Please enter text"
    static let maxLimitInterest = "You can add maximum 5 interest"
    static let addInterest = "Please add an interest"
    static let enterOccupation = "Please enter occupation"
}

struct AppCameraPicAlertMessage{
    static let camera = "Camera"
    static let gallery = "Gallery"
    static let cancel = "Cancel"
    static let uploadImage = "Please upload an image"
    static let noCamera = "Device has no camera"
}
struct AppInterestAlertMessage {
    static let addInterestValidation = "Please add atleast 1 interest"

}



struct Alert {
    static func present(title: String?, message: String, actions: Alert.Action..., from controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action.alertAction)
        }
        controller.present(alertController, animated: true, completion: nil)
    }
}
extension Alert {
    enum Action {
        case ok(handler: (() -> Void)?)
        case retry(handler: (() -> Void)?)
        case close

        // Returns the title of our action button
        private var title: String {
            switch self {
            case .ok:
                return "OK"
            case .retry:
                return "Retry"
            case .close:
                return "Close"
            }
        }

        // Returns the completion handler of our button
        private var handler: (() -> Void)? {
            switch self {
            case .ok(let handler):
                return handler
            case .retry(let handler):
                return handler
            case .close:
                return nil
            }
        }

        var alertAction: UIAlertAction {
            return UIAlertAction(title: title, style: .default, handler: { _ in
                if let handler = self.handler {
                    handler()
                }
            })
        }
    }
}
