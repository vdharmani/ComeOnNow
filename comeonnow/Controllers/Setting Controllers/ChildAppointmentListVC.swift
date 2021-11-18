//
//  ChildAppointmentListVC.swift
//  comeonnow
//
//  Created by Apple on 02/09/21.
//

import UIKit

class ChildAppointmentListVC: UIViewController {
    var appointmentDetailArr = [AppointmentCDetailsDict<Any>]()
    var childDetailsData = ChildDetailData<Any>(dict: [:])

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
     
          
        let finalAppointmentTime = appointmentDetailArr[indexPath.row].appointment_time == "N/A" ? appointmentDetailArr[indexPath.row].appointment_time_to : appointmentDetailArr[indexPath.row].appointment_time
        cell.timeLbl.text = "\(finalAppointmentTime) (\(appointmentDetailArr[indexPath.row].duration) min)"
            cell.dateLbl.text = appointmentDetailArr[indexPath.row].appointment_date
            cell.appointmentTypeLbl.text = appointmentDetailArr[indexPath.row].appointments_type
            cell.appointmentTitleLbl.text  = appointmentDetailArr[indexPath.row].title
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UIScreen.main.bounds.size.height * 0.11
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChildDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.first_name = childDetailsData?.first_name
        vc.last_name = childDetailsData?.last_name
        vc.dob = childDetailsData?.actual_dob
        vc.gender = childDetailsData?.gender
        vc.image = childDetailsData?.image
        vc.isFromAppointment = true
        vc.desc = appointmentDetailArr[indexPath.row].description
        vc.appointment_time_to = appointmentDetailArr[indexPath.row].appointment_time_to
        vc.appointment_time = appointmentDetailArr[indexPath.row].appointment_time
        vc.duration = appointmentDetailArr[indexPath.row].duration
        vc.appointment_time_from = appointmentDetailArr[indexPath.row].appointment_time_from
        vc.appointment_date = appointmentDetailArr[indexPath.row].appointment_date
        vc.appointmentType = appointmentDetailArr[indexPath.row].appointments_type

//        vc.delegate = self
//            vc.appointmentDetailsDict = appointmentArray[indexPath.row].appointmentDetailsDict
        
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
