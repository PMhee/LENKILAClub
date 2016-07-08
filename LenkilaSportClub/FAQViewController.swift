//
//  FAQViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/28/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import Foundation

class FAQViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var faqTableView: UITableView!
    
    
    var questions = ["Q: what is Lenkila?",
                    "Q: How to use Lenkila?"]
    var answers = ["A: Lenkila is the Best.",
                   "A: just do it."]
    var setVisible = [Bool]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setVisible = [Bool](count: questions.count, repeatedValue: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return questions.count+1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == questions.count){
            return 1
        } else {
            if(setVisible[section]){
                return 2
            }else{
                return 1
            }

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == questions.count) {
//            faqTableView.deselectRowAtIndexPath(indexPath, animated: false);
//            return;
            self.performSegueWithIdentifier("sendProblem", sender: self)
            faqTableView.reloadData()
        }else if(indexPath.row == 0) {
            setVisible[indexPath.section] = !setVisible[indexPath.section];
            faqTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        } else {
//            faqTableView.deselectRowAtIndexPath(indexPath, animated: false);
            setVisible[indexPath.section] = !setVisible[indexPath.section];
            faqTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)

        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == questions.count){
            return 80
        }else{
            return 60
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == questions.count){
            let cell = faqTableView.dequeueReusableCellWithIdentifier("ask", forIndexPath: indexPath)
            cell.textLabel?.font = UIFont(name: "ThaiSansNeue-Bold", size: 32)
            cell.textLabel?.text = "แจ้งปัญหาการใช้งาน"
            cell.textLabel?.textColor=UIColor.whiteColor()
            cell.textLabel?.textAlignment = .Center
            
            //cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("question", forIndexPath: indexPath)
            cell.textLabel!.font = UIFont(name: "ThaiSansLite",size: 24)
            if (setVisible[indexPath.section] && indexPath.row != 0) {
                cell.backgroundColor = UIColor(red:0.922,green:0.922,blue:0.922,alpha:1.00)
                
//                cell.textLabel?.textColor = UIColor.lightGrayColor()
                cell.textLabel!.text = answers[indexPath.section]
                return cell
            } else {
                cell.backgroundColor = UIColor.whiteColor()
                cell.textLabel!.text = questions[indexPath.section]
                return cell
            }
        }
    }

}
