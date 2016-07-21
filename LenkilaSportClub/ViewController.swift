
//  ViewController.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 5/19/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import SCLAlertView
class ViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var placeholder: UILabel!
    @IBOutlet weak var username_textfield: UITextField!
    @IBOutlet weak var cons_verticle: NSLayoutConstraint!
    
    @IBAction func sign_in_action(sender: UIButton) {
        if username_textfield.text! == "Geeksquadconsulting"{
        performSegueWithIdentifier("signIn", sender: self)
        }else{
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
                kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
                kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
                showCloseButton: true
            )
            let alert = SCLAlertView(appearance: appearance)
            alert.showError("Error", subTitle: "The code does not exist please contact us")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        username_textfield.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string:"")
        textField.text = ""
        placeholder.text = ""
        cons_verticle.constant += 50
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        cons_verticle.constant -= 50
        if textField.text! == ""{
            placeholder.text = "Enter Code"
        }
        return true
    }

}


