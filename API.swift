//
//  API.swift
//  LenkilaClub
//
//  Created by Tanakorn on 9/15/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import Foundation
import Alamofire
class API{
    let ip_address = "http://128.199.227.19/"
    func addTempUser(_ user:User,success: @escaping (_ response: NSDictionary?) -> Void,failure: (_ error: NSError?) -> Void){
        let setting = Setting.allObjects()
//        let ec = "\((setting[0] as! Setting).sportClub_id)&userID=\(user.id)&nickName=\(user.nickName)&telephone=\(user.contact)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//        Alamofire.request(.POST, "\(self.ip_address)User/create?sportClubID=\(ec!)")
//            .validate()
//            .responseString { response in
//                print("Success: \(response.result.isSuccess)")
//                print("Response String: \(response.result.value)")
//                if !response.result.isSuccess{
//                    //                                    let temp = Temp()
//                    //                                    realm.beginWriteTransaction()
//                    //                                    temp.type = "create"
//                    //                                    temp.type_of_table = "user"
//                    //                                    temp.user_id = user.id
//                    //                                    realm.addObject(temp)
//                    //                                    try! realm.commitWriteTransaction()
//                }
//            }.responseJSON { response in
//                debugPrint(response.result.value)
//                if response.result.value == nil {
//                    
//                }else{
//                    debugPrint(response.result.value)
//                    print(response.result.isSuccess)
//                    success(response: response.result.value as! NSDictionary)
//                }
//        }
    }
    func updateTempUser(_ user:User,success: @escaping (_ response: NSDictionary?) -> Void,failure: (_ error: NSError?) -> Void){
        let setting = Setting.allObjects()
//        let ec = "\((setting[0] as! Setting).sportClub_id)&userID=\(user.id)&nickName=\(user.nickName)&telephone=\(user.contact)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed())
//        Alamofire.request(.POST, "\(self.ip_address)User/update?sportClubID=\(ec!)")
//            .validate()
//            .responseString { response in
//                print("Success: \(response.result.isSuccess)")
//                print("Response String: \(response.result.value)")
//                if !response.result.isSuccess{
//                    //                                    let temp = Temp()
//                    //                                    realm.beginWriteTransaction()
//                    //                                    temp.type = "create"
//                    //                                    temp.type_of_table = "user"
//                    //                                    temp.user_id = user.id
//                    //                                    realm.addObject(temp)
//                    //                                    try! realm.commitWriteTransaction()
//                }
//            }.responseJSON { response in
//                debugPrint(response.result.value)
//                if response.result.value == nil {
//                    
//                }else{
//                    debugPrint(response.result.value)
//                    print(response.result.isSuccess)
//                    success(response: response.result.value as! NSDictionary)
//                }
//        }
    }
}
