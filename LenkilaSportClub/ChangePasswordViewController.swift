//
//  ChangePasswordViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 7/8/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import SCLAlertView
class ChangePasswordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var password_text: UITextField!
    let setting = Setting.allObjects()
    @IBAction func next(_ sender: AnyObject) {
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(red:255, green:255,blue:255, alpha: 0.3)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red:0, green:0,blue:0, alpha: 0.75)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let loading: UIActivityIndicatorView = UIActivityIndicatorView()
        loading.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        loading.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        loading.center = CGPoint(x: loadingView.frame.size.width / 2,
                                     y: loadingView.frame.size.height / 2);
        loadingView.addSubview(loading)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        loading.startAnimating()
        
        delay(1){
            loading.stopAnimating()
            container.removeFromSuperview()
//            if self.password_text.text! == (self.setting[0] as! Setting).passCode{
//            self.performSegueWithIdentifier("newPassword", sender: self)
//            }else{
//                let appearance = SCLAlertView.SCLAppearance(
//                    kTitleFont: UIFont(name: "ThaiSansLite", size: 20)!,
//                    kTextFont: UIFont(name: "ThaiSansLite", size: 16)!,
//                    kButtonFont: UIFont(name: "ThaiSansLite", size: 16)!,
//                    showCloseButton: true
//                )
//                let alert = SCLAlertView(appearance: appearance)
//                alert.showError("Error", subTitle: "The code does not exist please contact us")
//            }
            
            
        }
        
        

    }
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.password_text.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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



