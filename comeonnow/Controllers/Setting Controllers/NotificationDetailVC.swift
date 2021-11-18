//
//  NotificationDetailVC.swift
//  comeonnow
//
//  Created by Apple on 22/10/21.
//


import UIKit
import WebKit
import SVProgressHUD

class NotificationDetailVC: UIViewController,WKNavigationDelegate,WKUIDelegate{
    var webLinkUrlString = String()
    var navBarTitleString = String()
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var navBarTextLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarTextLbl.text = navBarTitleString
        // Do any additional setup after loading the view.
        if let url = URL(string: webLinkUrlString) {
            let request = URLRequest(url: url)
            webView.navigationDelegate = self
            webView.uiDelegate = self
            webView.load(request)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    //------------------------------------------------------
    
    //MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async {
            AFWrapperClass.svprogressHudShow(title:"Loading...", view:self)
        }
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        AFWrapperClass.svprogressHudDismiss(view: self)
        
        //        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(.zero)
        //        webView.scrollView.isScrollEnabled=false;
        //        webViewHeightConstraint.constant = webView.scrollView.contentSize.height
        //        webView.scrollView.minimumZoomScale = 0.1;
        //        webView.scrollView.maximumZoomScale = 0.9;
        //        webView.scrollView.setZoomScale(0.39, animated: true)
        
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        var scriptContent = "var meta = document.createElement('meta');"
        scriptContent += "meta.name='viewport';"
        scriptContent += "meta.content='width=device-width';"
        scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(scriptContent, completionHandler: nil)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        AFWrapperClass.svprogressHudDismiss(view: self)
        
    }
    
}

