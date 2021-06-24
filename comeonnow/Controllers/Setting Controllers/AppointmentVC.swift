//
//  AppointmentVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 23/06/21.
//

import UIKit

class AppointmentVC: UIViewController {

    @IBOutlet weak var appointmentTableView: UITableView!
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var allDownLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var confirmedDownLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var pendingDownLabel: UILabel!
    var AppointArray = [AppointmentData] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentTableView.dataSource = self
        appointmentTableView.delegate = self

        appointmentTableView.register(UINib(nibName: "AppointmentTVC", bundle: nil), forCellReuseIdentifier: "AppointmentTVC")
        
        self.AppointArray.append(AppointmentData(image: "baby1", name: "Jose Montero", age: "3 years 10 month", gender: "Girl",date: "28,Jan 2019" ,time: "10:00 AM - 10:30AM (30 min))"))
        self.AppointArray.append(AppointmentData(image: "baby2", name: "Eischens", age: "5 years 8 month", gender: "Boy",date: "12,Jan 2019",time: "11:00 AM - 11:30AM (30 min)"))
        self.AppointArray.append(AppointmentData(image: "baby3", name: "Alexander", age: "4 years 5 month", gender: "Girl",date: "28,Jan 2019",time: "10:00 AM - 10:30AM (30 min)"))
       
       
    }
    
    @IBAction func allButton(_ sender: Any) {
    }
    
    @IBAction func confirmedButton(_ sender: Any) {
    }
    
    @IBAction func pendingButton(_ sender: Any) {
    }
}
extension AppointmentVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppointArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentTVC", for: indexPath) as! AppointmentTVC
        cell.mainImage.image = UIImage(named: AppointArray[indexPath.row].image)
        cell.nameLabel.text = AppointArray[indexPath.row].name
        cell.ageLabel.text = AppointArray[indexPath.row].age
        cell.genderLabel.text = AppointArray[indexPath.row].gender
        cell.dateLabel.text = AppointArray[indexPath.row].date
        cell.timeLabel.text = AppointArray[indexPath.row].time
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
struct AppointmentData {
    var image : String
    var name : String
    var age : String
    var gender : String
    var date : String
    var time : String
    init(image : String, name : String , age : String, gender : String , date : String , time : String) {
        self.image = image
        self.name = name
        self.age = age
        self.gender = gender
        self.date = date
        self.time = time
    }
}
