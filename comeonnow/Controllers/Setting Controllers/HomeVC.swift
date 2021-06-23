//
//  HomeVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 22/06/21.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    var HomeArray = [HomeData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        homeTableView.delegate = self

        homeTableView.register(UINib(nibName: "HomeTVC", bundle: nil), forCellReuseIdentifier: "HomeTVC")
        
        self.HomeArray.append(HomeData(image: "baby1", name: "Jose Montero", age: "3 years 10 month", gender: "Girl"))
        self.HomeArray.append(HomeData(image: "baby2", name: "Eischens", age: "5 years 8 month", gender: "Boy"))
        self.HomeArray.append(HomeData(image: "baby3", name: "Alexander", age: "4 years 5 month", gender: "Girl"))
        self.HomeArray.append(HomeData(image: "baby4", name: "Allen", age: "2 years 9 month", gender: "Boy"))
        self.HomeArray.append(HomeData(image: "baby5", name: "Allen", age: "2 years 9 month", gender: "Boy"))
        
        
    }
   
    @IBAction func addChildBtnAction(_ sender: Any) {
        let vc = AddChildVC.instantiate(fromAppStoryboard: .Setting)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension HomeVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTVC", for: indexPath) as! HomeTVC
        cell.mainImage.image = UIImage(named: HomeArray[indexPath.row].image)
        cell.nameLabel.text = HomeArray[indexPath.row].name
        cell.ageLabel.text = HomeArray[indexPath.row].age
        cell.genderLabel.text = HomeArray[indexPath.row].gender
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
        
    }
    
    
}
struct HomeData {
    var image : String
    var name : String
    var age : String
    var gender : String
    init(image : String, name : String , age : String, gender : String) {
        self.image = image
        self.name = name
        self.age = age
        self.gender = gender
    }
}
