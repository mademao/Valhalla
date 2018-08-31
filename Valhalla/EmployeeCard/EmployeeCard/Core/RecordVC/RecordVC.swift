//
//  RecordVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/7.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

class RecordVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var currentPage: Int = 0
    let pageCount: Int = 10
    
    var recordArr = [String]()
    
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
                     "count" : pageCount,
                     "empId" : (AppDelegate.getAppDelegate().currentEm?.userId) ?? ""] as [String : Any]
        NetUtil.post(url: recordInfoUrl,
                     param: param,
                     success: { (data) in
                        let dataDic = data as! [String : Any]
                        if let result = dataDic["result"] as? String, result == "0" {
                            mbhud?.hide(true)
                            let his = dataDic["his"] as! [String]
                            if his.count == 0 {
                                self.tableView.mj_footer.endRefreshingWithNoMoreData()
                            } else {
                                self.recordArr.append(contentsOf: his)
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

extension RecordVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableCell") as! RecordTableCell
        let record = recordArr[indexPath.row]
        cell.recordLabel.text = record
        return cell
    }
}
