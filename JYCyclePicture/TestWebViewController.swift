//
//  TestWebViewController.swift
//  JYCyclePicture
//
//  Created by atom on 2017/3/8.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class TestWebViewController: UIViewController {
    
    @IBOutlet weak var cyclePictureView: CyclePictureView!
    
    //这里有一个使用storyboard自动布局会导致pageControl控件位置不明的错误
    var dataArray: NSArray? = {
        let path = Bundle.main.path(forResource: "Image.plist", ofType: nil)!
        var array = NSArray(contentsOfFile: path)
        return array
    }()
    var imageURLArray = [String]()
    var imageDetailArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for i in 0..<dataArray!.count {
            let dict = dataArray![i] as! [String: AnyObject]
            imageURLArray.append(dict["image"] as! String)
            imageDetailArray.append(dict["title"] as! String)
        }
        cyclePictureView.imageURLArray = imageURLArray
        cyclePictureView.imageDetailArray = imageDetailArray
        cyclePictureView.autoScroll = true
        cyclePictureView.placeholderImage = UIImage(named: "302")
        cyclePictureView.timeInterval = 1
        cyclePictureView.detailLabelBackgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
