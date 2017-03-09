//
//  LocalPictureController.swift
//  JYCyclePicture
//
//  Created by atom on 2017/3/7.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class LocalPictureController: UIViewController {
    
    var cyclePictureView: CyclePictureView!
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
        let cyclePictureView = CyclePictureView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200))
        print("\(localImageArray)")
        //cyclePictureView.
        cyclePictureView.localImageArray = localImageArray
        cyclePictureView.backgroundColor = UIColor.red
        cyclePictureView.delegate = self
        cyclePictureView.timeInterval = 1
        cyclePictureView.pageControlAliment = .leftBottom
        self.view.addSubview(cyclePictureView)
        self.cyclePictureView = cyclePictureView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cyclePictureView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width - 100, height: 150)
        cyclePictureView.currentDotColor = UIColor.red
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
}
