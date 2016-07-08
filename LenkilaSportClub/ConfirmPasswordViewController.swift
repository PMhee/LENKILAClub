//
//  ConfirmPasswordViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 7/8/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class ConfirmPasswordViewController: UIViewController {
    
    var newPassword = String()

    @IBAction func backText(sender: AnyObject) {
        self.performSegueWithIdentifier("editNewPassword", sender: self)
    }
    @IBAction func backIcon(sender: AnyObject) {
        self.performSegueWithIdentifier("editNewPassword", sender: self)
    }
    
    @IBOutlet var confirmPass: UITextField!
    @IBAction func save(sender: AnyObject) {
        if(confirmPass.text == newPassword){
            self.performSegueWithIdentifier("savePassword", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
