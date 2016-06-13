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
class UserDetailListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var UserDetailTableView: UITableView!
    var userArray = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Table Setting
        UserDetailTableView.separatorInset = UIEdgeInsetsZero
        UserDetailTableView.separatorInset.right = UserDetailTableView.separatorInset.left
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    @IBAction func btn_add_user_action(sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        let nickName = alert.addTextField("ใส่ชื่อเล่น")
        let contact = alert.addTextField("ใส่เบอร์โทรศัพท์")
        alert.addButton("เพิ่ม", action: {
            let realm = RLMRealm.defaultRealm()
            let user = User()
            user.id = String(self.userArray.count)
            user.nickName = nickName.text!
            let c = contact.text!
            if nickName.text!.characters.count == 0 {
                let warn = SCLAlertView()
                warn.showError("ข้อมูลไม่ครบ", subTitle:"กรุณาใส่ชื่อเล่น",duration:3.0)
            }else
            if c.characters.count != 10 {
                let warn = SCLAlertView()
                warn.showError("ใส่เบอร์โทรศัพท์ผิดพลาด", subTitle:"เบอร์โทรศัพท์ไม่ถึง 10 หลัก",duration:3.0)
            }else{
                let cf = c.substringWithRange(Range<String.Index>(start: c.startIndex.advancedBy(0), end: (c.startIndex.advancedBy(3))))
                let ce = c.substringWithRange(Range<String.Index>(start: c.startIndex.advancedBy(3), end: (c.endIndex.advancedBy(0))))
                user.contact = cf+"-"+ce
                realm.beginWriteTransaction()
                realm.addObject(user)
                try! realm.commitWriteTransaction()
                self.userArray.removeAll()
                self.gatherUser()
                
            }
        })
        alert.showEdit("เพิ่มข้อมูลผู้เล่น", subTitle: "")
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        gatherUser()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if self.view.frame.width < 700 {
            return UIInterfaceOrientationMask.Landscape
        }else{
            return UIInterfaceOrientationMask.Portrait
        }
    }
    
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return userArray.count
        }
    }
    func gatherUser(){
        let user = User.allObjects()
        print(user.count)
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellIdentifier = "ColumnHeader"
            let header = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserDetailMainHeader
            header.selectionStyle = UITableViewCellSelectionStyle.None
            return header;
        } else {
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
