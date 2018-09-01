//
//  ViewController.swift
//  StepCount
//
//  Created by Dareway on 2018/1/11.
//  Copyright © 2018年 Pluto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func healthKitReadData(_ sender: UIButton) {
        let healthKitVC = HealthKitReadViewController()
        navigationController?.pushViewController(healthKitVC, animated: true)
    }
    
    @IBAction func healthKitWriteData(_ sender: UIButton) {
        let healthKitVC = HealthKitWriteViewController()
        navigationController?.pushViewController(healthKitVC, animated: true)
    }
    
    @IBAction func coreMotionReadData(_ sender: UIButton) {
        let coreMotionVC = CoreMotionReadViewController()
        navigationController?.pushViewController(coreMotionVC, animated: true)
    }
    
    
}

