//
//  AddTableViewController.swift
//  LenkilaSportClub
//
//  Created by Tanakorn on 6/1/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class AddTableViewController: UIViewController,UITextFieldDelegate {
    var field : String!
    var date : NSDate!
    var time : String!
    var name : String!
    var price : String!
    var rep : String!
    @IBOutlet weak var tf_field: UITextField!
    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var tf_time: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_price: UITextField!
    @IBOutlet weak var tf_repeat: UITextField!
    @IBOutlet weak var line_field: UIView!
    @IBOutlet weak var line_date: UIView!
    @IBOutlet weak var line_time: UIView!
    @IBOutlet weak var line_name: UIView!
    @IBOutlet weak var line_repeat: UIView!
    @IBOutlet weak var line_price: UIView!
    @IBOutlet weak var btn_inc_30: UIButton!
    @IBOutlet weak var btn_dec_30: UIButton!
    @IBOutlet weak var btn_green: UIButton!
    @IBOutlet weak var btn_gray: UIButton!
    @IBOutlet weak var btn_dark_blue: UIButton!
    @IBOutlet weak var btn_blue: UIButton!
    @IBOutlet weak var btn_yellow: UIButton!
    @IBOutlet weak var btn_orange: UIButton!
    @IBOutlet weak var btn_pink: UIButton!
    @IBOutlet weak var btn_red: UIButton!
    @IBOutlet weak var top_space: NSLayoutConstraint!
    @IBAction func tf_date_action(sender: UITextField) {
        line_date.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_time_action(sender: UITextField) {
        line_time.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_name_action(sender: UITextField) {
        line_name.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_price_action(sender: UITextField) {
        line_price.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
    }
    @IBAction func tf_repeat_action(sender: UITextField) {
        line_repeat.backgroundColor = UIColor(red: 16/255, green: 118/255, blue: 152/255, alpha: 1.0)
        top_space.constant -= 20
    }
    @IBAction func tf_repeat_end(sender: UITextField) {
        top_space.constant += 20
    }
    @IBAction func btn_add_action(sender: AnyObject) {
        self.performSegueWithIdentifier("back_to_schedule", sender: self)
    }
    @IBAction func btn_cancel_action(sender: AnyObject) {
        self.performSegueWithIdentifier("back_to_schedule", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        genButton()
        genDelegate()
        genTextField()
        tf_name.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    func genDelegate(){
        tf_field.delegate = self
        tf_date.delegate = self
        tf_time.delegate = self
        tf_name.delegate = self
        tf_price.delegate = self
        tf_repeat.delegate = self
    }
    func genTextField(){
        tf_field.text = self.field
        let format = NSDateFormatter()
        format.dateStyle = NSDateFormatterStyle.FullStyle
        tf_date.text = format.stringFromDate(self.date)
        tf_time.text = self.time
        tf_repeat.text = self.rep
        tf_price.text = self.price
    }
    func genButton(){
        btn_dec_30.layer.cornerRadius = 15
        btn_inc_30.layer.cornerRadius = 15
        btn_red.layer.cornerRadius = 5
        btn_blue.layer.cornerRadius = 5
        btn_gray.layer.cornerRadius = 5
        btn_pink.layer.cornerRadius = 5
        btn_green.layer.cornerRadius = 5
        btn_orange.layer.cornerRadius = 5
        btn_yellow.layer.cornerRadius = 5
        btn_dark_blue.layer.cornerRadius = 5
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        line_field.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_date.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_time.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_name.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        line_repeat.backgroundColor = UIColor(red: 232/255, green: 230/255, blue: 231/255, alpha: 1.0)
        textField.resignFirstResponder()
        return true
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
