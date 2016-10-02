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
import Charts
class UserDetailListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,UIGestureRecognizerDelegate {
    var isPortrait = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
    var tab_trigger = false
    var add_trigger = false
    @IBOutlet weak var cons_vw_tab_width: NSLayoutConstraint!
    @IBOutlet var UserDetailTableView: UITableView!
    @IBOutlet var tap_gesture: UITapGestureRecognizer!
    var alert : SCLAlertView! = nil
    var userArray = [User]()
    var all_font = UIFont(name: "ThaiSansLite",size: 14)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Table Setting
        UserDetailTableView.separatorInset = UIEdgeInsets.zero
        UserDetailTableView.separatorInset.right = UserDetailTableView.separatorInset.left
        self.automaticallyAdjustsScrollViewInsets = false;
        self.tap_gesture.delegate = self
        self.UserDetailTableView.addGestureRecognizer(self.tap_gesture)
        self.isPortrait = true
    }
    @IBAction func btn_tab_action(_ sender: UIButton) {
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
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if tab_trigger{
            trigger_tab()
            return true
        }else{
            return false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
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
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIDevice.current.orientation{
        case .portrait:
            print("protrait")
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = true
            all_font = UIFont(name: "ThaiSansLite",size: 14)
            self.UserDetailTableView.reloadData()
        case .portraitUpsideDown:
            print("protrait_down")
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = true
            all_font = UIFont(name: "ThaiSansLite",size: 14)
            self.UserDetailTableView.reloadData()
        case .landscapeLeft:
            print("lanscape_left")
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = false
            all_font = UIFont(name: "ThaiSansLite",size: 16)
            self.UserDetailTableView.reloadData()
        case .landscapeRight:
            print("lanscape_right")
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = false
            all_font = UIFont(name: "ThaiSansLite",size: 16)
            self.UserDetailTableView.reloadData()
        default:
            print("default")
            if tab_trigger {
                trigger_tab()
            }
            isPortrait = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
            all_font = UIFont(name: "ThaiSansLite",size: 16)
            self.UserDetailTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(isPortrait){
            let v = UIView()
            v.backgroundColor = UIColor(red: 231/255, green: 230/255, blue: 231/255, alpha: 1.0)
            let no = UILabel(frame: CGRect(x: 2,y: 18, width: tableView.frame.width*0.09, height: 14))
            no.text = "ลำดับ"
            no.font = all_font
            no.textAlignment = .center
            
            let nickName = UILabel(frame: CGRect(x: no.frame.origin.x+tableView.frame.width*0.09,y: 18, width: tableView.frame.width*0.226, height: 14))
            nickName.text = "ชื่อเล่น"
            nickName.textAlignment = .center
            nickName.font = all_font
            
            let age = UILabel(frame: CGRect(x: (nickName.frame.origin.x+tableView.frame.width*0.226)+5,y: 18, width: tableView.frame.width*0.06, height: 14))
            age.text = "อายุ"
            age.textAlignment = .center
            age.font = all_font
            let freq = UILabel(frame: CGRect(x: age.frame.origin.x+tableView.frame.width*0.06,y: 18, width: tableView.frame.width*0.370, height: 14))
            freq.textAlignment = .center
            freq.text = "ช่วงที่มา"
            freq.font = all_font
            let contact = UILabel(frame: CGRect(x: freq.frame.origin.x+tableView.frame.width*0.370,y: 18, width: tableView.frame.width*0.260, height: 14))
            contact.text = "ติดต่อ"
            contact.textAlignment = .center
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
            let no = UILabel(frame: CGRect(x: 0,y: 18, width: tableView.frame.width*0.051, height: 14))
            no.text = "ลำดับ"
            no.font = all_font
            no.textAlignment = .center
            let name = UILabel(frame: CGRect(x: no.frame.origin.x+tableView.frame.width*0.051,y: 18, width: tableView.frame.width*0.151, height: 14))
            name.textAlignment = .center
            name.text = "ชื่อ-สกุล"
            name.font =  all_font
            let nickName = UILabel(frame: CGRect(x: name.frame.origin.x+tableView.frame.width*0.151,y: 18, width: tableView.frame.width*0.113, height: 14))
            nickName.text = "ชื่อเล่น"
            nickName.textAlignment = .center
            nickName.font = all_font
            let gender = UILabel(frame: CGRect(x: nickName.frame.origin.x+tableView.frame.width*0.113,y: 18, width: tableView.frame.width*0.035, height: 14))
            gender.text = "เพศ"
            gender.textAlignment = .center
            gender.font = all_font
            let age = UILabel(frame: CGRect(x: (gender.frame.origin.x+tableView.frame.width*0.035)+5,y: 18, width: tableView.frame.width*0.038, height: 14))
            age.text = "อายุ"
            age.textAlignment = .center
            age.font = all_font
            let work = UILabel(frame: CGRect(x: age.frame.origin.x+tableView.frame.width*0.038,y: 18, width: tableView.frame.width*0.142, height: 14))
            work.text = "ที่ทำงาน"
            work.textAlignment = .center
            work.font = all_font
            let seq = UILabel(frame: CGRect(x: work.frame.origin.x+tableView.frame.width*0.142,y: 18, width: tableView.frame.width*0.074, height: 14))
            seq.text = "ครั้งที่มา"
            seq.textAlignment = .center
            seq.font = all_font
            let freq = UILabel(frame: CGRect(x: seq.frame.origin.x+tableView.frame.width*0.074,y: 18, width: tableView.frame.width*0.185, height: 14))
            freq.textAlignment = .center
            freq.text = "ช่วงที่มา"
            freq.font = all_font
            let contact = UILabel(frame: CGRect(x: freq.frame.origin.x+tableView.frame.width*0.185,y: 18, width: tableView.frame.width*0.13, height: 14))
            contact.text = "ติดต่อ"
            contact.textAlignment = .center
            contact.font = all_font
            let price = UILabel(frame: CGRect(x: contact.frame.origin.x+tableView.frame.width*0.13,y: 18, width: tableView.frame.width*0.07, height: 14))
            price.text = "ราคา"
            price.textAlignment = .center
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(isPortrait){
            let cellIdentifier = "UserListPortrait"
            let currentIndex = (indexPath as NSIndexPath).row
            let userList = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
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
            if (indexPath as NSIndexPath).row % 2 == 1 {
                userList.backgroundColor = UIColor(red:232/255,green:233/255,blue:232/255,alpha:1.0)
            }else{
                userList.backgroundColor = UIColor.white
            }
            return userList
            
        }else{
            let cellIdentifier = "UserList"
            let currentIndex = (indexPath as NSIndexPath).row
            let userList = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
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
            if (indexPath as NSIndexPath).row % 2 == 1 {
                userList.backgroundColor = UIColor(red:232/255,green:233/255,blue:232/255,alpha:1.0)
            }else{
                userList.backgroundColor = UIColor.white
            }
            return userList
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add_user" {
            if let des = segue.destination as? EditUserDetailViewController {
                des.add_user = true
            }
        }else{
            if let des = segue.destination as? EditUserDetailViewController {
                let cell : UITableViewCell = sender as! UITableViewCell
                let indexPath = self.UserDetailTableView.indexPath(for: cell)
                des.name = self.userArray[((indexPath as NSIndexPath?)?.row)!].name
                des.nickName = self.userArray[((indexPath as NSIndexPath?)?.row)!].nickName
                des.gender = self.userArray[((indexPath as NSIndexPath?)?.row)!].gender
                des.age = Float(self.userArray[((indexPath as NSIndexPath?)?.row)!].age)
                des.workPlace = self.userArray[((indexPath as NSIndexPath?)?.row)!].workPlace
                des.playCount = self.userArray[((indexPath as NSIndexPath?)?.row)!].playCount
                des.freqPlay = userArray[((indexPath as NSIndexPath?)?.row)!].freqPlay
                des.contact = self.userArray[((indexPath as NSIndexPath?)?.row)!].contact
                des.price = self.userArray[((indexPath as NSIndexPath?)?.row)!].price
                des.id = self.userArray[((indexPath as NSIndexPath?)?.row)!].id
            }
        }
    }
    
}
