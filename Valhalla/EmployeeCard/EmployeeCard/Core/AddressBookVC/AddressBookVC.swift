//
//  AddressBookVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/6.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit

class AddressBookVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let addressArr = DBUtil.sharedDBUtil.selectAllAddress()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "AddressBookCell")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension AddressBookVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return addressArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var array: [AddressModel]?
        for (_, value) in addressArr[section] {
            array = value
            break
        }
        return array!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressBookCell", for: indexPath)
        cell.textLabel?.backgroundColor = UIColor.clear
        var phoneIV = cell.contentView.viewWithTag(11111) as? UIImageView
        var messageIV = cell.contentView.viewWithTag(11112) as? UIImageView
        if phoneIV == nil {
            phoneIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            phoneIV?.center = CGPoint(x: UIScreen.main.bounds.width - 102, y: 22)
            phoneIV?.tag = 11111
            phoneIV?.image = UIImage(named: "phone.png")
            cell.contentView.addSubview(phoneIV!)
            phoneIV?.isUserInteractionEnabled = true
            let phoneTapGR = UITapGestureRecognizer(target: self, action: #selector(phoneIVAction(gr:)))
            phoneIV?.addGestureRecognizer(phoneTapGR)
        }
        if messageIV == nil {
            messageIV = UIImageView(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
            messageIV?.center = CGPoint(x: UIScreen.main.bounds.width - 59, y: 22)
            messageIV?.tag = 11112
            messageIV?.image = UIImage(named: "message.png")
            cell.contentView.addSubview(messageIV!)
            messageIV?.isUserInteractionEnabled = true
            let messageTapGR = UITapGestureRecognizer(target: self, action: #selector(messageIVAction(gr:)))
            messageIV?.addGestureRecognizer(messageTapGR)
        }
        
        var array: [AddressModel]?
        for (_, value) in addressArr[indexPath.section] {
            array = value
            break
        }
        let addressModel = array![indexPath.row]
        cell.textLabel?.text = addressModel.name
        if addressModel.phonenumber == "" {
            phoneIV?.isHidden = true
            messageIV?.isHidden = true
        } else {
            phoneIV?.isHidden = false
            messageIV?.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var array: [AddressModel]?
        for (_, value) in addressArr[indexPath.section] {
            array = value
            break
        }
        let addressModel = array![indexPath.row]
        performSegue(withIdentifier: "addressBookToPerson", sender: addressModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addressBookToPerson" {
            let personVC = segue.destination as! PersonVC
            personVC.addressModel = sender as? AddressModel
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var string: String?
        for (key, _) in addressArr[section] {
            string = key
            break
        }
        return string
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var array = [String]()
        for dic in addressArr {
            for (key, _) in dic {
                array.append(key)
                break
            }
        }
        return array
    }
    
    func phoneIVAction(gr: UITapGestureRecognizer) -> Void {
        let cell = gr.view?.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        var array: [AddressModel]?
        for (_, value) in addressArr[indexPath.section] {
            array = value
            break
        }
        let addressModel = array![indexPath.row]
        let version = Double(UIDevice.current.systemVersion)
        if version! <= 10.2 {
            callPhone(phonenumber: addressModel.phonenumber)
        } else {
            let alert = UIAlertController(title: "拨打电话", message: "确认拨打\(addressModel.name)的电话吗？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确认", style: .destructive, handler: { (alert) in
                self.callPhone(phonenumber: addressModel.phonenumber)
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func callPhone(phonenumber: String) -> Void {
        let callString = "tel://\(phonenumber)"
        let url = URL(string: callString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func messageIVAction(gr: UITapGestureRecognizer) -> Void {
        let cell = gr.view?.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        var array: [AddressModel]?
        for (_, value) in addressArr[indexPath.section] {
            array = value
            break
        }
        let addressModel = array![indexPath.row]
        callMessage(phonenumber: addressModel.phonenumber)
    }
    
    func callMessage(phonenumber: String) -> Void {
        let callString = "sms://\(phonenumber)"
        let url = URL(string: callString)!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}
