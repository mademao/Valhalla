//
//  AutoLoginVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/1.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit
import MBProgressHUD

let LogOutNotification = "EmployeeCard.LogOut"

class AutoLoginVC: UIViewController {

    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NotificationCenter.default.addObserver(self, selector: #selector(checkState), name: NSNotification.Name(LogOutNotification), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.checkState()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(LogOutNotification), object: nil)
    }
    
    func checkState() -> Void {
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //检测是否有登录信息的保存
        let userDefaults = UserDefaults.standard
        let savedUserId = userDefaults.string(forKey: SavedUserID)
        let savedUserPW = userDefaults.string(forKey: SavedUserPW)
        if savedUserId != nil {
            //检测网络
            NetUtil.helloDareway(success: { (data) in
                //自动调用登录接口
                if savedUserId != nil && savedUserPW != nil {
                    self.autoLogin(username: savedUserId!, password: savedUserPW!)
                } else {
                    self.hud!.hide(true)
                    self.performSegue(withIdentifier: "autoLoginToLogin", sender: nil)
                }
            }, failure: { (error) in
                self.hud!.hide(true)
                //获取缓存数据库中的用户信息，如果用户存在，则进入主页面，提示网络错误，若不存在，则跳至登录界面
                let employee = DBUtil.sharedDBUtil.getEmployeeWith(id: savedUserId!)
                if employee != nil {
                    AppDelegate.getAppDelegate().currentEm = employee!
                    NetUtil.showNoNet()
                    self.performSegue(withIdentifier: "autoLoginToMain", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "autoLoginToLogin", sender: nil)
                }
            })
        } else {
            self.hud!.hide(true)
            self.performSegue(withIdentifier: "autoLoginToLogin", sender: nil)
        }
    }
    
    func autoLogin(username: String, password: String) -> Void {
        self.hud?.mode = .text
        self.hud?.labelText = "正在登录"
        let param = ["username" : username,
                     "password" : password]
        NetUtil.post(url: loginUrl,
                     param: param,
                     success: { (data) in
                        self.hud?.hide(true)
                        let dataDic = data as! [String : Any]
                        if dataDic["errorCode"] as! String == "0" {
                            //存入数据库缓存
                            let em = Employee(userId: dataDic["empId"] as? String,
                                              userName: dataDic["empName"] as? String,
                                              photo: dataDic["imgUrl"] as? String,
                                              phone: dataDic["phone"] as? String,
                                              imgStr: dataDic["imgStr"] as? String)
                            AppDelegate.getAppDelegate().currentEm = em
                            DBUtil.sharedDBUtil.saveEmployee(employee: em)
                            self.performSegue(withIdentifier: "autoLoginToMain", sender: nil)
                        } else {
                            self.performSegue(withIdentifier: "autoLoginToLogin", sender: nil)
                        }
        },
                     failure: { (error) in
                        self.hud?.hide(true)
                        self.performSegue(withIdentifier: "autoLoginToLogin", sender: nil)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "autoLoginToLogin" {
            let vc = segue.destination as! LoginVC
            vc.block = {
                self.performSegue(withIdentifier: "autoLoginToMain", sender: nil)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
