//N152160156745147
//  AppUserDefaults.swift
//  SocialNetworkApp
//
//  Created by Ketan on 5/20/16.
//
//

import UIKit

class AppUserDefaults: NSObject {
    
    class func setValue(value: String, key:String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    class func getValueForKey(key: String) -> (String) {
        
        if let val = UserDefaults.standard.object(forKey: key) {
            return val as! String
        }
        else {
            return ""
        }
    }
    
    class func setAllValuseInUserDefaults() {
        
        self.setValue(value: "TRUE", key: "AUTOLOGIN")
        
        self.setValue(value: UserClass.sharedInstance.strUserId, key: "USERID")
        self.setValue(value: UserClass.sharedInstance.strToken, key: "TOKEN")
        self.setValue(value: UserClass.sharedInstance.strUserName, key: "USERNAME")
        self.setValue(value: UserClass.sharedInstance.strName, key: "NAME")
        self.setValue(value: UserClass.sharedInstance.strEmail, key: "EMAIL")
        self.setValue(value: UserClass.sharedInstance.strLocation, key: "LOCATION")
        self.setValue(value: UserClass.sharedInstance.strPassword, key: "PASSWORD")
        
        if(UserClass.sharedInstance.urlProfile != nil) {
            self.setValue(value: "\(UserClass.sharedInstance.urlProfile!)", key: "PROFILEURL")
        }
        
    }

    class func getUserDetailFromApplication() {
        
        UserClass.sharedInstance.strUserId = self.getValueForKey(key: "USERID")
        UserClass.sharedInstance.strToken = self.getValueForKey(key: "TOKEN")
        UserClass.sharedInstance.strUserName = self.getValueForKey(key: "USERNAME")
        UserClass.sharedInstance.strName = self.getValueForKey(key: "NAME")
        UserClass.sharedInstance.strEmail = self.getValueForKey(key: "EMAIL")
        UserClass.sharedInstance.strLocation = self.getValueForKey(key: "LOCATION")
        UserClass.sharedInstance.strPassword = self.getValueForKey(key: "PASSWORD")
        
        UserClass.sharedInstance.urlProfile = URL(string: self.getValueForKey(key: "PROFILEURL"))
        
    }
    
    class func removeAllValues() {
        
        self.setValue(value: "FALSE", key: "AUTOLOGIN")
        
        self.setValue(value: "", key: "USERID")
        self.setValue(value: "", key: "TOKEN")
        self.setValue(value: "", key: "USERNAME")
        self.setValue(value: "", key: "NAME")
        self.setValue(value: "", key: "LOCATION")
        self.setValue(value: "", key: "PASSWORD")
        self.setValue(value: "", key: "PROFILEURL")
        self.setValue(value: "", key: "EMAIL")
        
        getUserDetailFromApplication()
        
    }
    
}
