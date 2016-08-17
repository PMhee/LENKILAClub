//
//  SetFieldViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 7/24/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import SCLAlertView
class SetFieldViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableview: UITableView!
    var promotion_all = [Promotion]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        gatherAllPromotion()
        self.tableview.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func gatherAllPromotion(){
        let promotion = Promotion.allObjects()
        for i in 0..<promotion.count{
            promotion_all.append(promotion[i] as! Promotion)
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotion_all.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let name = cell.viewWithTag(1) as! UILabel
        name.text = promotion_all[indexPath.row].promotion_name
        let price  = cell.viewWithTag(2) as! UILabel
        if promotion_all[indexPath.row].promotion_type == "price"{
            price.text = "ลด \(promotion_all[indexPath.row].promotion_discount_price) บาท"
        }else{
            price.text = "ลด \(promotion_all[indexPath.row].promotion_diccount_percent) %"
        }
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
