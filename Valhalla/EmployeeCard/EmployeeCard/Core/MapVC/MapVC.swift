//
//  MapVC.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/7.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit

class MapVC: UIViewController {
    
    
    @IBOutlet weak var whiteBlackOffsetX: NSLayoutConstraint!
    @IBOutlet weak var buttonScroll: UIScrollView!
    @IBOutlet weak var imageScroll: UIScrollView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var imageViews: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScroll.delegate = self
        for imageView in imageViews {
            let i = imageViews.index(of: imageView)!
            imageView.kf.setImage(with: URL(string: "\(baseUrl)\(mapInfoUrl)floor_\(i).jpg"))
        }
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        let button = sender as! UIView
        let tag = button.tag - 11110
        //按钮ScrollView偏移设置
        var buttonOffsetX = button.plt_midX - buttonScroll.plt_width / 2.0
        if buttonOffsetX < 0 {
            buttonOffsetX = 0
        }
        if buttonOffsetX > buttonScroll.plt_width / 2.0 {
            buttonOffsetX = buttonScroll.plt_width / 2.0
        }
        buttonScroll.setContentOffset(CGPoint(x: buttonOffsetX, y: 0), animated: true)
        //图片ScrollView偏移设置
        imageScroll.setContentOffset(CGPoint(x: imageScroll.plt_width * CGFloat(tag), y: 0), animated: true)
        //白条位置设置
        whiteBlackOffsetX.constant = button.plt_x
        UIView.animate(withDuration: 0.25) {
            self.buttonScroll.layoutIfNeeded()
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension MapVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageScroll {
            let i = Int((imageScroll.plt_offsetX + 5) / imageScroll.plt_width)
            buttonAction(buttons[i])
        }
    }
}
