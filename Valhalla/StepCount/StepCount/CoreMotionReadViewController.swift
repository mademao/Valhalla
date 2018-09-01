//
//  CoreMotionReadViewController.swift
//  StepCount
//
//  Created by Dareway on 2018/1/12.
//  Copyright © 2018年 Pluto. All rights reserved.
//

import UIKit
import CoreMotion

class CoreMotionReadViewController: UIViewController {

    let stepLabel = UILabel()
    let distanceLabel = UILabel()
    let pedometer = CMPedometer()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "CoreMotion读取"
        view.backgroundColor = UIColor.white

        edgesForExtendedLayout = []
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.size.width, height: 50.0)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 19.0)
        titleLabel.text = "今日运动数据"
        view.addSubview(titleLabel)
        
        stepLabel.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: UIScreen.main.bounds.size.width, height: 50.0)
        stepLabel.textAlignment = .center
        stepLabel.font = UIFont.systemFont(ofSize: 19.0)
        view.addSubview(stepLabel)
        
        distanceLabel.frame = CGRect(x: 0, y: stepLabel.frame.maxY, width: UIScreen.main.bounds.size.width, height: 50.0)
        distanceLabel.textAlignment = .center
        distanceLabel.font = UIFont.systemFont(ofSize: 19.0)
        view.addSubview(distanceLabel)
        
        if CMPedometer.isStepCountingAvailable() {
            // 查询日期
            var dateString = dateFormatter.string(from: Date())
            dateString = String(dateString[..<dateString.index(dateString.startIndex, offsetBy: 11)])
            dateString = dateString + "00:00:00"
            let startDate = dateFormatter.date(from: dateString)!
            
            pedometer.queryPedometerData(from: startDate, to: Date(), withHandler: { (pedometerData, error) in
                DispatchQueue.main.async {
                    if pedometerData != nil && error == nil {
                        self.stepLabel.text = "步数:\(pedometerData!.numberOfSteps)"
                        self.distanceLabel.text = "距离:\(String(describing: pedometerData!.distance ?? 0))"
                    } else {
                        self.showTitle("读取失败")
                    }
                }
            })
        } else {
            showTitle("没有权限")
        }
    }
    
    func showTitle(_ title: String) -> Void {
        let alertC = UIAlertController.init(title: "提示", message: title, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertC.addAction(action)
        self.present(alertC, animated: true, completion: nil)
    }

}
