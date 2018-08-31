//
//  WeddingDetailVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/7.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit

class WeddingDetailVC: UIViewController {

    var weddingModel: WeddingModel?
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var mnameLabel: UILabel!
    @IBOutlet weak var wnameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var lxrLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImage.kf.setImage(with: URL(string: "\(baseUrl)\(weddingPhotoUrl)\(weddingModel!.photo)"))
        mnameLabel.text = "新郎：\(weddingModel!.mname)"
        wnameLabel.text = "新娘：\(weddingModel!.wname)"
        typeLabel.text = weddingModel!.type
        lxrLabel.text = "联系人：\(weddingModel!.lxr)"
        emailLabel.text = "邮箱：\(weddingModel!.email)"
        timeLabel.text = "时间：\(weddingModel!.marrydate)"
        locationLabel.text = "地点：\(weddingModel!.hotel)"
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
