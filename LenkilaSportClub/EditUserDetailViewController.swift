//
//  EditUserDetailViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 6/10/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class EditUserDetailViewController: UIViewController {
    var name : String! = nil
    var nickName : String! = nil
    var gender : String! = nil
    var age : Int! = nil
    var workPlace : String! = nil
    var playCount : Int! = nil
    var freqPlay : String! = nil
    var contact : String! = nil
    var price : Int! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.nickName)
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
