//
//  CyclePictureCell.swift
//  JYCyclePicture
//
//  Created by atom on 2017/3/7.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit
import Kingfisher

class CyclePictureCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(detailLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        if let _ = self.imageDetail {
            let labelX: CGFloat = 0
            let labelH: CGFloat = detailLabelHeight
            let labelW: CGFloat = self.frame.height - labelX
            let labelY: CGFloat = self.frame.height - labelH
            detailLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            detailLabel.font = detailLabelTextFont
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var placeholderImage: UIImage?
    var imageDetail: String? {
        didSet {
            detailLabel.isHidden = false
            detailLabel.text = imageDetail
        }
    }
    var detailLabelTextFont = UIFont(name: "Helvetica-Bold", size: 18)! {
        didSet {
            detailLabel.font = detailLabelTextFont
        }
    }
    
    var detailLabelTextColor = UIColor.white {
        didSet {
            detailLabel.textColor = detailLabelTextColor
        }
    }
    var detailLabelBackgroundColor = UIColor.clear {
        didSet {
            detailLabel.backgroundColor = detailLabelBackgroundColor
        }
    }
    var detailLabelHeight: CGFloat = 60 {
        didSet {
            detailLabel.frame.size.height = detailLabelHeight
        }
    }
    var detailLabelAlpha: CGFloat = 1 {
        didSet {
            detailLabel.alpha = detailLabelAlpha
        }
    }
    var pictureContentMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            imageView.contentMode = pictureContentMode
        }
    }
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var detailLabel: UILabel = {
        let detailLabel = UILabel()
        detailLabel.textColor = UIColor.white
        detailLabel.shadowColor = UIColor.gray
        detailLabel.numberOfLines = 0
        detailLabel.backgroundColor = UIColor.clear
        detailLabel.isHidden = true
        return detailLabel
    }()
    
    var imageSource: ImageSource = ImageSource.local(name: "") {
        didSet {
            switch imageSource {
                case .local(let imgName):
                    self.imageView.image = UIImage(named: imgName)
                case .network(let imgURL):
                    let encodeString = imgURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                    self.imageView.kf.setImage(with: URL(string: encodeString!)!, placeholder: placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
    
    
}
