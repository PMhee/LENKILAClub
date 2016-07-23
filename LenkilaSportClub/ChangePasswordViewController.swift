//
//  ChangePasswordViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 7/8/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import SCLAlertView
class ChangePasswordViewController: UIViewController {
    
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var password_text: UITextField!
    let setting = Setting.allObjects()
    @IBAction func next(sender: AnyObject) {
        var container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(red:255, green:255,blue:255, alpha: 0.3)
        
        var loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red:0, green:0,blue:0, alpha: 0.75)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        var loading: UIActivityIndicatorView = UIActivityIndicatorView()
        loading.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        loading.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        loading.center = CGPointMake(loadingView.frame.size.width / 2,
                                     loadingView.frame.size.height / 2);
        loadingView.addSubview(loading)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        loading.startAnimating()
        
        delay(1){
            loading.stopAnimating()
            container.removeFromSuperview()
            if self.password_text.text! == (self.setting[0] as! Setting).passCode{
            self.performSegueWithIdentifier("newPassword", sender: self)
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
        
        

    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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



