//
//  BusVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/7.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusVC: UIViewController {

    var busModelArr = [BusModel]()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getBusInfo()
    }
    
    func getBusInfo() -> Void {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        NetUtil.post(url: busInfoUrl,
                     param: nil,
                     success: { (data) in
                        let dataDic = data as! [String : Any]
                        if let errorCode = dataDic["errorCode"] as? String, errorCode == "0" {
                            hud.hide(true)
                            self.configBusModelArr(busArr: (dataDic["bus"] as? [[String : Any]]) ?? [[String : Any]](), runtimeArr: (dataDic["runtime"] as? [[String : Any]]) ?? [[String : Any]]())
                        } else {
                            hud.mode = .text
                            hud.labelText = (dataDic["errorText"] as? String) ?? ""
                            hud.hide(true, afterDelay: 2.5)
                        }
        },
                     failure: { (error) in
                        hud.mode = .text
                        hud.labelText = "网络出错"
                        hud.hide(true, afterDelay: 2.5)
        })
    }
    
    func configBusModelArr(busArr: [[String : Any]], runtimeArr: [[String : Any]]) -> Void {
        let newBusArr = busArr.sorted {
            $1["id"] as! String > $0["id"] as! String
        }
        for dic in newBusArr {
            let id = dic["id"] as? String
            let name = dic["name"] as? String
            let number = dic["cph"] as? String
            var startTime: String?
            var endTime: String?
            for runtimeDic in runtimeArr {
                let vrid = runtimeDic["vrid"] as? String
                if vrid == id {
                    if runtimeDic["sxh"] as? Int == 1 {
                        startTime = runtimeDic["time"] as? String
                    }
                    if runtimeDic["sxh"] as? Int == 2 {
                        endTime = runtimeDic["time"] as? String
                    }
                }
            }
            let busModel = BusModel(id: id, name: name, number: number, startTime: startTime, endTime: endTime)
            busModelArr.append(busModel)
        }
        tableView.reloadData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension BusVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusTableCell") as! BusTableCell
        let model = busModelArr[indexPath.row]
        cell.nameLabel.text = model.name
        cell.numberLabel.text = model.number
        cell.beginTimeLabel.text = model.startTime
        cell.endTimeLabel.text = model.endTime
        return cell
    }
}
