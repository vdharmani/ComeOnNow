//
//  EditProfileVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 24/06/21.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var bioView: UIView!
    
    @IBOutlet weak var bioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func uploadButton(_ sender: Any) {
    }
    @IBAction func saveButton(_ sender: Any) {
    }
}
