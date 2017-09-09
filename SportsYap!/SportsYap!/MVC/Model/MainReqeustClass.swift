//
//  ServiceManager.swift
//  KrowdAround
//
//  Created by Ketan on 5/17/16.
//  Copyright © 2016 KrowdAround. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

extension String {
    func EncodingText() -> NSData {
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)! as NSData
    }
}

func getHeaderData() -> Dictionary<String, String> {
    var params:[String:String]
    //params = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjExLCJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3Q6ODAwMFwvYXBpXC9yZWdpc3RlciIsImlhdCI6MTQ5Mzc1NjM4NSwiZXhwIjoxNTI1MjkyMzg1LCJuYmYiOjE0OTM3NTYzODUsImp0aSI6IkNQaDkwNE1OVHRDdlRxb3gifQ.JEUfFR1mHkFdPwwh6ssvCykDd-CQWQulzCe5cS5xtOw"]
    
    //params = ["Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjY2LCJpc3MiOiJodHRwOlwvXC81Mi42Ni43My4xMjdcL3Nwb3J0eWFwcFwvcHVibGljXC9hcGlcL2xvZ2luIiwiaWF0IjoxNTAzMDM4ODY5LCJleHAiOjE1MzQ1NzQ4NjksIm5iZiI6MTUwMzAzODg2OSwianRpIjoidHQ1YnNjZWRvdUgyRW9IQiJ9.0wlgg3X51gXy7u-4p5EZyFT4q4LNE3K-T9nrfbd0ZDU"]
    
    params = ["Authorization": "Bearer \(UserClass.sharedInstance.strToken)"]
    
    return params
}


class MainReqeustClass: NSObject {

    static let BaseRequestSharedInstance = MainReqeustClass()
    
    //MARK: - WS CALLS Methods
    
    func PostRequset(showLoader: Bool, url:String, parameter:[String : AnyObject]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        
        
        if(isInternetConnection()) {
            
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            
            print("----------------------\n\n\n\nURL: \(base_Url+url)")
            print("I/P PARAMS: \(parameter)")
            
            Alamofire.request(base_Url+url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: getHeaderData()).responseJSON { (response:DataResponse<Any>) in
                
                
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                
                switch(response.result) {
                    
                case .success(_):
                    
                    print("Response: \(response.result.value as AnyObject!)")
                    
                    var dict = JSON(response.result.value ?? "").dictionaryValue
                    
                    if(dict["code"]?.intValue == 500) {
                        failed((dict["message"]?.stringValue)!)
                    }
                    else {
                        success(dict as Dictionary<String, AnyObject>)
                    }
                    
                    break
                    
                case .failure(_):
                    print("Response: \(response.result.error as AnyObject!)")
                    failed("The network connection was lost please try again.")
                    break
                    
                }
            }
        }
    }
    
    
    func GetRequset(showLoader: Bool, url:String, parameter:[String : AnyObject]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        
        
        if(isInternetConnection()) {
            
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            
            print("----------------------\n\n\n\nURL: \(base_Url+url)")
            print("I/P PARAMS: \(parameter)")
            
            Alamofire.request(base_Url+url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: getHeaderData()).responseJSON { (response:DataResponse<Any>) in
                
                
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                
                switch(response.result) {
                    
                case .success(_):
                    
                    print("Response: \(response.result.value as AnyObject!)")
                    
                    var dict = JSON(response.result.value ?? "").dictionaryValue
                    
                    if(dict["code"]?.intValue == 500) {
                        failed((dict["message"]?.stringValue)!)
                    }
                    else {
                        success(dict as Dictionary<String, AnyObject>)
                    }
                    
                    break
                    
                case .failure(_):
                    print("Response: \(response.result.error as AnyObject!)")
                    failed("The network connection was lost please try again.")
                    break
                    
                }
            }
        }
    }
    
