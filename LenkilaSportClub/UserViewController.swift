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
        if user.count > 0{
            for i in 0...user.count-1 {
                userArray.append(user[i] as! User)
        }
        
        }
    }
    
    func genUserTable(){
        if userArray.count>0{
            for i in 0...userArray.count-1 {
                let button = UIButton(frame: CGRectMake(0,124+(40*CGFloat(i)),700,40))
                button.backgroundColor = UIColor.grayColor()
                scroll_view.addSubview(button)
            }

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
