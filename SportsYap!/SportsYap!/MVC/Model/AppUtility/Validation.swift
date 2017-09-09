//
//  Validation.swift
//  EventApp
//
//  Created by Ketan Patel on 19/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import UIKit

func loginValidation(txtUserName:UITextField, txtPassword:UITextField) -> Bool {
    
    if (isStringEmpty(string: txtUserName.text! as NSString)) {
        shake(txtField: txtUserName)
    }
    else if(isStringEmpty(string: txtPassword.text! as NSString)) {
        shake(txtField: txtPassword)
    }
    else {
        return true
    }
    
    return false
    
}

func registrationValidation(txtEmail:UITextField, txtPassword:UITextField, txtName:UITextField, txtLocation:UITextField, txtUserName:UITextField) -> Bool {
    
    if (isStringEmpty(string: txtName.text! as NSString)) {
        shake(txtField: txtName)
        return false
    }
    else if (isStringEmpty(string: txtName.text! as NSString)) {
        shake(txtField: txtEmail)
        return false
    }
    else if (!validateEmail(enteredEmail: txtEmail.text!)) {
        shake(txtField: txtEmail)
        return false
    }
    else if(isStringEmpty(string: txtUserName.text! as NSString)) {
        shake(txtField: txtUserName)
    }
    else if(isStringEmpty(string: txtPassword.text! as NSString)) {
        shake(txtField: txtPassword)
    }
    else {
        return true
    }
    
    return false
    
}

func updateProfileValidation(txtName:UITextField, txtLocation:UITextField) -> Bool {
    
    if (isStringEmpty(string: txtName.text! as NSString)) {
        shake(txtField: txtName)
        return false
    }
        /*
    else if(isStringEmpty(string: txtLocation.text! as NSString)) {
        shake(txtField: txtLocation)
    }*/
    else {
        return true
    }
    
    return false
    
}

func changePassValidation(txtNewPass:UITextField, txtConfirmPass:UITextField) -> Bool {
    
    if (isStringEmpty(string: txtNewPass.text! as NSString)) {
        shake(txtField: txtNewPass)
    }
    else if(isStringEmpty(string: txtConfirmPass.text! as NSString)) {
        shake(txtField: txtConfirmPass)
    }
    else if(txtNewPass.text! as NSString != txtConfirmPass.text! as NSString) {
        shake(txtField: txtNewPass)
        shake(txtField: txtConfirmPass)
    }
    else {
        return true
    }
    
    return false
    
}

func isValidPasswordAndConfirmPass(password:String, confirmPassword:String) -> Bool {
    
    if (password == confirmPassword) {
        return true
    }
    
    return false
    
}

func isPasswordLength(password:String) -> Bool {
    if(password.characters.count < 5) {
        return false
    }
    return true
}

func isStringEmpty(string:NSString) -> Bool {
    
    let str = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
    
    if str.length == 0 {
        return true
    }
    else {
        return false
    }
}

func validateUrl (stringURL : NSString) -> Bool {
    
    let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
    //var urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
    
    return predicate.evaluate(with: stringURL)
}

func validateEmail(enteredEmail:String) -> Bool {
    
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
    
}

func shake(txtField:UITextField) {
        
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.duration = 0.5
    animation.values = [-12.0, 12.0, -8.0, 8.0, -4.0, 4.0, 0.0 ]
    txtField.layer.add(animation, forKey: "shake")
}
