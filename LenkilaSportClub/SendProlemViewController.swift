//
//  SendProlemViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/29/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class SendProlemViewController: UIViewController {
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func send(sender: AnyObject) {
        //TODO
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet var email: UITextField!
    @IBOutlet var problem: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        problem.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        problem.layer.borderWidth = 1.0
        problem.layer.cornerRadius = 5
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
