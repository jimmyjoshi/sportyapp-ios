//
//  FacebookClass.swift
//  SocialLogin
//
//  Created by Ketan on 12/26/16.
//  Copyright © 2016 kETANpATEL. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin


typealias FBSuccessHandler = (_ success:Dictionary<String, AnyObject>) -> Void
typealias FBFailHandler = (_ success:String) -> Void


class FacebookClass: NSObject {
    
    var vc: UIViewController!
    var loginFail: FBFailHandler?
    var loginSucess: FBSuccessHandler?
    
    static var facebookClass: FacebookClass!
    
    class func sharedInstance() -> FacebookClass {
        
        if(facebookClass == nil) {
            facebookClass = FacebookClass()
        }
        return facebookClass
    }
    
    //MARK: - Logout Facebook
    
    func logoutFromFacebook() {
        
        if(isInternetConnection()) {
            let loginManager = LoginManager()
            loginManager.logOut()
        }
        else {
            print("No internet Connection.")
        }
    }
    
    //MARK: - Login with Facebook
    
    func loginWithFacebook(viewController: UIViewController, successHandler: @escaping FBSuccessHandler, failHandler: @escaping FBFailHandler) {

        vc = viewController
        loginFail = failHandler
        loginSucess = successHandler
        
        if(isInternetConnection()) {
            
            if(AccessToken.current == nil) {
                
                let loginManager = LoginManager()
                
                loginManager.logIn([.publicProfile, .userFriends, .email], viewController: viewController) { loginResult in
                    
                    switch loginResult {
                    case .failed(let error):
                        print(error)
                        self.loginFail!((error.localizedDescription as AnyObject) as! String)
                    case .cancelled:
                        print("User cancelled login.")
                        self.loginFail!("User cancelled login.")
                    case .success( _, _, let tokenstr):
                        print("Logged in! \(tokenstr)")
                        AccessToken.current = tokenstr
                        self.getUserInfoFromFB()
                    }
                }
            }
            else {
                //AccessToken.current = strToken
                self.getUserInfoFromFB()
            }
            
        }
        else {
            print("No internet Connection.")
            self.loginFail!("No internet Connection.")
        }
    }
    
    func getUserInfoFromFB() {
        
        let params = ["fields":"cover,picture.type(large),id,name,first_name,last_name,gender,birthday,email,location,hometown"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                self.loginFail!((error.localizedDescription as AnyObject) as! String)
                break
            case .success(let graphResponse):
                
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    self.loginSucess!((responseDictionary as AnyObject) as! Dictionary<String, AnyObject>)
                }
            }
        }
        
    }
    
    //MARK: - Get List Of Facebook Friends
    
    func getFacebookFriends(viewController: UIViewController, successHandler: @escaping FBSuccessHandler, failHandler: @escaping FBFailHandler) {
        
        vc = viewController
        loginFail = failHandler
        loginSucess = successHandler

        if(isInternetConnection()) {
            
            if(AccessToken.current == nil) {
                
                let loginManager = LoginManager()
                
                loginManager.logIn([.publicProfile, .userFriends, .email], viewController: viewController) { loginResult in
                    
                    switch loginResult {
                    case .failed(let error):
                        print(error)
                        self.loginFail!((error.localizedDescription as AnyObject) as! String)
                    case .cancelled:
                        print("User cancelled login.")
                        self.loginFail!("User cancelled login.")
                    case .success( _, _, let tokenstr):
                        print("Logged in! \(tokenstr)")
                        AccessToken.current = tokenstr
                        self.getUserFacebookFriendsFromFB()
                    }
                }
                
            }
            else {
                self.getUserFacebookFriendsFromFB()
            }
        }
        else {
            print("No internet Connection.")
            self.loginFail!("No internet Connection.")
        }
    }
    
    
    func getUserFacebookFriendsFromFB() {
        
        let params = ["fields":"cover,picture.type(large),id,name,first_name,last_name,gender,birthday,email,location,hometown"]
        let graphRequest = GraphRequest(graphPath: "me/friends", parameters: params)
        
        graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
                
            case .failed(let error):
                print("error in graph request:")
                self.loginFail!((error.localizedDescription as AnyObject) as! String)
                break
                
            case .success(let graphResponse):
                
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    self.loginSucess!((responseDictionary as AnyObject) as! Dictionary<String, AnyObject>)
                }
            }
        }
    }
}
