//
//  CycleView+Extension.swift
//  JYCyclePicture
//
//  Created by atom on 2017/3/6.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

enum ImageSource {
    case local(name: String)
    case network(urlStr: String)
}

enum ImageType {
    case local
    case network
}

struct ImageBox {
    var imageType: ImageType
    //var imageDetailArray = [String]()
    var imageArray: [ImageSource]
    init(imageType: ImageType, imageArray: [String]) {
        self.imageType = imageType
        self.imageArray = []
        //self.imageDetailArray = imageArray
        switch imageType {
            case .local:
                self.imageArray = imageArray.flatMap({ (str) -> ImageSource in
                    return ImageSource.local(name: str)
                })
                /*for str in imageArray {
                    self.imageArray.append(ImageSource.local(name: str))
                }*/
            case .network:
                self.imageArray = imageArray.flatMap({ (str) -> ImageSource in
                    return ImageSource.network(urlStr: str)
                })
                
                //print("\(netsource.debugDescription)")
                
                /*for str in imageArray {
                    self.imageArray.append(ImageSource.network(urlStr: str))
                }*/
        }
    }
        
    subscript (index: Int) -> ImageSource {
        get {
                return self.imageArray[index]
        }
    }
        
}

enum PageControlAliment {
    case centerBottom
    case leftBottom
    case rightBottom
}

protocol PageControlAlimentProtocol {
    var pageControlAliment: PageControlAliment { get set }
    func AdjustPageControlPlace(pageControl: UIPageControl)
}

extension PageControlAlimentProtocol where Self: UIView {
    
    func AdjustPageControlPlace(pageControl: UIPageControl) {
        if !pageControl.isHidden {
            switch self.pageControlAliment {
            case .centerBottom:
                let pageW = CGFloat(pageControl.numberOfPages * 15)
                let pageH: CGFloat = 20
                let pageX = self.center.x - 0.5 * pageW
                //这里用self.center.y计算肯定是错误的
                let pageY = self.bounds.height - pageH
                pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            case .leftBottom:
                let pageW = CGFloat(pageControl.numberOfPages * 15)
                let pageH: CGFloat = 20
                let pageX = self.bounds.origin.x
                let pageY = self.bounds.height - pageH
                pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            case .rightBottom:
                let pageW = CGFloat(pageControl.numberOfPages * 15)
                let pageH:CGFloat = 20
                let pageX = self.bounds.width - pageW
                let pageY = self.bounds.height - pageH
                pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            }
        }
    
    }
    
}

protocol EndlessCycleProtocol: class{
    var autoScroll: Bool { get set}
    var timeInterval: Double {get set}
    var timer: Timer? {get set}
    var needEndlessScroll: Bool {get set}
    var imageTimes: Int {get}
    var actualItemCount: Int {get set}
    
    func setupTimer(userInfo: AnyObject?)
    func showFirstImagePageInCollectionView(collectionView: UICollectionView)
}

extension EndlessCycleProtocol where Self: UIView {
    func autoChangePicture(collectionView: UICollectionView) {
        guard actualItemCount != 0 else {
            return
        }
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let currentIndex = Int(collectionView.contentOffset.x / flowLayout.itemSize.width)
        let nextIndex = currentIndex +  1
        if nextIndex >= actualItemCount {
            showFirstImagePageInCollectionView(collectionView: collectionView)
        } else {
            
            collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: UICollectionViewScrollPosition(rawValue: 0), animated: true)
            
        }
    }
    
    func showFirstImagePageInCollectionView(collectionView: UICollectionView) {
        guard actualItemCount != 0 else {
            return
        }
        
        var newIndex = 0
        if needEndlessScroll {
            newIndex = actualItemCount / 2
        }
        
        collectionView.scrollToItem(at: IndexPath(item: newIndex, section: 0), at: UICollectionViewScrollPosition(rawValue: 0), animated: true)
    }
    
}
















