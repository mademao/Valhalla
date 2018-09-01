//
//  HealthKitWriteViewController.swift
//  StepCount
//
//  Created by Dareway on 2018/1/12.
//  Copyright © 2018年 Pluto. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitWriteViewController: UIViewController {
    
    let textField = UITextField()
    let healthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HealthKit写入"
        view.backgroundColor = UIColor.white
        
        self.edgesForExtendedLayout = []
        
        textField.frame = CGRect(x: 50, y: 70, width: UIScreen.main.bounds.size.width - 100, height: 50)
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.placeholder = "请填写录入步数"
        textField.returnKeyType = .done
        view.addSubview(textField)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: textField.frame.minX, y: textField.frame.maxY + 50, width: textField.frame.width, height: textField.frame.height)
        button.backgroundColor = UIColor(red: 63.0 / 255.0, green: 114.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
        button.setTitle("添加", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc
    func buttonAction() -> Void {
        if textField.text != nil && textField.text! != "" {
            if HKHealthStore.isHealthDataAvailable() {
                healthStore.requestAuthorization(toShare: createType(), read: createType(), completion: { (success, error) in
                    DispatchQueue.main.async {
                        if success == true {
                            self.addStepCount()
                        } else {
                            self.showTitle("授权失败")
                        }
                    }
                })
            } else {
                showTitle("设备不支持访问")
            }
        } else {
            showTitle("请填写步数")
        }
    }
    
    func createType() -> Set<HKSampleType> {
        let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        return Set(arrayLiteral: stepCountType, distanceType)
    }
    
    func addStepCount() -> Void {
        let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: Double(textField.text!)!)
        let device = HKDevice.local()
        let stepSample = HKQuantitySample(type: HKQuantityType.quantityType(forIdentifier: .stepCount)!, quantity: quantity, start: Date(timeIntervalSinceNow: -5 * 60), end: Date(), device: device, metadata: nil)
        healthStore.save(stepSample) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.showTitle("添加成功")
                } else {
                    self.showTitle("添加失败：\(String(describing: error))")
                }
            }
        }
    }
    
    func showTitle(_ title: String) -> Void {
        let alertC = UIAlertController.init(title: "提示", message: title, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertC.addAction(action)
        self.present(alertC, animated: true, completion: nil)
    }

}

extension HealthKitWriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
