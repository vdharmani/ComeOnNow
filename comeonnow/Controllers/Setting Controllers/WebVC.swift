//
//  WebVC.swift
//  comeonnow
//
//  Created by Apple on 06/07/21.
//

import UIKit
import WebKit
class WebVC: UIViewController {

    var linkurl = ""
    var linkLblText = ""
    @IBOutlet weak var linkWebView: WKWebView!
    @IBOutlet weak var headingLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: linkurl)
        let request = NSURLRequest(url: url! as URL)
        linkWebView.navigationDelegate = self
        linkWebView.load(request as URLRequest)
        headingLbl.text = linkLblText
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
extension WebVC:WKNavigationDelegate{

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
  }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    AFWrapperClass.svprogressHudDismiss(view: self)
  }

    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        Alert.present(
            title: AppAlertTitle.appName.rawValue,
            message: error.localizedDescription,
            actions: .ok(handler: {
            }),
            from: self
        )
      }
}