    func GetRequsetForGame(showLoader: Bool, url:String, parameter:[String : AnyObject]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        
        
        if(isInternetConnection()) {
            
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            
            print("----------------------\n\n\n\nURL: \(url)")
            print("I/P PARAMS: \(parameter)")
            
            Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: getHeaderData()).responseJSON { (response:DataResponse<Any>) in
                
                
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                
                switch(response.result) {
                    
                case .success(_):
                    
                    print("Response: \(response.result.value as AnyObject!)")
                    
                    var dict = JSON(response.result.value ?? "").dictionaryValue
                    
                    if(dict["code"]?.intValue == 500) {
                        failed((dict["message"]?.stringValue)!)
                    }
                    else {
                        success(dict as Dictionary<String, AnyObject>)
                    }
                    
                    break
                    
                case .failure(_):
                    print("Response: \(response.result.error as AnyObject!)")
                    failed("The network connection was lost please try again.")
                    break
                    
                }
            }
        }
    }
    
    func getData(showLoader: Bool, url:String, parameter:[String : AnyObject]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        
        
        if(isInternetConnection()) {
            
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            
            print("----------------------\n\n\n\nURL: \(url)")
            print("I/P PARAMS: \(parameter)")
            
            Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: getHeaderData()).responseJSON { (response:DataResponse<Any>) in
                
                
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                
                switch(response.result) {
                    
                case .success(_):
                    
                    print("Response: \(response.result.value as AnyObject!)")
                    
                    var dict = JSON(response.result.value ?? "").dictionaryValue
                    
                    if(dict["code"]?.intValue == 500) {
                        failed((dict["message"]?.stringValue)!)
                    }
                    else {
                        //success(dict as Dictionary<String, AnyObject>)
                        success((response.result.value as! NSDictionary) as! Dictionary<String, AnyObject>)
                    }
                    
                    break
                    
                case .failure(_):
                    print("Response: \(response.result.error as AnyObject!)")
                    failed("The network connection was lost please try again.")
                    break
                    
                }
            }
        }
    }
    
    
    func getFeedsList(showLoader: Bool, url:String, parameter:[String : AnyObject]?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        if(isInternetConnection()) {
            MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
            
            print("----------------------\n\n\n\nURL: \(url)")
            print("I/P PARAMS: \(parameter)")
            
            Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: getHeaderData()).responseJSON { (response:DataResponse<Any>) in
                
                
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                
                switch(response.result) {
                    
                case .success(_):
                    
                    print("Response: \(response.result.value as AnyObject!)")
                    
                    var dict = JSON(response.result.value ?? "").dictionaryValue
                    
                    if(dict["code"]?.intValue == 500) {
                        failed((dict["message"]?.stringValue)!)
                    }
                    else {
                        success(dict as Dictionary<String, AnyObject>)
                    }
                    
                    break
                    
                case .failure(_):
                    print("Response: \(response.result.error as AnyObject!)")
                    failed("The network connection was lost please try again.")
                    break
                    
                }
            }
        }
    }
    
    
    
    func POSTMultipartRequest(showLoader: Bool, url:String, parameter:[String : AnyObject]?, img : UIImage?, success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String!) -> Void) {
        
        MainReqeustClass.ShowActivityIndicatorInStatusBar(shouldShowHUD: showLoader)
        
        print("----------------------\n\n\n\nURL: \(base_Url+url)")
        print("I/P PARAMS: \(parameter)")
        
        
        Alamofire.upload(multipartFormData:{ multipartFormData in
            
            if img != nil {
                multipartFormData.append(UIImageJPEGRepresentation(img!, 0.5)!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            
            
            for (key, value) in parameter! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            },
            usingThreshold:UInt64.init(),
            to:base_Url+url,
            method:.post,
            headers:getHeaderData(),
            encodingCompletion: { encodingResult in
                            switch encodingResult {
                            
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(response)
                                    
                                    upload.responseJSON { response in
                                        MainReqeustClass.HideActivityIndicatorInStatusBar()
                                        print("Response: \(response.result.value as AnyObject!)")
                                        
                                        var dict = JSON(response.result.value ?? "").dictionaryValue
                                        
                                        if(dict["code"]?.intValue == 500) {
                                            failed((dict["message"]?.stringValue)!)
                                        }
                                        else {
                                            success(dict as Dictionary<String, AnyObject>)
                                        }
                                    }
                                    
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                MainReqeustClass.HideActivityIndicatorInStatusBar()
                                failed("The network connection was lost please try again.")
                            }
        })
        
        
        
        /*
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append(UIImageJPEGRepresentation(img, 1)!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            
            for (key, value) in parameter! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to:base_Url+url)
        {
            (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                })
                
                upload.responseJSON { response in
                    MainReqeustClass.HideActivityIndicatorInStatusBar()
                    print("Response: \(response.result.value as AnyObject!)")
                    
                    var dict = JSON(response.result.value ?? "").dictionaryValue
                    
                    if(dict["code"]?.intValue == 500) {
                        failed((dict["message"]?.stringValue)!)
                    }
                    else {
                        success(dict as Dictionary<String, AnyObject>)
                    }
                }
                
            case .failure( _):
                MainReqeustClass.HideActivityIndicatorInStatusBar()
                failed("The network connection was lost please try again.")
            }
        }*/
    }

    //MARK: - Progress HUD Methods
    
    class func ShowActivityIndicatorInStatusBar( shouldShowHUD : Bool ) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if (shouldShowHUD == true) {
            let window = UIApplication.shared.keyWindow!
            let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
            progressHUD.label.text = "Loading..."
        }
    }
    
    class func HideActivityIndicatorInStatusBar() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

        MBProgressHUD.hideAllHUDs(for: UIApplication.shared.keyWindow!, animated: true)
    }
    
}
