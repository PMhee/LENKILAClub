//
//  UserDetailListViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/9/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Realm
import SCLAlertView
class UserDetailListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UIGestureRecognizerDelegate {
    var isPortrait = UIDevice.currentDevice().orientation == .Portrait || UIDevice.currentDevice().orientation == .PortraitUpsideDown
    
    var tab_trigger = false
    var add_trigger = false
    @IBOutlet weak var cons_vw_tab_width: NSLayoutConstraint!
    @IBOutlet weak var cons_vw_tab_height: NSLayoutConstraint!
    @IBOutlet weak var vw_tab: UIView!
    @IBOutlet var UserDetailTableView: UITableView!
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    var alert : SCLAlertView! = nil
    var userArray = [User]()
    var all_font = UIFont(name: "ThaiSansLite",size: 14)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Table Setting
        UserDetailTableView.separatorInset = UIEdgeInsetsZero
        UserDetailTableView.separatorInset.right = UserDetailTableView.separatorInset.left
        self.automaticallyAdjustsScrollViewInsets = false;
        self.tap_gesture.delegate = self
        self.UserDetailTableView.addGestureRecognizer(self.tap_gesture)
    }
    @IBAction func btn_tab_action(sender: UIButton) {
        trigger_tab()
    }
    func trigger_tab(){
        var count = 0.0
        if !tab_trigger{
            //self.UserDetailTableView.userInteractionEnabled = false
            while(count <= 0.25){
                delay(count){
                    self.cons_vw_tab_width.constant += self.view.frame.width/13
                }
                count += 0.025
            }
        }else{
            //self.UserDetailTableView.userInteractionEnabled = true
            while(count <= 0.25){
                delay(count){
                    self.cons_vw_tab_width.constant -= self.view.frame.width/13
                }
                count += 0.025
            }
            
        }
        tab_trigger = !tab_trigger
    }
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if tab_trigger{
            trigger_tab()
            return true
        }else{
            return false
        }
    }
    @IBAction func btn_add_user_action(sender: UIButton) {
        performSegueWithIdentifier("add_user", sender: self)
//        add_trigger = true
//        let appearance = SCLAlertView.SCLAppearance(
//            showCloseButton: false
//        )
//        alert = SCLAlertView(appearance: appearance)
//        let nickName = alert.addTextField("ใส่ชื่อเล่น")
//        let contact = alert.addTextField("ใส่เบอร์โทรศัพท์")
//        alert.addButton("เพิ่ม", action: {
//            let realm = RLMRealm.defaultRealm()
//            let user = User()
//            user.id = String(self.userArray.count)
//            user.nickName = nickName.text!
//            let c = contact.text!
//            if nickName.text!.characters.count == 0 {
//                let warn = SCLAlertView()
//                warn.showError("ข้อมูลไม่ครบ", subTitle:"กรุณาใส่ชื่อเล่น",duration:3.0)
//            }else
//            if c.characters.count != 10 {
//                let warn = SCLAlertView()
//                warn.showError("ใส่เบอร์โทรศัพท์ผิดพลาด", subTitle:"เบอร์โทรศัพท์ไม่ถึง 10 หลัก",duration:3.0)
//            }else{
//                let cf = c.substringWithRange(Range<String.Index>(start: c.startIndex.advancedBy(0), end: (c.startIndex.advancedBy(3))))
//                let ce = c.substringWithRange(Range<String.Index>(start: c.startIndex.advancedBy(3), end: (c.endIndex.advancedBy(0))))
//                user.contact = cf+"-"+ce
//                realm.beginWriteTransaction()
//                realm.addObject(user)
//                try! realm.commitWriteTransaction()
//                self.userArray.removeAll()
//                self.gatherUser()
//            }
//        })
//        alert.showEdit("เพิ่มข้อมูลผู้เล่น", subTitle: "")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        gatherUser()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        if self.view.frame.width < 700 {
//            return UIInterfaceOrientationMask.Landscape
//        }else{
//            return UIInterfaceOrientationMask.Portrait
//        }
//    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    func gatherUser(){
        let user = User.allObjects()
        if user.count > 0 {
            for i in 0...user.count-1 {
                 userArray.append(user[i] as! User)
                print(user[i])
            }
        }
        UserDetailTableView.reloadData()
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIDevice.currentDevice().orientation{
        case .Portrait:
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = true
            all_font = UIFont(name: "ThaiSansLite",size: 14)
            self.UserDetailTableView.reloadData()
        case .PortraitUpsideDown:
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = true
            all_font = UIFont(name: "ThaiSansLite",size: 14)
            self.UserDetailTableView.reloadData()
        case .LandscapeLeft:
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = false
            all_font = UIFont(name: "ThaiSansLite",size: 16)
            self.UserDetailTableView.reloadData()
        case .LandscapeRight:
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = false
            all_font = UIFont(name: "ThaiSansLite",size: 16)
            self.UserDetailTableView.reloadData()
        default:
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = UIDevice.currentDevice().orientation == .Portrait || UIDevice.currentDevice().orientation == .PortraitUpsideDown
            all_font = UIFont(name: "ThaiSansLite",size: 16)
            self.UserDetailTableView.reloadData()
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(isPortrait){
            let v = UIView()
            v.backgroundColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0)
            let no = UILabel(frame: CGRectMake(0,18, tableView.frame.width*0.09, 14))
            no.text = "ลำดับ"
            no.font = all_font
            no.textAlignment = .Center
            
            let nickName = UILabel(frame: CGRectMake(no.frame.origin.x+tableView.frame.width*0.09,18, tableView.frame.width*0.226, 14))
            nickName.text = "ชื่อเล่น"
            nickName.textAlignment = .Center
            nickName.font = all_font
           
            let age = UILabel(frame: CGRectMake((nickName.frame.origin.x+tableView.frame.width*0.226)+5,18, tableView.frame.width*0.06, 14))
            age.text = "อายุ"
            age.textAlignment = .Center
            age.font = all_font
            let freq = UILabel(frame: CGRectMake(age.frame.origin.x+tableView.frame.width*0.06,18, tableView.frame.width*0.370, 14))
            freq.textAlignment = .Center
            freq.text = "ช่วงที่มา"
            freq.font = all_font
            let contact = UILabel(frame: CGRectMake(freq.frame.origin.x+tableView.frame.width*0.370,18, tableView.frame.width*0.260, 14))
            contact.text = "ติดต่อ"
            contact.textAlignment = .Center
            contact.font = all_font
            
            v.addSubview(contact)
            v.addSubview(freq)
            v.addSubview(age)
            v.addSubview(nickName)
            v.addSubview(no)
            return v

            
        }else{
            let v = UIView()
            v.backgroundColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0)
            let no = UILabel(frame: CGRectMake(0,18, tableView.frame.width*0.051, 14))
            no.text = "ลำดับ"
            no.font = all_font
            no.textAlignment = .Center
            let name = UILabel(frame: CGRectMake(no.frame.origin.x+tableView.frame.width*0.051,18, tableView.frame.width*0.151, 14))
            name.textAlignment = .Center
            name.text = "ชื่อ-สกุล"
            name.font =  all_font
            let nickName = UILabel(frame: CGRectMake(name.frame.origin.x+tableView.frame.width*0.151,18, tableView.frame.width*0.113, 14))
            nickName.text = "ชื่อเล่น"
            nickName.textAlignment = .Center
            nickName.font = all_font
            let gender = UILabel(frame: CGRectMake(nickName.frame.origin.x+tableView.frame.width*0.113,18, tableView.frame.width*0.035, 14))
            gender.text = "เพศ"
            gender.textAlignment = .Center
            gender.font = all_font
            let age = UILabel(frame: CGRectMake((gender.frame.origin.x+tableView.frame.width*0.035)+5,18, tableView.frame.width*0.038, 14))
            age.text = "อายุ"
            age.textAlignment = .Center
            age.font = all_font
            let work = UILabel(frame: CGRectMake(age.frame.origin.x+tableView.frame.width*0.038,18, tableView.frame.width*0.142, 14))
            work.text = "ที่ทำงาน"
            work.textAlignment = .Center
            work.font = all_font
            let seq = UILabel(frame: CGRectMake(work.frame.origin.x+tableView.frame.width*0.142,18, tableView.frame.width*0.074, 14))
            seq.text = "ครั้งที่มา"
            seq.textAlignment = .Center
            seq.font = all_font
            let freq = UILabel(frame: CGRectMake(seq.frame.origin.x+tableView.frame.width*0.074,18, tableView.frame.width*0.185, 14))
            freq.textAlignment = .Center
            freq.text = "ช่วงที่มา"
            freq.font = all_font
            let contact = UILabel(frame: CGRectMake(freq.frame.origin.x+tableView.frame.width*0.185,18, tableView.frame.width*0.13, 14))
            contact.text = "ติดต่อ"
            contact.textAlignment = .Center
            contact.font = all_font
            let price = UILabel(frame: CGRectMake(contact.frame.origin.x+tableView.frame.width*0.13,18, tableView.frame.width*0.07, 14))
            price.text = "ราคา"
            price.textAlignment = .Center
            price.font = all_font
            v.addSubview(price)
            v.addSubview(contact)
            v.addSubview(freq)
            v.addSubview(seq)
            v.addSubview(work)
            v.addSubview(age)
            v.addSubview(gender)
            v.addSubview(nickName)
            v.addSubview(name)
            v.addSubview(no)
            return v

        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(isPortrait){
            let cellIdentifier = "UserListPortrait"
            let currentIndex = indexPath.row
            let userList = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            let no = userList.viewWithTag(1) as! UILabel
            no.text = String(currentIndex+1)
            let nickName = userList.viewWithTag(2) as! UILabel
            nickName.text = userArray[currentIndex].nickName
            let age = userList.viewWithTag(3) as! UILabel
            age.text = String(userArray[currentIndex].age)
            let freqPlay = userList.viewWithTag(4) as! UILabel
            freqPlay.text = userArray[currentIndex].freqPlay
            let contact = userList.viewWithTag(5) as! UILabel
            contact.text = userArray[currentIndex].contact
            if indexPath.row % 2 == 1 {
                userList.backgroundColor = UIColor(red:232/255,green:233/255,blue:232/255,alpha:1.0)
            }else{
                userList.backgroundColor = UIColor.whiteColor()
            }
            return userList
            
        }else{
            let cellIdentifier = "UserList"
            let currentIndex = indexPath.row
            let userList = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            let no = userList.viewWithTag(1) as! UILabel
            no.text = String(currentIndex+1)
            let name = userList.viewWithTag(2) as! UILabel
            name.text = userArray[currentIndex].name
            let nickName = userList.viewWithTag(3) as! UILabel
            nickName.text = userArray[currentIndex].nickName
            let gender = userList.viewWithTag(4) as! UILabel
            gender.text = userArray[currentIndex].gender
            let age = userList.viewWithTag(5) as! UILabel
            age.text = String(userArray[currentIndex].age)
            let workPlace = userList.viewWithTag(6) as! UILabel
            workPlace.text = userArray[currentIndex].workPlace
            let playCount = userList.viewWithTag(7) as! UILabel
            playCount.text = String(userArray[currentIndex].playCount)
            let freqPlay = userList.viewWithTag(8) as! UILabel
            freqPlay.text = userArray[currentIndex].freqPlay
            let contact = userList.viewWithTag(9) as! UILabel
            contact.text = userArray[currentIndex].contact
            let price = userList.viewWithTag(10) as! UILabel
            price.text = String(userArray[currentIndex].price)
            if indexPath.row % 2 == 1 {
                userList.backgroundColor = UIColor(red:232/255,green:233/255,blue:232/255,alpha:1.0)
            }else{
                userList.backgroundColor = UIColor.whiteColor()
            }
            return userList
        }
        }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "add_user" {
            if let des = segue.destinationViewController as? EditUserDetailViewController {
                    des.add_user = true
            }
        }else{
        if let des = segue.destinationViewController as? EditUserDetailViewController {
            let cell : UITableViewCell = sender as! UITableViewCell
            let indexPath = self.UserDetailTableView.indexPathForCell(cell)
            des.name = self.userArray[(indexPath?.row)!].name
            des.nickName = self.userArray[(indexPath?.row)!].nickName
            des.gender = self.userArray[(indexPath?.row)!].gender
            des.age = Float(self.userArray[(indexPath?.row)!].age)
            des.workPlace = self.userArray[(indexPath?.row)!].workPlace
            des.playCount = self.userArray[(indexPath?.row)!].playCount
            des.freqPlay = self.userArray[(indexPath?.row)!].freqPlay
            des.contact = self.userArray[(indexPath?.row)!].contact
            des.price = self.userArray[(indexPath?.row)!].price
            des.id = self.userArray[(indexPath?.row)!].id
        }
        }
    }
    
}
