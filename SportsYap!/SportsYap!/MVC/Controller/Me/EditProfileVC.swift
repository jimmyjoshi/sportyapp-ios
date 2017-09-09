//
//  EditProfileVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 26/05/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import GooglePlaces
import SwiftyJSON

class TeamCell: UITableViewCell {
    
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    
    override func awakeFromNib() {
        setCornurRedius(idObject: ivImage, radius: ivImage.frame.size.height/2)
        ivImage.layer.borderWidth = 1.5
        ivImage.layer.borderColor = UIColor.lightGray.cgColor
        
        setCornurRedius(idObject: btnFollow, radius: 3)
        btnFollow.layer.borderWidth = 0.7
        btnFollow.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
    }
    
}

class EditProfileVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnAddTeams: UIButton!
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btnProfile.layer.cornerRadius = self.btnProfile.frame.size.height/2
            self.btnProfile.layer.masksToBounds = true
            self.btnProfile.layer.borderColor = UIColor.lightGray.cgColor
            self.btnProfile.layer.borderWidth = 2
            
            setCornurRedius(idObject: self.btnAddTeams, radius: 3)
            self.btnAddTeams.layer.borderWidth = 0.7
            self.btnAddTeams.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
            
        }
        
        txtUserName.text = UserClass.sharedInstance.strUserName
        btnProfile.sd_setImage(with: UserClass.sharedInstance.urlProfile, for: .normal)
        txtName.text = UserClass.sharedInstance.strName
        txtLocation.text = UserClass.sharedInstance.strLocation
        txtPassword.text = UserClass.sharedInstance.strPassword
        txtEmail.text = UserClass.sharedInstance.strEmail

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK - IBAction Methods
    
    @IBAction private func btnCancelPressed(_ : UIButton) {
        self.view.endEditing(true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddTeamClicked(sender: UIButton) {
        /*
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addVC: AddTeamVC = cameraStoryboard.instantiateViewController(withIdentifier: "AddTeamVC") as! CommentViewController
        
        self.navigationController?.pushViewController(addVC, animated: true)*/
    }
    @IBAction private func btnSavePressed(_ : UIButton) {
        self.view.endEditing(true)
     
        
        if updateProfileValidation(txtName: txtName, txtLocation: txtLocation) {
            
            //btnProfile.image(for: .normal)!
            
            UserClass.sharedInstance.updateProfileApi(showLoader: true, strName: txtName.text!, strLocation: txtLocation.text!, img: btnProfile.imageView?.image, success: { (response) in
            
                            self.getUserData()
                            //Your Profile has been saved
                            //showAlert(strMsg: "Store response in UserDefault and local and show abov alert", vc: self)
                
            
                        }, failed: { (response) in
                            showAlert(strMsg: response as String, vc: self)
                        })

            
        }
        else {
            
        }
        
//        if(updateProfileValidation(txtName: txtName, txtLocation: txtLocation)) {
//            
//            UserClass.sharedInstance.updateProfileApi(showLoader: true, strName: txtName.text!, strLocation: txtLocation.text!, img: btnProfile.image(for: .normal)!, success: { (response) in
//                
//                //Your Profile has been saved
//                showAlert(strMsg: "Store response in UserDefault and local and show abov alert", vc: self)
//                _ = self.navigationController?.popViewController(animated: true)
//                
//            }, failed: { (response) in
//                showAlert(strMsg: response as String, vc: self)
//            })
//            
//        }
        
    }
    
    
    func getUserData() {
        let strURL = "http://52.66.73.127/sportyapp/public/api/users/getdata"
        MainReqeustClass.BaseRequestSharedInstance.getData(showLoader: true, url: strURL, parameter: nil, success: { (response:Dictionary<String, AnyObject>) in
            //self.strMatchTpe = strMatchType
            let responseReq = response as NSDictionary
            var dict = JSON(responseReq).dictionaryValue
            
            UserClass.sharedInstance.strUserId = (dict["data"]?["id"].stringValue)!
            UserClass.sharedInstance.strUserName = (dict["data"]?["username"].stringValue)!
            UserClass.sharedInstance.strName = (dict["data"]?["name"].stringValue)!
            UserClass.sharedInstance.strEmail = (dict["data"]?["email"].stringValue)!
            UserClass.sharedInstance.strLocation = (dict["data"]?["location"].stringValue)!
            
            if(dict["data"]?["image"].stringValue != "") {
                UserClass.sharedInstance.urlProfile = (dict["data"]?["image"].url)!
            }
            
            AppUserDefaults.setAllValuseInUserDefaults()
            
            
            _ = self.navigationController?.popViewController(animated: true)
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
        }
        
        
    }
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

    //MARK:- UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension EditProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TeamCell = tableView.dequeueReusableCell(withIdentifier: "TeamCell") as! TeamCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension EditProfileVC: GMSAutocompleteViewControllerDelegate {
    
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
