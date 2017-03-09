//
//  TestTableViewController.swift
//  JYCyclePicture
//
//  Created by atom on 2017/3/8.
//  Copyright © 2017年 atom. All rights reserved.
//

import UIKit

class TestTableViewController: UITableViewController {
    
    
    var dataArray: NSArray? = {
        let path = Bundle.main.path(forResource: "Image.plist", ofType: nil)!
        var array = NSArray(contentsOfFile: path)
        return array
    }()
    var imageURLArray = [String]()
    var imageDetailArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0..<dataArray!.count {
            let dict = dataArray![i] as! [String: AnyObject]
            imageURLArray.append(dict["image"] as! String)
            imageDetailArray.append(dict["title"] as! String)
        }
        cyclePictureView.imageURLArray = imageURLArray
        cyclePictureView.imageDetailArray = imageDetailArray
        self.tableView.tableHeaderView = cyclePictureView
    }
    
    private lazy var cyclePictureView: CyclePictureView = {
        let cyclePictureView = CyclePictureView(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 200))
        cyclePictureView.backgroundColor = UIColor.red
        cyclePictureView.timeInterval = 1
        cyclePictureView.pageControlAliment = .centerBottom
        return cyclePictureView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "test\(indexPath.row)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
