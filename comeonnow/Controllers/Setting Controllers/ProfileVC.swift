//
//  ProfileVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 23/06/21.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    var ProfileArray = [ProfileData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.setRounded()
        profileTableView.dataSource = self
        profileTableView.delegate = self
        profileTableView.register(UINib(nibName: "ProfileTVC", bundle: nil), forCellReuseIdentifier: "ProfileTVC")
        
        self.ProfileArray.append(ProfileData(image: "", name: "Change Password"))
        self.ProfileArray.append(ProfileData(image: "", name: "About"))
        self.ProfileArray.append(ProfileData(image: "", name: "Privacy Policy"))
        self.ProfileArray.append(ProfileData(image: "", name: "Terms"))
        self.ProfileArray.append(ProfileData(image: "", name: "Logout"))
    }
    

    @IBAction func editButton(_ sender: Any) {
    }
    

    @IBAction func profileButton(_ sender: Any) {
    }
}
extension ProfileVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVC", for: indexPath) as! ProfileTVC
        cell.mainImg.image = UIImage(named: ProfileArray[indexPath.row].image)
        cell.detailLabel.text = ProfileArray[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  50
    }
    
    
}
struct ProfileData {
    var image : String
    var name : String
  
    init(image : String, name : String) {
        self.image = image
        self.name = name
       
    }
}
