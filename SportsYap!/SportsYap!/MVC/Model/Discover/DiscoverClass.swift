//
//  DiscoverClass.swift
//  SportsYap!
//
//  Created by Ketan Patel on 24/05/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class DiscoverClass: NSObject {

    var strName = ""
    var strUserName = ""
    var strEmail = ""
    var strLocation = ""
    var strUserId = ""
    var isFollow: Bool!
    var urlProfile:URL!
    
    
    func getUserListFor(showLoader:(Bool!), strSerarchWord:String , success:@escaping (Array<DiscoverClass>) -> Void, failed:@escaping (String!) -> Void) {
        
        if(isInternetConnection() == true) {
            
            let params:[String:String] = ["search": strSerarchWord,
                                          "device_token": "",
                                          "device_type": "ios"]
            
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: showLoader, url: USERLIST, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                
                let arrList = self.parsingUserList(responseReq: response as NSDictionary)
                success(arrList)
                
            }) { (response:String!) in
                failed(response)
            }
            
        }
        else {
            failed("no internet connection")
        }
    }
    
    func followUser(showLoader:(Bool!) , success:@escaping (String) -> Void, failed:@escaping (String!) -> Void) {
        
        if(isInternetConnection() == true) {
            
            let params:[String:String] = ["user_id": self.strUserId,
                                          "device_token": "",
                                          "device_type": "ios"]
            
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: showLoader, url: FOLLW_USER, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                success("")
                
            }) { (response:String!) in
                failed(response)
            }
            
        }
        else {
            failed("no internet connection")
        }
    }
    
    func unfollowUser(showLoader:(Bool!) , success:@escaping (String) -> Void, failed:@escaping (String!) -> Void) {
        
        if(isInternetConnection() == true) {
            
            let params:[String:String] = ["user_id": self.strUserId,
                                          "device_token": "",
                                          "device_type": "ios"]
            
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: showLoader, url: UNFOLLW_USER, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                success("")
                
            }) { (response:String!) in
                failed(response)
            }
            
        }
        else {
            failed("no internet connection")
        }
    }
    
    //MARK: - INternal Methods
    
    
    func parsingUserList(responseReq: NSDictionary) -> Array<DiscoverClass> {
        
        var arrList = Array<DiscoverClass>()
        
        var dict = JSON(responseReq).dictionaryValue
        
        for dict in (dict["data"]?.arrayValue)! {
            
            let disc = DiscoverClass()
            disc.strName = dict["name"].stringValue
            disc.strUserId = dict["id"].stringValue
            disc.strUserName = dict["username"].stringValue
            disc.strEmail = dict["email"].stringValue
            
            if(dict["is_follow"].stringValue == "0") {
                disc.isFollow = false
            }
            else {
                disc.isFollow = true
            }
        
            disc.strLocation = dict["location"].stringValue
            
            if(dict["image"].stringValue != "") {
                disc.urlProfile = (dict["image"].url)!
            }
            
            arrList.append(disc)
        }
        
        return arrList
    }
    
}


