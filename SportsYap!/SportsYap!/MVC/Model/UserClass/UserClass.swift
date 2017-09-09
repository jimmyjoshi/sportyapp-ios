//
//  UserClass.swift
//  EventApp
//
//  Created by Ketan Patel on 19/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserClass: NSObject {
    
    var strUserId = ""
    var strFBID = ""
    var strToken = ""
    var strUserName = ""
    var strPassword = ""
    var strName = ""
    var strEmail = ""
    var strLocation = ""
    var urlProfile:URL!
    
    static let sharedInstance = UserClass()
    
    //MARK: - WS Calls
    
    
    func loginApi(showLoader:(Bool!), success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String!) -> Void) {
        
        if(isInternetConnection() == true) {
            
            let params:[String:String] = ["username": UserClass.sharedInstance.strUserName,
                                          "password": UserClass.sharedInstance.strPassword,
                                          "device_token": "",
                                          "device_type": "ios"]
            
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: showLoader, url: LOGIN, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                
                self.parsingLoginData(responseReq: response as NSDictionary)
                success(response)
                
            }) { (response:String!) in
                failed(response)
            }
            
        }
        else {
            failed("no internet connection")
        }
    }
    
    func loginWithFBApi(showLoader:(Bool!), success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String!) -> Void) {
        
        if(isInternetConnection() == true) {
            
            let params:[String:String] = ["id": UserClass.sharedInstance.strFBID,
                                          "name": UserClass.sharedInstance.strName,
                                          "email": UserClass.sharedInstance.strEmail]
            
            let fbParams:[String: AnyObject] = ["facebook_data":params as AnyObject]
            
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: showLoader, url: FBLOGIN, parameter: fbParams as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                
                self.parsingLoginData(responseReq: response as NSDictionary)
                success(response)
                
            }) { (response:String!) in
                failed(response)
            }
            
        }
        else {
            failed("no internet connection")
        }
    }
    
    func registerApi(showLoader:(Bool!), img:UIImage, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String!) -> Void) {
        
        if(isInternetConnection() == true) {
            
            let params:[String:String] = ["name": UserClass.sharedInstance.strName,
                                          "email": UserClass.sharedInstance.strEmail,
                                          "password": UserClass.sharedInstance.strPassword,
                                          "username": UserClass.sharedInstance.strUserName,
                                          "location": UserClass.sharedInstance.strLocation,
                                          "device_token": "",
                                          "device_type": "ios"]
            
            MainReqeustClass.BaseRequestSharedInstance.POSTMultipartRequest(showLoader: showLoader, url: REGISTER, parameter: params as [String : AnyObject]?, img: img
                , success: { (response:Dictionary<String, AnyObject>) in
                
                self.parsingLoginData(responseReq: response as NSDictionary)
                success(response)
                
            }) { (response:String!) in
                failed(response)
            }
            
        }
        else {
            failed("no internet connection")
        }
    }
    
    func updateProfileApi(showLoader:(Bool!),strName:String, strLocation:String, img:UIImage?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String!) -> Void) {
        
        if(isInternetConnection() == true) {
            
            
            
            
            let params:[String:String] = ["name": strName,
                                          "location": strLocation]
            /*
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: false, url: UPDATE_PROFILE, parameter: params as [String: AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                
                print("response")
            }, failed: { (response: String!) in
                
            })
            */
            MainReqeustClass.BaseRequestSharedInstance.POSTMultipartRequest(showLoader: showLoader, url: UPDATE_PROFILE, parameter: params as [String : AnyObject]?, img: img
                , success: { (response:Dictionary<String, AnyObject>) in
                    
                    //self.parsingLoginData(responseReq: response as NSDictionary)
                    success(response)
                    
            }) { (response:String!) in
                failed(response)
            }
            
        }
        else {
            failed("no internet connection")
        }
    }
    
    
    
    func checkUserNameApi(showLoader:(Bool!), strUseName:String, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String!) -> Void) {
        
        if(isInternetConnection() == true) {
            
            let params:[String:String] = ["username": strUseName,
                                          "device_token": "",
                                          "device_type": "ios"]
            
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: showLoader, url: CHECKUSER, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                
                success(response)
                
            }) { (response:String!) in
                failed(response)
            }
            
        }
        else {
            failed("no internet connection")
        }
    }
    
    
    //MARK: - INternal Methods
    
    
    func parsingLoginData(responseReq: NSDictionary) {
        
        var dict = JSON(responseReq).dictionaryValue
        
        UserClass.sharedInstance.strUserId = (dict["data"]?["id"].stringValue)!
        UserClass.sharedInstance.strToken = (dict["data"]?["token"].stringValue)!
        UserClass.sharedInstance.strUserName = (dict["data"]?["username"].stringValue)!
        UserClass.sharedInstance.strName = (dict["data"]?["name"].stringValue)!
        UserClass.sharedInstance.strEmail = (dict["data"]?["email"].stringValue)!
        UserClass.sharedInstance.strLocation = (dict["data"]?["location"].stringValue)!
        
        if(dict["data"]?["image"].stringValue != "") {
            UserClass.sharedInstance.urlProfile = (dict["data"]?["image"].url)!
        }
        
        AppUserDefaults.setAllValuseInUserDefaults()
    }
}
