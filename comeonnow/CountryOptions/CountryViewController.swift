//
//  CountryViewController.swift
//  TamimiEcom
//
//  Created by Ansh on 16/09/20.
//  Copyright © 2020  ltd. All rights reserved.
//

import UIKit
protocol CountrySelection : AnyObject {
    func selectedCountryInformation(dict:NSDictionary)
}
class CountryViewController: UIViewController {
    weak var  delagate:CountrySelection?
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tbView: UITableView!
    
    var  countyArray : NSArray = [] ;
    var  filteredUserData: NSArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPlacehoder()
        NotificationCenter.default.addObserver(self, selector: #selector(CountryViewController.keyboardWasShown(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CountryViewController.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        tbView.estimatedRowHeight = 50
        tbView.keyboardDismissMode = .onDrag
        
        txtSearch.delegate = self
        let nibhView = UINib(nibName: "CountryTableViewCell", bundle: nil)
        self.tbView.register(nibhView, forCellReuseIdentifier: "CountryTableViewCell")
        self.tbView.delegate = self
        self.tbView.dataSource = self
        self.txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.readJshonFile()
        // Do any additional setup after loading the view.
    }
    func setPlacehoder() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7),
            NSAttributedString.Key.font : UIFont(name: "LATO-MEDIUM", size: 13) // Note the !
        ]
        self.txtSearch.attributedPlaceholder = NSAttributedString(string: "search country", attributes:attributes as [NSAttributedString.Key : Any])
    }
    func readJshonFile() {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "countriesList", ofType: "json")
        let  info = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        let data = info!.data(using: String.Encoding.utf8)
        let json: AnyObject? = try? JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
        //Check for nil
        if let j: AnyObject = json {
            //Map the foundation object to Response object
            self.countyArray = j as! NSArray
            self.filteredUserData = self.countyArray;
            tbView.reloadData()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.searchString(textField.text! as NSString)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CountryViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //self.fetchSerachInformation(isLoder: true)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length == 1 && newString == " " {
            return false
        }
        return true
    }
}
extension CountryViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredUserData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        if let dict = self.filteredUserData[indexPath.row] as? NSDictionary {
            cell.setDataInfo(dict:dict)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dict = self.filteredUserData[indexPath.row] as? NSDictionary {
            if (self.delagate != nil) {
                self.delagate?.selectedCountryInformation(dict: dict)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension CountryViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func searchString(_ searchText: NSString) {
        if searchText == "" {
            filteredUserData = self.countyArray
            
        }else {
            let resultPredicate = NSPredicate(format: "nameImage contains[c] %@", searchText)
            filteredUserData =  self.countyArray.filtered(using: resultPredicate) as NSArray
        }
        tbView.reloadData();
    }
    @objc func keyboardWasShown (notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tbView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tbView.scrollIndicatorInsets = tbView.contentInset
        }
    }
    @objc func keyboardWillBeHidden (notification: NSNotification) {
        tbView.contentInset = UIEdgeInsets.zero
        tbView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
