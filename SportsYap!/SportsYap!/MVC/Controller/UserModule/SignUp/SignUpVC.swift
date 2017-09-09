//
//  SignUpVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 16/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

//Google place API key
//AIzaSyA1QzteBViMZnOIHORGMMaCTYXrnOSbblo



import UIKit
import ACFloatingTextfield
import GooglePlaces

class SignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    var imagePicker = UIImagePickerController()
    var strUserName: String = ""
    
    @IBOutlet private weak var txtUserName: ACFloatingTextField!
    @IBOutlet private weak var txtPassword: ACFloatingTextField!
    @IBOutlet private weak var txtName: ACFloatingTextField!
    @IBOutlet fileprivate weak var txtLocation: ACFloatingTextField!
    @IBOutlet fileprivate weak var txtEmail: ACFloatingTextField!
    
    @IBOutlet private weak var lblTaken: UILabel!
    @IBOutlet private weak var btnProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        
        setTextFiled(txt: txtEmail)
        setTextFiled(txt: txtPassword)
        setTextFiled(txt: txtUserName)
        setTextFiled(txt: txtName)
        setTextFiled(txt: txtLocation)
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btnProfile.layer.cornerRadius = self.btnProfile.frame.size.height/2
            self.btnProfile.layer.masksToBounds = true
            self.btnProfile.layer.borderColor = UIColor.lightGray.cgColor
            self.btnProfile.layer.borderWidth = 2
        }
        
        //setCornurRedius(idObject: btnProfile, radius: btnProfile.frame.size.height/2)
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnProfileImage(btnSender: UIButton) {
        self.view.endEditing(true)
        
        let uiAlert = UIAlertController(title: AppName, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        self.present(uiAlert, animated: true, completion: nil)
        
        uiAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
        
    }
    
    @IBAction func btnShowPassPress(btnSender : UIButton) {
        
        if(txtPassword.isSecureTextEntry == true) {
            txtPassword.isSecureTextEntry = false
        }
        else {
            txtPassword.isSecureTextEntry = true
        }
    }
    
    @IBAction private func btnSignUpPassPress(_ : UIButton) {
        self.view.endEditing(true)
        
        if(registrationValidation(txtEmail: txtEmail, txtPassword: txtPassword, txtName: txtName, txtLocation: txtLocation, txtUserName: txtUserName)) {
            
            UserClass.sharedInstance.strLocation = txtLocation.text!
            UserClass.sharedInstance.strEmail = txtEmail.text!
            UserClass.sharedInstance.strPassword = txtPassword.text!
            UserClass.sharedInstance.strName = txtName.text!
            UserClass.sharedInstance.strUserName = txtUserName.text!
            
            UserClass.sharedInstance.registerApi(showLoader: true, img: btnProfile.image(for: .normal)!, success: { (response) in
                
                let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let teamVC = homeStoryboard.instantiateViewController(withIdentifier: "TeamVC")
                self.navigationController?.pushViewController(teamVC, animated: true)
                
            }, failed: { (response) in
                showAlert(strMsg: response as String, vc: self)
            })
            
        }
        
    }
    
    @IBAction private func btnLocationPressed(_ : UIButton) {
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
        
    }
    
    //MARK:- UIImage picker delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        btnProfile.setImage(info[UIImagePickerControllerEditedImage] as? UIImage, for: .normal)
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: - UITextField Delegate 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == txtUserName) {
            
            if string.isEmpty {
                strUserName = String(strUserName.characters.dropLast())
            }
            else {
                strUserName = textField.text!+string
            }
            
            print(strUserName)

            UserClass.sharedInstance.checkUserNameApi(showLoader: false, strUseName: strUserName, success: { (response) in
                
                self.lblTaken.isHidden = true
                
            }, failed: { (response) in
                
                self.lblTaken.isHidden = false
                
            })
            
            return true
            
        }
        else {
            return true
        }
        
    }
}


extension SignUpVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //txtLocation.text = "\(place.name), \(place.formattedAddress!)"
        txtLocation.text = "\(place.formattedAddress!)"
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
