//
//  FAQViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/28/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class FAQViewController: UIViewController, UITableViewDelegate,MFMailComposeViewControllerDelegate {
    
    @IBOutlet var faqTableView: UITableView!
    
    
    var questions = ["Q: what is Lenkila?",
                    "Q: How to use Lenkila?"]
    var answers = ["A: Lenkila is the Best.",
                   "A: just do it."]
    var setVisible = [Bool]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setVisible = [Bool](repeating: false, count: questions.count)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int{
        return questions.count+1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).section == questions.count) {

            //self.performSegueWithIdentifier("sendProblem", sender: self)
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
                
            } else {
                self.showSendMailErrorAlert()
                
            }

            faqTableView.reloadData()
        }else if((indexPath as NSIndexPath).row == 0) {
            setVisible[(indexPath as NSIndexPath).section] = !setVisible[(indexPath as NSIndexPath).section];
            faqTableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: UITableViewRowAnimation.fade)
        } else {
//            faqTableView.deselectRowAtIndexPath(indexPath, animated: false);
            setVisible[(indexPath as NSIndexPath).section] = !setVisible[(indexPath as NSIndexPath).section];
            faqTableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: UITableViewRowAnimation.fade)

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if((indexPath as NSIndexPath).section == questions.count){
            return 80
        }else{
            return 60
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }


    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if((indexPath as NSIndexPath).section == questions.count){
            let cell = faqTableView.dequeueReusableCell(withIdentifier: "ask", for: indexPath)
            cell.textLabel?.font = UIFont(name: "ThaiSansNeue-Bold", size: 32)
            cell.textLabel?.text = "แจ้งปัญหาการใช้งาน"
            cell.textLabel?.textColor=UIColor.white
            cell.textLabel?.textAlignment = .center
            
            //cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "question", for: indexPath)
            cell.textLabel!.font = UIFont(name: "ThaiSansLite",size: 24)
            if (setVisible[(indexPath as NSIndexPath).section] && (indexPath as NSIndexPath).row != 0) {
                cell.backgroundColor = UIColor(red:0.922,green:0.922,blue:0.922,alpha:1.00)
                
//                cell.textLabel?.textColor = UIColor.lightGrayColor()
                cell.textLabel!.text = answers[(indexPath as NSIndexPath).section]
                return cell
            } else {
                cell.backgroundColor = UIColor.white
                cell.textLabel!.text = questions[(indexPath as NSIndexPath).section]
                return cell
            }
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["ggeeksquad.d@gmail.com"])
        mailComposerVC.setSubject("Sending problems")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController!, didFinishWith result: MFMailComposeResult, error: Error!) {
        controller.dismiss(animated: true, completion: nil)
        
    }

}
