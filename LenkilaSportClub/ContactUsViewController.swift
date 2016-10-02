//
//  ContactUsViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/29/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    @IBAction func callNon(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Confirm Action", message: nil, preferredStyle: .actionSheet)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            UIApplication.shared.openURL(URL(string: "tel://0992850130")!)
        }
        let callAction = UIAlertAction(title: "Call 0992850130", style: .default, handler:callActionHandler)
        alertController.addAction(callAction)
        
        let copyActionHandler = { (action:UIAlertAction!) -> Void in
            UIPasteboard.general.string = "0992850130"
        }
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler:copyActionHandler)
        alertController.addAction(copyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func callNonPic(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Confirm Action", message: nil, preferredStyle: .actionSheet)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            UIApplication.shared.openURL(URL(string: "tel://0992850130")!)
        }
        let callAction = UIAlertAction(title: "Call 0992850130", style: .default, handler:callActionHandler)
        alertController.addAction(callAction)
        
        let copyActionHandler = { (action:UIAlertAction!) -> Void in
            UIPasteboard.general.string = "0992850130"
        }
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler:copyActionHandler)
        alertController.addAction(copyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func callJump(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Confirm Action", message: nil, preferredStyle: .actionSheet)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            UIApplication.shared.openURL(URL(string: "tel://0837570982")!)
        }
        let callAction = UIAlertAction(title: "Call 0837570982", style: .default, handler:callActionHandler)
        alertController.addAction(callAction)
        
        let copyActionHandler = { (action:UIAlertAction!) -> Void in
            UIPasteboard.general.string = "0837570982"
        }
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler:copyActionHandler)
        alertController.addAction(copyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func callJumpPic(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Confirm Action", message: nil, preferredStyle: .actionSheet)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            UIApplication.shared.openURL(URL(string: "tel://0837570982")!)
        }
        let callAction = UIAlertAction(title: "Call 0837570982", style: .default, handler:callActionHandler)
        alertController.addAction(callAction)
        
        let copyActionHandler = { (action:UIAlertAction!) -> Void in
            UIPasteboard.general.string = "0837570982"
        }
        let copyAction = UIAlertAction(title: "Copy", style: .default, handler:copyActionHandler)
        alertController.addAction(copyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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
