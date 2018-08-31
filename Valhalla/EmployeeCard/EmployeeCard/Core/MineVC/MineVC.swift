//
//  MineVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/7.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit

class MineVC: UIViewController {

    @IBOutlet weak var photoBackView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoBackView.layer.cornerRadius = photoBackView.frame.size.width / 2.0
        photoBackView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2.0
        photoImageView.layer.masksToBounds = true
        
        let photo = AppDelegate.getAppDelegate().currentEm?.photo ?? ""
        photoImageView.kf.setImage(with: URL(string: photo))
        
        nameLabel.text = AppDelegate.getAppDelegate().currentEm?.userName
        numberLabel.text = "员工号：\(AppDelegate.getAppDelegate().currentEm?.userId ?? "")"
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        let alertController = UIAlertController(title: "提示", message: "确认退出登录？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确认", style: .destructive) { (alertAction) in
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: SavedUserID)
            userDefaults.removeObject(forKey: SavedUserPW)
            userDefaults.synchronize()
            self.dismiss(animated: false) {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(LogOutNotification), object: nil)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
