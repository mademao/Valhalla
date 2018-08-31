//
//  WeddingVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/7.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit
import MBProgressHUD
import MJRefresh

class WeddingVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var currentPage: Int = 0
    let pageCount: Int = 10
    
    var weddingModelArr = [WeddingModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData(hud:)))
        loadData(hud: true)
    }
    
    func loadData(hud: Bool) -> Void {
        currentPage = currentPage + 1
        var mbhud: MBProgressHUD?
        if hud == true {
            mbhud = MBProgressHUD.showAdded(to: view, animated: true)
        }
        let param = ["page" : currentPage,
                     "count" : pageCount]
        NetUtil.post(url: weddingInfoUrl,
                     param: param,
                     success: { (data) in
                        let dataDic = data as! [String : Any]
                        if let result = dataDic["result"] as? String, result == "0" {
                            mbhud?.hide(true)
                            let marry = dataDic["marry"] as! [[String : Any]]
                            if marry.count == 0 {
                                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                            } else {
                                for dic in marry {
                                    let mid = dic["mid"] as? String
                                    let mdepart = dic["mdepart"] as? String
                                    let mname = dic["mname"] as? String
                                    let wname = dic["wname"] as? String
                                    let shortdate = dic["shortdate"] as? String
                                    let lxr = dic["lxr"] as? String
                                    let email = dic["email"] as? String
                                    let marrydate = dic["marrydate"] as? String
                                    let hotel = dic["hotel"] as? String
                                    let photo = dic["photo"] as? String
                                    let type = dic["type"] as? String
                                    let weddingModel = WeddingModel(mid: mid, mdepart: mdepart, mname: mname, wname: wname, shortdate: shortdate, lxr: lxr, email: email, marrydate: marrydate, hotel: hotel, photo: photo, type: type)
                                    self.weddingModelArr.append(weddingModel)
                                }
                                self.tableView.mj_footer.endRefreshing()
                                self.tableView.reloadData()
                            }
                        } else {
                            mbhud?.mode = .text
                            mbhud?.labelText = (dataDic["errmsg"] as? String) ?? ""
                            mbhud?.hide(true, afterDelay: 2)
                        }
        },
                     failure: { (error) in
                        mbhud?.mode = .text
                        mbhud?.labelText = "网络出错"
                        mbhud?.hide(true, afterDelay: 2)
        })
    }
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension WeddingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weddingModelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeddingTableCell") as! WeddingTableCell
        let weddingModel = weddingModelArr[indexPath.row]
        cell.departLabel.text = weddingModel.mdepart
        cell.nameLabel.text = "\(weddingModel.mname)和\(weddingModel.wname)"
        cell.timeLabel.text = weddingModel.shortdate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let weddingModel = weddingModelArr[indexPath.row]
        performSegue(withIdentifier: "weddingToDetail", sender: weddingModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "weddingToDetail" {
            let weddingDetailVC = segue.destination as! WeddingDetailVC
            weddingDetailVC.weddingModel = sender as? WeddingModel
        }
    }
}
