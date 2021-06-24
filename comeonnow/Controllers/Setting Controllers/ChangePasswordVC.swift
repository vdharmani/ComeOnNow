//
//  ChangePasswordVC.swift
//  comeonnow
//
//  Created by Arshdeep Singh on 24/06/21.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var currentPasswordView: UIView!
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewView: UIView!
    @IBOutlet weak var confirmNewTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButton(_ sender: Any) {
    }
}
