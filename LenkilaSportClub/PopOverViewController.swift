//
//  PopOverViewController.swift
//  LenkilaClub
//
//  Created by Tanakorn on 7/22/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class PopOverViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weekday: UILabel!
    
    @IBAction func btn_confitm_action(sender: UIButton) {
        self.performSegueWithIdentifier("select_date", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([.Day , .Month , .Year], fromDate: datePicker.date)
        components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: datePicker.date)
        var wd = components.weekday
        switch  wd {
        case 1:
            weekday.text = "อาทิตย์"
        case 2:
            weekday.text = "จันทร์"
        case 3:
            weekday.text = "อังคาร"
        case 4:
            weekday.text = "พุธ"
        case 5:
            weekday.text = "พฤหัสบดี"
        case 6:
            weekday.text = "ศุกร์"
        case 7:
            weekday.text = "เสาร์"
        default:
            print("")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "select_date" {
            if let des = segue.destinationViewController as? ScheduleViewController{
                let dateformat = NSDateFormatter()
                dateformat.dateStyle = NSDateFormatterStyle.FullStyle
                des.date = dateformat.stringFromDate(datePicker.date)
            }
        }
    }
    @IBAction func datePicker_change(sender: UIDatePicker) {
        let dateFormat = NSDateFormatter()
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([.Day , .Month , .Year], fromDate: sender.date)
        components = calendar.components([.Day , .Month , .Year,.NSWeekdayCalendarUnit], fromDate: sender.date)
        var wd = components.weekday
        switch  wd {
        case 1:
            weekday.text = "อาทิตย์"
        case 2:
            weekday.text = "จันทร์"
        case 3:
            weekday.text = "อังคาร"
        case 4:
            weekday.text = "พุธ"
        case 5:
            weekday.text = "พฤหัสบดี"
        case 6:
            weekday.text = "ศุกร์"
        case 7:
            weekday.text = "เสาร์"
        default:
            print("")
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
