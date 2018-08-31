//
//  QRCodeVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/5.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit
import Pluto

let QRCodeKey = "Employee.QRCodeKey"

enum QRCodeMethod : String {
    case get = "GET"
    case refresh = "REFRESH"
}

class QRCodeVC: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statueLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = AppDelegate.getAppDelegate().currentEm?.userName
        statueLabel.textColor = UIColor(red: 189.0 / 255.0, green: 189.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
        statueLabel.text = "下拉刷新二维码"
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.4
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshQRCodeImage()
    }
    
    fileprivate func refreshQRCodeImage() -> Void {
        if qrCodeImage.image == nil {
            let userDefaults = UserDefaults.standard
            
            let qrContent = userDefaults.string(forKey: QRCodeKey)
            if qrContent == nil {
                connectWith(method: .get)
            } else {
                qrCodeImage.image = createQRCodeWith(content: qrContent!, size: qrCodeImage.frame.size)
            }
        }
    }
    
    //生成二维码
    fileprivate func createQRCodeWith(content: String, size: CGSize) -> UIImage? {
        let contentData = content.data(using: .utf8)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(contentData!, forKey: "inputMessage")
        qrFilter?.setValue("M", forKey: "inputCorrectionLevel")
        
        let onColor = UIColor(red: 251.0 / 255.0, green: 71.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
        let offColor = UIColor.white
        
        let colorFiler = CIFilter(name: "CIFalseColor",
                                  withInputParameters: ["inputImage" : qrFilter!.outputImage!,
                                                        "inputColor0" : CIColor(cgColor: onColor.cgColor),
                                                        "inputColor1" : CIColor(cgColor: offColor.cgColor)])
        let qrImage = colorFiler?.outputImage
        let cgImage = CIContext(options: nil).createCGImage(qrImage!, from: qrImage!.extent)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.interpolationQuality = .none
        context?.draw(cgImage!, in: context!.boundingBoxOfClipPath)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return codeImage
    }
    
    
    
    //与服务器交互
    fileprivate func connectWith(method: QRCodeMethod) -> Void {
        let param = ["empId" : AppDelegate.getAppDelegate().currentEm?.userId ?? "",
                     "type" : "phone",
                     "method" : method.rawValue] as [String : Any]
        NetUtil.post(url: qrCodeUrl,
                     param: param,
                     success: { (data) in
                        let dataDic = data as! [String : Any]
                        if dataDic["errorCode"] as! String == "0",
                            let key = dataDic["key"] as? String {
                            let userDefaults = UserDefaults.standard
                            let qrCode = "{'id':'\(AppDelegate.getAppDelegate().currentEm?.userId ?? "")','k':'\(key)','pt':'IOS'"
                            userDefaults.set(qrCode, forKey: QRCodeKey)
                            userDefaults.synchronize()
                            self.qrCodeImage.image = nil
                            self.refreshQRCodeImage()
                        } else {
                            pltError("获取二维码出错")
                        }
        },
                     failure: { (error) in
                        pltError("获取二维码出错")
        })
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension QRCodeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if self.scrollView.contentOffset.y <= -self.statueLabel.frame.size.height - self.statueLabel.frame.origin.y {
                self.statueLabel.text = "释放更新二维码"
            } else {
                self.statueLabel.text = "下拉刷新二维码"
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.scrollView {
            if self.scrollView.contentOffset.y <= -self.statueLabel.frame.size.height - self.statueLabel.frame.origin.y {
                self.connectWith(method: .refresh)
            }
        }
    }
}
