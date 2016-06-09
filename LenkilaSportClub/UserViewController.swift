//
//  UserViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 6/3/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//
import UIKit
import Realm

class UserViewController: UIViewController {
    
    @IBOutlet weak var scroll_view: UIScrollView!
    var userArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        gatherUser()
        genUserTable()
    }
    
    func gatherUser(){
        let user = User.allObjects()
<<<<<<< HEAD
        if user.count > 0 {
            for i in 0...user.count-1 {
                userArray.append(user[i] as! User)
            }
=======
        if user.count > 0{
            for i in 0...user.count-1 {
                userArray.append(user[i] as! User)
        }
        
>>>>>>> f46588e21cf03e03ffbb8b331f2443ed9487e2c5
        }
    }
    
    func genUserTable(){
<<<<<<< HEAD
        if userArray.count > 0 {
            for i in 0...userArray.count-1 {
                let button = UIButton(frame: CGRectMake(0,124+(40*CGFloat(i)),700,40))
                if i % 2 == 1 {
                    button.backgroundColor = UIColor.whiteColor()
                }else{
                button.backgroundColor = UIColor(red: 232/255, green: 233/255, blue: 232/255, alpha: 1.0)
                }
                scroll_view.addSubview(button)
            }
=======
        if userArray.count>0{
            for i in 0...userArray.count-1 {
                let button = UIButton(frame: CGRectMake(0,124+(40*CGFloat(i)),700,40))
                button.backgroundColor = UIColor.grayColor()
                scroll_view.addSubview(button)
            }

>>>>>>> f46588e21cf03e03ffbb8b331f2443ed9487e2c5
        }
        
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
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
