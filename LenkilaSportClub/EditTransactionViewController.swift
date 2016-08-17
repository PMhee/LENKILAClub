//
//  EditTransactionViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 8/16/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
class EditTransactionViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {
    var user_name:String!
    var schedule = Schedule()
    @IBOutlet weak var cons_top: NSLayoutConstraint!
    @IBOutlet weak var profile_pic: UIImageView!
    @IBOutlet weak var tf_money: UITextField!
    @IBOutlet weak var tf_promotion: UITextField!
    @IBOutlet weak var lb_promotion: UILabel!
    @IBOutlet weak var lb_money: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gesture: UITapGestureRecognizer!
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    var inEdit = false
    @IBAction func tf_money_begin(sender: UITextField) {
        inEdit = true
        var range: Range<String.Index> = self.tf_money.text!.rangeOfString(" ")!
        var index: Int = self.tf_money.text!.startIndex.distanceTo(range.startIndex)
        sender.text = self.tf_money.text!.substringWithRange(Range<String.Index>(start:self.tf_money.text!.startIndex.advancedBy(0), end: self.tf_money.text!.startIndex.advancedBy(index)))
    }
    @IBAction func tf_money_end(sender: UITextField) {
        lb_money.text = String(self.realPrice-Double(tf_promotion.text!)!)+" บาท"
        sender.text = sender.text!+" บาท"
    }
    @IBAction func btn_confirm(sender: UIButton) {
        let realm = RLMRealm.defaultRealm()
        var id = ""
        var time = ""
        realm.beginWriteTransaction()
        var range: Range<String.Index> = self.lb_money.text!.rangeOfString(" ")!
        var index: Int = self.lb_money.text!.startIndex.distanceTo(range.startIndex)
        self.realPrice = Double(self.lb_money.text!.substringWithRange(Range<String.Index>(start:self.lb_money.text!.startIndex.advancedBy(0), end: self.lb_money.text!.startIndex.advancedBy(index))))
        schedule.price = realPrice
        schedule.already_paid = true
        let user = User.allObjects()
        let freq_play = FreqPlay()
        if user.count > 0 {
            for j in 0...user.count-1 {
                let u = user[j] as! User
                if u.id == schedule.userID{
                    id = u.id
                    u.playCount += 1
                    time = schedule.time
                    freq_play.userID = id
                    freq_play.freq_play = time
                    let range = schedule.date.rangeOfString(",")!
                    let index = schedule.date.startIndex.distanceTo(range.startIndex)
                    freq_play.day = schedule.date.substringWithRange(Range<String.Index>(start: schedule.date.startIndex.advancedBy(0), end: schedule.date.startIndex.advancedBy(index)))
                    realm.addObject(freq_play)
                }
            }
        }
        try! realm.commitWriteTransaction()
        self.performSegueWithIdentifier("confirm", sender: self)
    }
    var realPrice:Double!
    var editPromotion = false
    @IBAction func tf_promotion_edit(sender: UITextField) {
        cons_top.constant -= 120
        inEdit = true
        tf_promotion.text = ""
        var range: Range<String.Index> = self.tf_money.text!.rangeOfString(" ")!
        var index: Int = self.tf_money.text!.startIndex.distanceTo(range.startIndex)
        self.realPrice = Double(self.tf_money.text!.substringWithRange(Range<String.Index>(start:self.tf_money.text!.startIndex.advancedBy(0), end: self.tf_money.text!.startIndex.advancedBy(index))))
    }
    @IBAction func tf_promotion_end(sender: UITextField) {
        cons_top.constant += 120
        lb_money.text = String(self.realPrice-Double(tf_promotion.text!)!)+" บาท"
        editPromotion = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tf_money.delegate = self
        self.tf_promotion.delegate = self
        profile_pic.layer.cornerRadius = 55
        profile_pic.layer.masksToBounds = true
        tf_money.text = String(schedule.price)+" บาท"
        lb_promotion.text = schedule.promotion
        name.text = user_name
        tf_money.keyboardType = UIKeyboardType.NumberPad
        tf_promotion.keyboardType = UIKeyboardType.NumberPad
        var range: Range<String.Index> = self.tf_money.text!.rangeOfString(" ")!
        var index: Int = self.tf_money.text!.startIndex.distanceTo(range.startIndex)
        self.realPrice = Double(self.tf_money.text!.substringWithRange(Range<String.Index>(start:self.tf_money.text!.startIndex.advancedBy(0), end: self.tf_money.text!.startIndex.advancedBy(index))))
        lb_date.text = schedule.date
        lb_time.text = "เวลา "+schedule.time
        lb_money.text = String(self.realPrice-Double(tf_promotion.text!)!)+" บาท"
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if inEdit{
            inEdit = false
            tf_promotion.resignFirstResponder()
            tf_money.resignFirstResponder()
            return true
        }else{
            return false
        }
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
