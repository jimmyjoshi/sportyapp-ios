//
//  ForgotPassVC.swift
//  EventApp
//
//  Created by Ketan Patel on 04/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import ACFloatingTextfield

class ForgotPassVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtEmail: ACFloatingTextField!
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setTextFiled(txt: txtEmail)
        
        setCornurRedius(idObject: self.btnSend, radius: 3)
        self.btnSend.layer.borderWidth = 0.7
        self.btnSend.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    //MARK:- IBAction Methods
    
    @IBAction func btnBackPressed(btnSender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
