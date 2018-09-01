//
//  HealthKitReadViewController.swift
//  StepCount
//
//  Created by Dareway on 2018/1/11.
//  Copyright © 2018年 Pluto. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitReadViewController: UIViewController {

    let healthStore = HKHealthStore()
    let dateFormatter = DateFormatter()
    let tableView = UITableView(frame: .zero, style: .grouped)
    let label = UILabel()
    var dataArray = [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "HealthKit读取"
        view.backgroundColor = UIColor.white
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        label.frame = CGRect(x: 0, y: 88, width: UIScreen.main.bounds.size.width, height: 50.0)
        label.font = UIFont.systemFont(ofSize: 19.0)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        view.addSubview(label)
        
        tableView.frame = CGRect(x: 0, y: 88 + label.frame.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 88 - label.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: createType(), read: createType(), completion: { (success, error) in
                if success == true {
                    self.getHealthStepData()
                    self.getHealthDistanceData()
                } else {
                    self.showTitle("授权失败")
                }
            })
        } else {
            showTitle("设备不支持访问")
        }
    }
    
    func createType() -> Set<HKSampleType> {
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        return Set(arrayLiteral: stepCountType, distanceType)
    }
    
    func getHealthStepData() -> Void {
        // 查询日期
        var dateString = dateFormatter.string(from: Date())
        dateString = String(dateString[..<dateString.index(dateString.startIndex, offsetBy: 11)])
        dateString = dateString + "00:00:00"
        let startDate = dateFormatter.date(from: dateString)!
        //设置读取时间
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        //读取记步数据
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let sampleQuery = HKSampleQuery(sampleType: stepCountType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if error == nil && results != nil {
                self.dataArray.removeAll()
                for sample in results! {
                    let samples = sample as! HKQuantitySample
                    //前一个判断，去除在健康app中手动添加数据。
                    //后一个判断，去除其他App代码写入的数据。
                    if (samples.device?.name == "Apple Watch" || samples.device?.name == "iPhone") && samples.sourceRevision.source.bundleIdentifier.hasPrefix("com.apple.health") {
                        let time = "\(self.dateFormatter.string(from: samples.startDate)) 到 \(self.dateFormatter.string(from: samples.endDate))"
                        let step = "\(samples.quantity)"
                        let dic = ["time" : time,
                                   "step" : step]
                        self.dataArray.append(dic)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                self.showTitle("出错")
            }
        }
        healthStore.execute(sampleQuery)
    }
    
    func getHealthDistanceData() -> Void {
        // 查询日期
        var dateString = dateFormatter.string(from: Date())
        dateString = String(dateString[..<dateString.index(dateString.startIndex, offsetBy: 11)])
        dateString = dateString + "00:00:00"
        let startDate = dateFormatter.date(from: dateString)!
        //设置读取时间
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        //读取路程数据
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let sampleQuery = HKSampleQuery(sampleType: distanceType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if error == nil && results != nil {
                var distance: Double = 0.0
                for sample in results! {
                    let samples = sample as! HKQuantitySample
                    //前一个判断，去除在健康app中手动添加数据。
                    //后一个判断，去除其他App代码写入的数据。
                    if (samples.device?.name == "Apple Watch" || samples.device?.name == "iPhone") && samples.sourceRevision.source.bundleIdentifier.hasPrefix("com.apple.health") {
                        let distanceUnit = HKUnit.meterUnit(with: HKMetricPrefix.kilo)
                        distance = distance + samples.quantity.doubleValue(for: distanceUnit)
                    }
                }
                DispatchQueue.main.async {
                    self.label.text = "\(distance)"
                }
            } else {
                self.showTitle("出错")
            }
        }
        healthStore.execute(sampleQuery)
    }
    
    func showTitle(_ title: String) -> Void {
        let alertC = UIAlertController.init(title: "提示", message: title, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertC.addAction(action)
        self.present(alertC, animated: true, completion: nil)
    }

}

extension HealthKitReadViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let d = self.dataArray[indexPath.row]
        
        cell?.textLabel?.text = d["time"]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        cell?.detailTextLabel?.text = d["step"]
        
        return cell!
    }
    
}
