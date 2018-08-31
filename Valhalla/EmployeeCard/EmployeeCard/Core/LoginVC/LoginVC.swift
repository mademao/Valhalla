//
//  LoginVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/1.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit
import Kingfisher
import MBProgressHUD

class LoginVC: UIViewController {

    
    @IBOutlet weak var backViewToTop: NSLayoutConstraint!
    @IBOutlet weak var avatarIV: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passWordTF: UITextField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    
    var block: ((Void) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置输入框左侧视图
        setupTFLeftView()
        
        //添加键盘监控
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupTFLeftView() -> Void {
        userNameTF.borderStyle = .roundedRect
        passWordTF.borderStyle = .roundedRect
        
        let userNameTFLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 40))
        let userNameTFLeftIV = UIImageView(image: UIImage(named:"username_tips.png"))
        userNameTFLeftIV.frame = CGRect(x: 7, y: 8, width: 20, height: 24)
        userNameTFLeftView.addSubview(userNameTFLeftIV)
        userNameTF.leftView = userNameTFLeftView
        userNameTF.leftViewMode = .always
        
        let passWordTFLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 40))
        let passWordTFLeftIV = UIImageView(image: UIImage(named:"password_tips.png"))
        passWordTFLeftIV.frame = CGRect(x: 7, y: 8, width: 20, height: 24)
        passWordTFLeftView.addSubview(passWordTFLeftIV)
        passWordTF.leftView = passWordTFLeftView
        passWordTF.leftViewMode = .always
        
        userNameTF.delegate = self
        passWordTF.delegate = self
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let username = userNameTF.text, username != "" else {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .text
            hud.labelText = "用户名不能为空"
            hud.hide(true, afterDelay: 0.75)
            return
        }
        guard let password = passWordTF.text, password != "" else {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .text
            hud.labelText = "密码不能为空"
            hud.hide(true, afterDelay: 0.75)
            return
        }
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        hud.labelText = "正在登录"
        let param = ["username" : username,
                     "password" : password]
        NetUtil.post(url: loginUrl,
                     param: param,
                     success: { (data) in
                        let dataDic = data as! [String : Any]
                        if dataDic["errorCode"] as! String == "0" {
                            //登录成功
                            hud.hide(true)
                            //存入数据库缓存
                            let em = Employee(userId: dataDic["empId"] as? String,
                                              userName: dataDic["empName"] as? String,
                                              photo: dataDic["imgUrl"] as? String,
                                              phone: dataDic["phone"] as? String,
                                              imgStr: dataDic["imgStr"] as? String)
                            AppDelegate.getAppDelegate().currentEm = em
                            DBUtil.sharedDBUtil.saveEmployee(employee: em)
                            //根据选择保存用户信息
                            if self.rememberSwitch.isOn == true {
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(dataDic["empId"] as! String, forKey: SavedUserID)
                                userDefaults.set(password, forKey: SavedUserPW)
                                userDefaults.synchronize()
                            }
                            self.dismiss(animated: false, completion: { 
                                if self.block != nil {
                                    self.block!()
                                }
                            })
                        } else if dataDic["errorCode"] as! String == "404" {
                            //总线挂了
                            NetUtil.showNoNet()
                            self.dismiss(animated: false, completion: {
                                if self.block != nil {
                                    self.block!()
                                }
                            })
                        } else {
                            hud.labelText = dataDic["errorText"] as! String
                            hud.show(true)
                            hud.hide(true, afterDelay: 0.75)
                        }
        },
                     failure: { (error) in
                        hud.labelText = "网络出错"
                        hud.show(true)
                        hud.hide(true, afterDelay: 0.75)
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK: - 键盘相关
extension LoginVC: UITextFieldDelegate {
    func keyboardWillShow(notification: Notification) -> Void {
        if self.backViewToTop.constant > -5 {
            UIView.animate(withDuration: 1) {
                self.backViewToTop.constant = -135
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardWillHide(notification: Notification) -> Void {
        if self.backViewToTop.constant < -130 {
            UIView.animate(withDuration: 1) {
                self.backViewToTop.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userNameTF {
            let photo = DBUtil.sharedDBUtil.getEmployeePhoto(userId: userNameTF.text ?? "")
            if photo != nil {
                avatarIV.kf.setImage(with: URL(string: photo!))
            }
        }
    }
}
