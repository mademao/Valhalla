//
//  NetUtil.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/3/31.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit

typealias successHandle = (Any?) -> Void
typealias failureHandle = (Error?) -> Void

class NetUtil: NSObject {
    
    var fetchData: Data?
    var success: successHandle?
    var failure: failureHandle?
    
    final class func post(url: String, param: [String : Any]?, success: @escaping successHandle, failure: @escaping failureHandle) -> Void {
        let net = NetUtil()
        net.post(url: url,
                 param: param,
                 success: success,
                 failure: failure)
    }
    
    private func post(url: String, param: [String : Any]?, success: @escaping successHandle, failure: @escaping failureHandle) -> Void {
        self.success = success
        self.failure = failure
        var urlString = baseUrl + url
        if param != nil {
            if Int(param!.keys.count) > 0 {
                urlString.append("?")
            }
            for (key, value) in param! {
                urlString.append(key + "=" + String(describing: value) + "&")
            }
        }
        
        var request = URLRequest(url: URL(string: urlString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        let dataTask = session.dataTask(with: request)
        dataTask.resume()
    }
}


//MARK: - Custom Methods
extension NetUtil {
    //检测服务器
    final class func helloDareway(success: @escaping successHandle, failure: @escaping failureHandle) -> Void {
        post(url: helloUrl, param: nil, success: success, failure: failure)
    }
    
    final class func showNoNet() -> Void {
        let alertView = UIAlertView(title: "温馨提示", message: "您目前处于离线状态，暂时只能使用部分离线功能，待您网络状况良好时，请重启开心宝继续使用哦*^_^*~", delegate: nil, cancelButtonTitle: "知道啦~")
        alertView.show()
    }
}


// MARK: - URLSessionDataDelegate
extension NetUtil: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
        fetchData = Data()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        fetchData?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            failure?(error!)
        } else {
            do {
                let data = try JSONSerialization.jsonObject(with: fetchData!, options: .allowFragments)
                success?(data)
            } catch {
                failure?(nil)
            }
        }
    }
}
