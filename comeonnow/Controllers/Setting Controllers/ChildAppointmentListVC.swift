//
//  ChildAppointmentListVC.swift
//  comeonnow
//
//  Created by Apple on 02/09/21.
//

import UIKit

class ChildAppointmentListVC: UIViewController {
    var appointmentDetailArr = [AppointmentCDetailsDict<Any>]()
    @IBOutlet weak var appointmentChildTBView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        appointmentChildTBView.reloadData()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
extension ChildAppointmentListVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentDetailArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AppointmentChildDetailTBCell
        cell.dateLbl.text = appointmentDetailArr[indexPath.row].appointment_date
        let time1 = appointmentDetailArr[indexPath.row].appointment_time_to
        let time2 = appointmentDetailArr[indexPath.row].appointment_time_from
        if time1 != "" && time2 != ""{
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mma"
            
            let date1 = formatter.date(from: time1)!
            let date2 = formatter.date(from: time2)!
            
            let elapsedTime = date2.timeIntervalSince(date1)
            
            // convert from seconds to hours, rounding down to the nearest hour
            let hours = floor(elapsedTime / 60 / 60)
            
            // we have to subtract the number of seconds in hours from minutes to get
            // the remaining minutes, rounding down to the nearest minute (in case you
            // want to get seconds down the road)
            let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
            
            print("\(Int(hours)) hr and \(Int(minutes)) min")
            let hourMin = (hours != 0 ? "\(hours) hr" : "\(minutes) min")
            cell.timeLbl.text = "\(appointmentDetailArr[indexPath.row].appointment_time_to) - \(appointmentDetailArr[indexPath.row].appointment_time_from)"

        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.size.height * 0.11
//        return UITableView.automaticDimension
        
    }
    
}
