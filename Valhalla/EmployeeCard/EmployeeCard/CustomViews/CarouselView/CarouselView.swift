//
//  CarouselView.swift
//  EmployeeCard
//
//  Created by PlutoMa on 2017/4/6.
//  Copyright © 2017年 PlutoMa. All rights reserved.
//

import UIKit
import Pluto

class CarouselView: UIView {

    fileprivate var collectionView: UICollectionView?
    var imageArr: [String]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, imageArr: [String]) {
        self.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "CarouselCell")
        self.addSubview(collectionView!)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.scrollToItem(at: IndexPath(item: 5000, section: 0), at: .left, animated: false)
        self.imageArr = imageArr
        
        self.timer = PltTimerCommonModes(4, self, #selector(timerAction), nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func timerAction() -> Void {
        var indexPath = collectionView?.indexPathsForVisibleItems[0]
        if indexPath?.item == collectionView(collectionView!, numberOfItemsInSection: 0) - 1 {
            indexPath = IndexPath(item: 5000, section: 0)
            collectionView?.scrollToItem(at: indexPath!, at: .left, animated: false)
        } else {
            indexPath = IndexPath(item: (indexPath?.item ?? 5000) + 1, section: 0)
            collectionView?.scrollToItem(at: indexPath!, at: .left, animated: true)
        }
    }
}

extension CarouselView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath)
        var imageView = cell.contentView.viewWithTag(11111) as? UIImageView
        if imageView == nil {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
            imageView?.tag = 11111
            imageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.contentView.addSubview(imageView!)
        }
        imageView!.image = UIImage(named: imageArr![indexPath.item % imageArr!.count])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
