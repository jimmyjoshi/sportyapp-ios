//
//  NewVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 24/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class NewVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var txtPost : UITextView!
    @IBOutlet var btnPost : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var imgPost : UIImageView!
    @IBOutlet var htImg : NSLayoutConstraint!
    var imagePicker = UIImagePickerController()
    var isImageUploaded : Bool = false
    var isVideoUploaded : Bool = false
    var videoData = Data()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        setRoundedCorner()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRoundedCorner() {
        btnPost.layer.cornerRadius = 5
        btnPost.layer.borderWidth = 1
        btnPost.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
        
        htImg.constant = 0
        btnCancel.isHidden = true
        txtPost.clipsToBounds = true
        txtPost.layer.cornerRadius = 10.0
        txtPost.layer.borderColor = UIColor.gray.cgColor
        txtPost.layer.borderWidth = 1
        
        //txtPost.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @IBAction func btnPostClicked(sender:UIButton) {
        if isValid() {
            self.callPostApi()
        }
    }
    
    @IBAction func btnBackClicked(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func isValid()->Bool {
        txtPost.text = txtPost.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if txtPost.text.characters.count == 0 {
           
            showAlert(strMsg: "Please enter post.", vc: self)
            return false
        }
        return true
    }
    
    func callPostApi() {
        let strUrl : String = "posts/create"
        var params : [String:AnyObject]
        
        
        if isImageUploaded == false
        {
            if isVideoUploaded == true
            {
                params = ["description": txtPost.text as AnyObject,"is_image" : 0 as AnyObject]

                MainReqeustClass.BaseRequestSharedInstance.POSTMultipartRequestVideo(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, data: videoData
                    , success: { (response:Dictionary<String, AnyObject>) in
                        
                        print("video posted")
                        var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                        
                        showAlert(strMsg: strMes, vc: self)
                        self.isImageUploaded = false
                        self.htImg.constant = 0
                        self.btnCancel.isHidden = true
                        self.txtPost.text = ""
                        //self.parsingLoginData(responseReq: response as NSDictionary)
                        //success(response)
                        
                }) { (response:String!) in
                    //var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                    
                    showAlert(strMsg: response, vc: self)
                    //failed(response)
                }
            }
            else
            {
                params = ["description": txtPost.text as AnyObject,"is_image" : 0 as AnyObject]

                MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                    print("Response \(response as NSDictionary)")
                    var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                    
                    showAlert(strMsg: strMes, vc: self)
                    self.txtPost.text = ""
                }) { (response:String!) in
                    //var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                    
                    showAlert(strMsg: response, vc: self)
                    print("Error is \(response)")
                    //failed(response)
                }
            }
            
        }
        else
        {
            params = ["description": txtPost.text as AnyObject,"is_image" : 1 as AnyObject]

            MainReqeustClass.BaseRequestSharedInstance.POSTMultipartRequest(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, img: imgPost.image
                , success: { (response:Dictionary<String, AnyObject>) in
                    
                    print("image posted")
                    var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                    
                    showAlert(strMsg: strMes, vc: self)
                    self.isImageUploaded = false
                    self.htImg.constant = 0
                    self.btnCancel.isHidden = true
                    self.txtPost.text = ""
                    //self.parsingLoginData(responseReq: response as NSDictionary)
                    //success(response)
                    
            }) { (response:String!) in
                //var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                
                showAlert(strMsg: response, vc: self)
                //failed(response)
            }
            
        }
    }
    
    @IBAction func btnUploadPic(btnSender: UIButton)
    {
        self.view.endEditing(true)
        let uiAlert = UIAlertController(title: AppName, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        self.present(uiAlert, animated: true, completion: nil)
        self.imagePicker.mediaTypes = ["public.image", "public.movie"]

        uiAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
         
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
            {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }

        }))
        
        uiAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
    }
    
    
    @IBAction func btnCancelClicked(btnSender: UIButton) {
        isImageUploaded = false
        htImg.constant = 0
        btnCancel.isHidden = true
    }
    //MARK:- UIImage picker delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let mType: String? = (info[UIImagePickerControllerMediaType] as? String)
        if (mType == "public.movie")
        {
            let selectedVideoURL: URL? = (info["UIImagePickerControllerMediaURL"] as? URL)
            
            isVideoUploaded = true
            
            do {
                videoData = try Data(contentsOf: selectedVideoURL!)
                // do something with data
                // if the call fails, the catch block is executed
            } catch {
                print(error.localizedDescription)
            }
        }
        else
        {
            isImageUploaded = true
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage
            {
                imgPost.image = image
                btnCancel.isHidden = false
            } else
            {
                print("Something went wrong")
            }
        }
        htImg.constant = 105
        self.dismiss(animated:true, completion: nil)
    }
}
