//
//  LoginOptionVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 15/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class LoginOptionVC: UIViewController {

    @IBOutlet private weak var btnCreateAccount: RoundedButton!
    @IBOutlet private weak var btnConnectFB: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(AppUserDefaults.getValueForKey(key: "AUTOLOGIN") == "TRUE") {
            setTabbar()
            AppUserDefaults.getUserDetailFromApplication()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction Methods
    
    @IBAction private func btnFBLoginPressed(_ : UIButton) {
        
        FacebookClass.sharedInstance().loginWithFacebook(viewController: self, successHandler: { (response) in
            
            UserClass.sharedInstance.strFBID = response["id"]! as! String
            UserClass.sharedInstance.strName = response["name"]! as! String
            UserClass.sharedInstance.strEmail = response["email"]! as! String
            
            //setTabbar()
            
            UserClass.sharedInstance.loginWithFBApi(showLoader: true, success: { (response) in
                
                setTabbar()
            }, failed: { (response) in
                showAlert(strMsg: response as String, vc: self)
            })
            
        }, failHandler: { (failResponse) in
            showAlert(strMsg: failResponse , vc: self)
        })
        
    }
    
    @IBAction func unwindToLoginOptions(segue: UIStoryboardSegue) {
        
    }
}
