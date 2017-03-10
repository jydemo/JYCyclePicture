//
//  LocalPictureController.swift
//  JYCyclePicture
//
//  Created by atom on 2017/3/7.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class LocalPictureController: UIViewController {
    
    var localImageArray: [String] = {
        var array: [String] = []
        for i in 1..<6 {
            array.append("\(i)")
        }
        return array
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.addSubview(otherCyclePictureView)
    }
    
    fileprivate lazy var otherCyclePictureView: CyclePictureView = {[unowned self] in
        let cyclePictureView = CyclePictureView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200))
        //cyclePictureView.
        cyclePictureView.localImageArray = self.localImageArray
        cyclePictureView.backgroundColor = UIColor.red
        cyclePictureView.delegate = self
        cyclePictureView.dataSource = self
        cyclePictureView.timeInterval = 1
        cyclePictureView.pageControlAliment = .leftBottom
        return cyclePictureView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.otherCyclePictureView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width - 100, height: 150)
        otherCyclePictureView.currentDotColor = UIColor.red
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LocalPictureController: CyclePictureViewDelegate {
    func cyclePictureView(cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath) {
        
    }
    
    func cyclePictureView(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> CyclePictureCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CyclePictureCell
        
        /*if let placeholderImage = self.placeholderImage, let pictrueContentMode = self.pictureContentMode {
            cell.placeholderImage = placeholderImage
            cell.pictureContentMode = pictrueContentMode
        }*/
        
        if let imageBox = self.otherCyclePictureView.imageBox {
            let actualItemIndex = indexPath.item % imageBox.imageArray.count
            cell.imageSource = imageBox[actualItemIndex]
        }
        
        if let array = self.otherCyclePictureView.imageDetailArray {
            
            let actualItemindex = indexPath.item % array.count
            cell.imageDetail = array[actualItemindex]
        }
        
        /*if let font = self.detailLabelTextFont, let color = self.detailLabelTextColor, let backgroundColor = self.detailLabelBackgroundColor, let height = self.detailLabelHeight, let alpha = self.detailLabelAlpha {
            cell.detailLabelTextFont = font
            cell.detailLabelTextColor = color
            cell.detailLabelBackgroundColor = backgroundColor
            cell.detailLabelHeight = height
            cell.detailLabelAlpha = alpha
            
        }*/
        
        return cell
    }
}
extension LocalPictureController: CyclePictureViewDataSource {
    
    func numberOfItem(in collection: UICollectionView) -> Int {
        return self.otherCyclePictureView.actualItemCount
    }


}
