//
//  UserDetailListViewController.swift
//  LenkilaClub
//
//  Created by Peeranut Mahatham on 6/9/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit

class UserDetailListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var UserDetailTableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Table Setting
        UserDetailTableView.separatorInset = UIEdgeInsetsZero
        UserDetailTableView.separatorInset.right = UserDetailTableView.separatorInset.left
        self.automaticallyAdjustsScrollViewInsets = false;

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 0 {
            return 0 //return number of user. Not zero!
        }
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellIdentifier = "ColumnHeader"
            let header = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserDetailMainHeader
            header.selectionStyle = UITableViewCellSelectionStyle.None
            return header;
        } else {
            let cellIdentifier = "UserList"
            let currentIndex = indexPath.row
            let userList = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserDetailListCell
            
            //Configure cells
            
            //Example
//            let name1: String = ArrayName[currentIndex]
//            userList.name.text = name1.toString()

            
            return userList
        }
    }


}
