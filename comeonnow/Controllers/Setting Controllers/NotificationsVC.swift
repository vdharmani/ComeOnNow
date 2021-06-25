//
//  NotificationsVC.swift
//  comeonnow
//
//  Created by Vivek Dharmani on 24/06/21.
//

import UIKit

class NotificationsVC: UIViewController {

    @IBOutlet weak var notificationsTableView: UITableView!
    var NotificationsArray = [NotificationsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self

        notificationsTableView.register(UINib(nibName: "NotificationsTVC", bundle: nil), forCellReuseIdentifier: "NotificationsTVC")
        self.NotificationsArray.append(NotificationsData(image: "baby1", days: "3 days ago", hideDays: "" , selected: true))
        self.NotificationsArray.append(NotificationsData(image: "baby2", days: "", hideDays: "2 days ago",selected: false))
        self.NotificationsArray.append(NotificationsData(image: "baby1", days: "3 mins ago", hideDays: "",selected: true))
    }
    
}
extension NotificationsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTVC", for: indexPath) as! NotificationsTVC
        cell.mainImage.image = UIImage(named: NotificationsArray[indexPath.row].image)
        cell.daysLabel.text = NotificationsArray[indexPath.row].days
        cell.daysHIdeLabel.text = NotificationsArray[indexPath.row].hideDays
        if indexPath.row == 0{
            cell.stackView.isHidden = false
            cell.acceptView.backgroundColor = #colorLiteral(red: 0.5227575898, green: 0.1487583816, blue: 0.471519649, alpha: 1)
            cell.acceptLabel.textColor = #colorLiteral(red: 0.9612370133, green: 0.9368476272, blue: 0.9572705626, alpha: 1)
            cell.declineView.backgroundColor = #colorLiteral(red: 0.8899325728, green: 0.8938195705, blue: 0.9144564271, alpha: 1)
            cell.declineLabel.textColor = #colorLiteral(red: 0.03136481717, green: 0.03137699887, blue: 0.03136405349, alpha: 1)
            cell.daysHIdeLabel.isHidden = true
        }else if indexPath.row == 1 {
            cell.stackView.isHidden = true
            cell.daysHIdeLabel.isHidden = false
            cell.daysLabel.isHidden = true
        }else if  indexPath.row == 2 {
            cell.stackView.isHidden = false
            cell.acceptView.backgroundColor = #colorLiteral(red: 0.8899325728, green: 0.8938195705, blue: 0.9144564271, alpha: 1)
            cell.acceptLabel.textColor = #colorLiteral(red: 0.03136481717, green: 0.03137699887, blue: 0.03136405349, alpha: 1)
            cell.declineView.backgroundColor = #colorLiteral(red: 0.5227575898, green: 0.1487583816, blue: 0.471519649, alpha: 1)
            cell.declineLabel.textColor = #colorLiteral(red: 0.9612370133, green: 0.9368476272, blue: 0.9572705626, alpha: 1)
            cell.daysHIdeLabel.isHidden = true
            
        }else {}
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
   
  
    
}
struct NotificationsData {
    var image : String
    var days : String
    var hideDays : String
    var selected : Bool
    init(image : String , days : String, hideDays : String, selected : Bool) {
        self.image = image
        self.days = days
        self.hideDays = hideDays
        self.selected = selected
    }
}
