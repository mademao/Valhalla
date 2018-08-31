//
//  FoodsVC.swift
//  EmployeeCard
//
//  Created by 马德茂 on 2017/4/9.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit
import Pluto

class FoodsVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.bounces = false
        webView.delegate = self
        let url = URL(string: "\(baseUrl)\(servicePagesUrl)");
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let empId = AppDelegate.getAppDelegate().currentEm?.userId ?? ""
        request.httpBody = "empId=\(empId)&pagekey=foods".data(using: .utf8)
        webView.loadRequest(request)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension FoodsVC: UIWebViewDelegate {
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        pltError(error)
    }
}
