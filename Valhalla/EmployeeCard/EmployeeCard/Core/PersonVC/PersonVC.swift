//
//  PersonVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/6.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit

class PersonVC: UIViewController {

    var addressModel: AddressModel?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var officePhoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let photo = "\(baseUrl)dwCard/images/emp_photos/\(addressModel!.photo)"
        imageView.kf.setImage(with: URL(string: photo))
        nameLabel.text = addressModel?.name
        phoneNumberLabel.text = addressModel?.phonenumber
        officePhoneLabel.text = addressModel?.officephone
        emailLabel.text = addressModel?.email
    }
    
    
    @IBAction func personPhoneAction(_ sender: Any) {
        if addressModel!.phonenumber != "" {
            let version = Double(UIDevice.current.systemVersion)
            if version! <= 10.2 {
                callPhone(phonenumber: addressModel!.phonenumber)
            } else {
                let alert = UIAlertController(title: "拨打电话", message: "确认拨打\(addressModel!.name)的电话吗？", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "确认", style: .destructive, handler: { (alert) in
                    self.callPhone(phonenumber: self.addressModel!.phonenumber)
                })
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func personMessageAction(_ sender: Any) {
        if addressModel!.phonenumber != "" {
            callMessage(phonenumber: addressModel!.phonenumber)
        }
    }

    @IBAction func officePhoneAction(_ sender: Any) {
        if addressModel!.officephone != "" {
            let version = Double(UIDevice.current.systemVersion)
            if version! <= 10.2 {
                callPhone(phonenumber: addressModel!.officephone)
            } else {
                let alert = UIAlertController(title: "拨打电话", message: "确认拨打\(addressModel!.name)的办公电话吗？", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "确认", style: .destructive, handler: { (alert) in
                    self.callPhone(phonenumber: self.addressModel!.officephone)
                })
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    
    func callPhone(phonenumber: String) -> Void {
        let callString = "tel://\(phonenumber)"
        let url = URL(string: callString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func callMessage(phonenumber: String) -> Void {
        let callString = "sms://\(phonenumber)"
        let url = URL(string: callString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
