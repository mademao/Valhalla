//
//  LeftVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/6.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit

class LiftVC: UIViewController {

    let bannerImageArr: [String] = ["life_banner1.png", "life_banner2.png", "life_banner3.png"]
    
    fileprivate lazy var configArr: [ConfigModel] = {
        var configArr = [ConfigModel]()
        var configModel: ConfigModel?
        configModel = ConfigModel(text: "通讯录", segue: "liftToAddressBook", icon: "txl.png")
        configArr.append(configModel!)
        configModel = ConfigModel(text: "航班", segue: "liftToBus", icon: "bc.png")
        configArr.append(configModel!)
        configModel = ConfigModel(text: "地图", segue: "liftToMap", icon: "dldt.png")
        configArr.append(configModel!)
        configModel = ConfigModel(text: "婚讯", segue: "liftToWedding", icon: "hytz.png")
        configArr.append(configModel!)
        configModel = ConfigModel(text: "记录", segue: "liftToRecord", icon: "jcjl.png")
        configArr.append(configModel!)
        configModel = ConfigModel(text: "菜谱", segue: "liftToFoods", icon: "cp.png")
        configArr.append(configModel!)
        return configArr
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension LiftVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1{
            return configArr.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiftCell1", for: indexPath)
            var carouselView = cell.contentView.viewWithTag(11111) as? CarouselView
            if carouselView == nil {
                carouselView = CarouselView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1080.0 * 452.0), imageArr: bannerImageArr)
                carouselView?.tag = 11111
                cell.contentView.addSubview(carouselView!)
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiftCell2", for: indexPath)
            var imageView = cell.contentView.viewWithTag(11111) as? UIImageView
            var textLabel = cell.contentView.viewWithTag(11112) as? UILabel
            let configModel = configArr[indexPath.item]
            let cellSize = CGSize(width: (UIScreen.main.bounds.width - 2) / 3.0, height: (UIScreen.main.bounds.width - 2) / 3.0 / 250.0 * 270.0)
            if imageView == nil {
                imageView = UIImageView(frame: CGRect(x: cellSize.width / 4.0, y: cellSize.height / 2.0 - cellSize.width / 2.0 / 151.0 * 124.0 + 10, width: cellSize.width / 2.0, height: cellSize.width / 2.0 / 151.0 * 124.0))
                imageView?.tag = 11111
                cell.contentView.addSubview(imageView!)
            }
            if textLabel == nil {
                textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellSize.width, height: cellSize.height / 3.0))
                textLabel?.center = CGPoint(x: cellSize.width / 2.0, y: cellSize.height / 4.0 * 3.0)
                textLabel?.textAlignment = .center
                textLabel?.textColor = UIColor.black
                textLabel?.font = UIFont.systemFont(ofSize: 13)
                textLabel?.tag = 11112
                cell.contentView.addSubview(textLabel!)
            }
            imageView?.image = UIImage(named: configModel.icon)
            textLabel?.text = configModel.text
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1080.0 * 452.0)
        } else if indexPath.section == 1 {
            return CGSize(width: (UIScreen.main.bounds.width - 2) / 3.0, height: (UIScreen.main.bounds.width - 2) / 3.0 / 250.0 * 270.0)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let configModel = configArr[indexPath.item]
        performSegue(withIdentifier: configModel.segue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewC = segue.destination
        viewC.hidesBottomBarWhenPushed = true
    }
    
}
