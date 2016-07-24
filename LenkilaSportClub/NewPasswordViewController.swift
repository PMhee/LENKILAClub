//
//  NewPasswordViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 7/8/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class NewPasswordViewController: UIViewController,UITextFieldDelegate {
    @IBAction func next(sender: AnyObject) {
        self.performSegueWithIdentifier("confirmPassword", sender: self)
    }
    @IBOutlet var newPass: UITextField!

    @IBAction func backIcon(sender: AnyObject) {
        self.performSegueWithIdentifier("cancelChangePassword", sender: self)
    }
    @IBAction func backText(sender: AnyObject) {
        self.performSegueWithIdentifier("cancelChangePassword", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPass.delegate = self
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "confirmPassword" {
            if let des = segue.destinationViewController as? ConfirmPasswordViewController {
                des.newPassword = newPass.text!
            }
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
