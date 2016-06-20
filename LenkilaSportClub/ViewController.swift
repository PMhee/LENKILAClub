
//  ViewController.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 5/19/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var username_textfield: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    @IBOutlet weak var signin_button: UIButton!
    @IBOutlet weak var facebook_button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signin_button.layer.cornerRadius = 5
        facebook_button.layer.cornerRadius = 5
        username_textfield.delegate = self
        password_textfield.delegate = self
        borderButtom(username_textfield)
        borderButtom(password_textfield)
        username_textfield.attributedPlaceholder = NSAttributedString(string:"username",attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        password_textfield.attributedPlaceholder = NSAttributedString(string:"password",attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string:"")
    }
    func borderButtom(textField:UITextField){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.whiteColor().CGColor
        border.frame = CGRect(x: 0, y: 39, width:  230, height: textField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }


}


