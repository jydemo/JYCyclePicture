//
//  CyclePictureView.swift
//  JYCyclePicture
//
//  Created by atom on 2017/3/6.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

protocol CyclePictureViewDelegate: class {
    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath)
}

class CyclePictureView: UIView, PageControlAlimentProtocol, EndlessCycleProtocol {

    var localImageArray: [String]? {
        didSet {
            self.imageBox = ImageBox(imageType: .local, imageArray: localImageArray!)
            self.reloadData()
        }
    }
    
    var imageURLArray: [String]? {
        didSet {
            self.imageBox = ImageBox(imageType: .network, imageArray: imageURLArray!)
            self.reloadData()
        }
    }
    
    var showPageControl: Bool = true {
        didSet {
            self.pageControl?.isHidden = !showPageControl
        }
    }
    var currentDotColor = UIColor.orange {
        didSet {
            self.pageControl?.currentPageIndicatorTintColor = currentDotColor
        }
    }
    var otherDotColor = UIColor.gray {
        didSet {
            self.pageControl?.pageIndicatorTintColor = otherDotColor
        }
    }
    
    var imageDetailArray: [String]?
    
    var pageControlAliment: PageControlAliment = .centerBottom
    var placeholderImage: UIImage?
    var pictureContentMode: UIViewContentMode?
    
    //以下属性和提示文字有关
    var detailLabelTextFont: UIFont?
    var detailLabelTextColor: UIColor?
    var detailLabelBackgroundColor: UIColor?
    var detailLabelHeight: CGFloat?
    var detailLabelAlpha: CGFloat?
    //代理
    weak var delegate: CyclePictureViewDelegate?
    //自动滚动
    var autoScroll: Bool = true {
        didSet{
            self.timer?.invalidate()
            if autoScroll {
                self.setupTimer(userInfo: nil)
            }
        }
    }
    //滚动间隔
    var timeInterval: Double = 2.0 {
        didSet {
            if autoScroll {
                self.setupTimer(userInfo: nil)
            
            }
        }
    }
    //无限滚动
    var needEndlessScroll = true {
        didSet {
            self.reloadData()
        }
    }
    
   
   ///存放照片资源
    fileprivate var imageBox: ImageBox?
    //实际item个数（无限滚动情况下）
    var actualItemCount = 0
    let imageTimes = 150
    var timer: Timer?
    fileprivate var pageControl: UIPageControl?
    fileprivate var collectionView: UICollectionView!
    fileprivate var cellID = "CyclePictureCell"
    fileprivate var flowLayout: UICollectionViewFlowLayout?
    
    /*init(frame: CGRect, localImageArray: [String]?) {
       super.init(frame: frame)
        self.setupCollectionView()
        if let array = localImageArray {
            self.localImageArray = array
            self.imageBox = ImageBox(imageType: .local, imageArray: array)
            self.reloadData()
        }
    }
    
    init(frame: CGRect, imageURLArray: [String]?) {
        super.init(frame: frame)
        self.setupCollectionView()
        if let array = imageURLArray {
            self.imageURLArray = array
            self.imageBox = ImageBox(imageType: .network, imageArray: array)
            self.reloadData()
        }
    }*/
    
    override init(frame: CGRect) {
    
        super.init(frame: frame)
        self.setupCollectionView()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        setupCollectionView()
    }
    
    
    override func awakeFromNib() {
        
    }
    
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.flowLayout = flowLayout
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CyclePictureCell.self, forCellWithReuseIdentifier: cellID)
        self.collectionView = collectionView
        self.addSubview(collectionView)
    }
    
    fileprivate func setupPageControl() {
        self.pageControl?.removeFromSuperview()
        guard self.imageBox!.imageArray.count > 1 else {
            return
        }
        if self.showPageControl {
            let pageControl = UIPageControl()
            pageControl.numberOfPages = self.imageBox!.imageArray.count
            pageControl.currentPageIndicatorTintColor = self.currentDotColor
            pageControl.pageIndicatorTintColor = self.otherDotColor
            pageControl.isUserInteractionEnabled = false
            self.addSubview(pageControl)
            self.pageControl = pageControl
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let _ = newSuperview else {
            self.timer?.invalidate()
            self.timer = nil
            return
        }
    }
    
    fileprivate func reloadData() {
        guard let imageBox = self.imageBox else {
            return
        }
        
        if imageBox.imageArray.count > 1 {
            self.actualItemCount = self.needEndlessScroll ? imageBox.imageArray.count * imageTimes : imageBox.imageArray.count
        } else {
            self.actualItemCount = 1
        }
        
        self.collectionView.reloadData()
        self.setupPageControl()
        if self.autoScroll {
            self.setupTimer(userInfo: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.flowLayout?.itemSize = self.frame.size
        self.collectionView.frame = self.bounds
        self.collectionView.contentInset = .zero
        self.showFirstImagePageInCollectionView(collectionView: self.collectionView)
        guard let pageControl = self.pageControl else {
            return
        }
        
        self.AdjustPageControlPlace(pageControl: pageControl)
    }
    
    func setupTimer(userInfo: AnyObject?) {
        self.timer?.invalidate()
        let timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(changePicture), userInfo: userInfo, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        self.timer = timer
    }
    
    @objc fileprivate func changePicture() {
        self.autoChangePicture(collectionView: self.collectionView)
    }

}
extension CyclePictureView {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.autoScroll {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll {
            self.setupTimer(userInfo: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let pageControl = self.pageControl else {
            return
        }
        //这里很关键 图片滚动和pagecontrol变化currentPage
        let offsetIndex = self.collectionView.contentOffset.x / self.flowLayout!.itemSize.width
        //let tr = offsetIndex.truncatingRemainder(dividingBy: CGFloat(self.imageBox!.imageArray.count))
        let currentIndex = Int(offsetIndex.truncatingRemainder(dividingBy: CGFloat(self.imageBox!.imageArray.count)) + 0.5)
        //print("--<\(offsetIndex)>-<\(self.collectionView.contentOffset.x)-<\(tr)>->\(currentIndex)")
        pageControl.currentPage = currentIndex == self.imageBox!.imageArray.count ? 0 : currentIndex
    }
}

extension CyclePictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.actualItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CyclePictureCell
        
        if let placeholderImage = self.placeholderImage, let pictrueContentMode = self.pictureContentMode {
            cell.placeholderImage = placeholderImage
            cell.pictureContentMode = pictrueContentMode
        }
        
        if let imageBox = self.imageBox {
            let actualItemIndex = indexPath.item % imageBox.imageArray.count
            cell.imageSource = imageBox[actualItemIndex]
        }
        
        if let array = self.imageDetailArray {
            
            let actualItemindex = indexPath.item % array.count
            cell.imageDetail = array[actualItemindex]
        }
        
        if let font = self.detailLabelTextFont, let color = self.detailLabelTextColor, let backgroundColor = self.detailLabelBackgroundColor, let height = self.detailLabelHeight, let alpha = self.detailLabelAlpha {
            cell.detailLabelTextFont = font
            cell.detailLabelTextColor = color
            cell.detailLabelBackgroundColor = backgroundColor
            cell.detailLabelHeight = height
            cell.detailLabelAlpha = alpha
        
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageBox = self.imageBox else {
            return
        }
        self.delegate?.cyclePictureView(cyclePictureView: self, didSelectItemAtIndexPath: IndexPath(item: indexPath.item % imageBox.imageArray.count, section: indexPath.section))
    }
}
