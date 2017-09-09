//
//  LoginVC.swift
//  EventApp
//
//  Created by Ketan Patel on 04/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import ACFloatingTextfield

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtUserName: ACFloatingTextField!
    @IBOutlet weak var txtPassword: ACFloatingTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        setTextFiled(txt: txtPassword)
        setTextFiled(txt: txtUserName)
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnLoginPress(_ : UIButton) {
        self.view.endEditing(true)
        
//        let teamVC = storyboard?.instantiateViewController(withIdentifier: "TeamVC") as! TeamVC
//        self.navigationController?.pushViewController(teamVC, animated: true)
        
        if(loginValidation(txtUserName: txtUserName, txtPassword: txtPassword)) {
            
            UserClass.sharedInstance.strUserName = txtUserName.text!
            UserClass.sharedInstance.strPassword = txtPassword.text!
            
            UserClass.sharedInstance.loginApi(showLoader: true, success: { (response) in
                
                setTabbar()
                
            }, failed: { (responser) in
                showAlert(strMsg: responser as String, vc: self)
            })
            
        }
        
    }
    
    
    @IBAction func btnShowPassPress(btnSender : UIButton) {
        
        if(txtPassword.isSecureTextEntry == true) {
           txtPassword.isSecureTextEntry = false
        }
        else {
            txtPassword.isSecureTextEntry = true
        }
        
    }
    
    //MARK:- UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
