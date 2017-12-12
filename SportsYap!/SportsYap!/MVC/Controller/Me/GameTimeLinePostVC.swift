//
//  GameTimeLinePostVC.swift
//  SportsYap!
//
//  Created by Yash on 07/11/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import MobileCoreServices

class GameTimeLinePostVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate
{
    @IBOutlet var txtPost : UITextView!
    @IBOutlet var btnPost : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var imgPost : UIImageView!
    @IBOutlet var htImg : NSLayoutConstraint!
    var imagePicker = UIImagePickerController()
    var isImageUploaded : Bool = false
    var isVideoUploaded : Bool = false
    var isCreateFanChallengeScreen : Bool = false
    var selectedGame = GameClass()
    var videoData = Data()
    @IBOutlet var htVideoView: NSLayoutConstraint!
    @IBOutlet var vwVideo: UIView!
    @IBOutlet var lblVideoText: UILabel!
    @IBOutlet var btnRemoveVideo: UIButton!
    var videoThumbnailImage = UIImage()
    @IBOutlet var btnpic: UIButton!

    var isneedtogoahead : Bool = false

    
    //NEW Camera ClassConfiguration
    var libraryEnabled: Bool = true
    var croppingEnabled: Bool = false
    var allowResizing: Bool = true
    var allowMoving: Bool = false
    var minimumSize: CGSize = CGSize(width: 60, height: 60)
    var croppingParameters: CroppingParameters {
        return CroppingParameters(isEnabled: croppingEnabled, allowResizing: allowResizing, allowMoving: allowMoving, minimumSize: minimumSize)
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        setRoundedCorner()
        // Do any additional setup after loading the view.
        
        self.btnUploadPic(btnSender: btnpic)
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
        htVideoView.constant = 0
        vwVideo.isHidden = true
        
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
    
    func callPostApi()
    {
        var strUrl = String("")!
        var params : [String:AnyObject]
        strUrl = "posts/game-timeline"
        
        if isImageUploaded == false
        {
            if isVideoUploaded == true
            {
                params = ["description": txtPost.text as AnyObject,"is_image" : "0" as AnyObject,"gameId": selectedGame.strMatchId as AnyObject, "homeTeamId": selectedGame.strHomeMatchId as AnyObject, "awayTeamId":selectedGame.strAwayMatchId as AnyObject]
                
                MainReqeustClass.BaseRequestSharedInstance.POSTMultipartRequestVideo(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, data: videoData, img: videoThumbnailImage
                    , success: { (response:Dictionary<String, AnyObject>) in
                        
                        print("video posted")
                        var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                        
//                        showAlert(strMsg: strMes, vc: self)

                        let alertView = UIAlertController(title: AppName, message: strMes, preferredStyle: .alert)
                        let OKAction = UIAlertAction(title: "Ok", style: .default)
                        { (action) in
                            
                            self.isImageUploaded = false
                            self.htImg.constant = 0
                            self.btnCancel.isHidden = true
                            self.txtPost.text = ""
                            
                            if self.isneedtogoahead == true
                            {
                                let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let postVC: ChallengePostListViewController = cameraStoryboard.instantiateViewController(withIdentifier: "ChallengePostListViewController") as! ChallengePostListViewController
                                postVC.bfromGameTimeline = true
                                postVC.currentGameObject = self.selectedGame
                                postVC.isneedtogobackhome = true
                                self.navigationController?.pushViewController(postVC, animated: true)
                            }
                            else
                            {
                                self.navigationController?.popViewController(animated: true)
                            }

                        }
                        alertView.addAction(OKAction)
                        self.present(alertView, animated: true, completion: nil)

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
                params = ["description": txtPost.text as AnyObject,"is_image" : "0" as AnyObject,"gameId": selectedGame.strMatchId as AnyObject, "homeTeamId": selectedGame.strHomeMatchId as AnyObject, "awayTeamId":selectedGame.strAwayMatchId as AnyObject]
                //params = ["description": txtPost.text as AnyObject,"is_image" : 0 as AnyObject]
                
                MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                    print("Response \(response as NSDictionary)")
                    var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                    
//                    showAlert(strMsg: strMes, vc: self)
//                    self.txtPost.text = ""
                    let alertView = UIAlertController(title: AppName, message: strMes, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Ok", style: .default)
                    { (action) in
                        
                        self.txtPost.text = ""
                        if self.isneedtogoahead == true
                        {
                            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let postVC: ChallengePostListViewController = cameraStoryboard.instantiateViewController(withIdentifier: "ChallengePostListViewController") as! ChallengePostListViewController
                            postVC.bfromGameTimeline = true
                            postVC.currentGameObject = self.selectedGame
                            postVC.isneedtogobackhome = true
                            self.navigationController?.pushViewController(postVC, animated: true)
                        }
                        else
                        {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    alertView.addAction(OKAction)
                    self.present(alertView, animated: true, completion: nil)

                    
                    
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
            params = ["description": txtPost.text as AnyObject,"is_image" : "1" as AnyObject,"gameId": selectedGame.strMatchId as AnyObject, "homeTeamId": selectedGame.strHomeMatchId as AnyObject, "awayTeamId":selectedGame.strAwayMatchId as AnyObject]
            MainReqeustClass.BaseRequestSharedInstance.POSTMultipartRequest(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, img: imgPost.image
                , success: { (response:Dictionary<String, AnyObject>) in
                    
                    var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                    print("image posted")

                    let alertView = UIAlertController(title: AppName, message: strMes, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "Ok", style: .default)
                    { (action) in
                        
                        self.isImageUploaded = false
                        self.htImg.constant = 0
                        self.btnCancel.isHidden = true
                        self.txtPost.text = ""
                        if self.isneedtogoahead == true
                        {
                            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let postVC: ChallengePostListViewController = cameraStoryboard.instantiateViewController(withIdentifier: "ChallengePostListViewController") as! ChallengePostListViewController
                            postVC.bfromGameTimeline = true
                            postVC.currentGameObject = self.selectedGame
                            postVC.isneedtogobackhome = true
                            self.navigationController?.pushViewController(postVC, animated: true)
                        }
                        else
                        {
                            
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    alertView.addAction(OKAction)
                    self.present(alertView, animated: true, completion: nil)

                    
//                    showAlert(strMsg: strMes, vc: self)
//                    self.isImageUploaded = false
//                    self.htImg.constant = 0
//                    self.btnCancel.isHidden = true
//                    self.txtPost.text = ""
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
        self.imagePicker.mediaTypes = ["public.image", "public.movie"]
        
        if self.isVideoUploaded == true
        {
            let uiAlert = UIAlertController(title: AppName, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
                
                if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
                {
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.mediaTypes = [kUTTypeMovie as NSString as String]
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.videoMaximumDuration = 60.0
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
                self.imagePicker.mediaTypes = [kUTTypeMovie as NSString as String]
                self.imagePicker.allowsEditing = false
                self.imagePicker.videoMaximumDuration = 60.0
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
            
            uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            }))
        }
        else
        {
            let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: libraryEnabled) { [weak self] image, asset in
                //                self?.imageView.image = image
                self?.vwVideo.isHidden = false
                self?.htVideoView.constant = 105
                self?.isImageUploaded = true
                self?.htImg.constant = 105
                self?.lblVideoText.isHidden = true
                self?.btnRemoveVideo.isHidden = true
                self?.imgPost.image = image
                self?.btnCancel.isHidden = false
                
                self?.dismiss(animated: true, completion: nil)
            }
            present(cameraViewController, animated: true, completion: nil)
        }
       /* }))
        
        uiAlert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            
            self.imagePicker.sourceType = .savedPhotosAlbum
            if self.isVideoUploaded == true
            {
                self.imagePicker.mediaTypes = [kUTTypeMovie as NSString as String]
                self.imagePicker.allowsEditing = false
                self.imagePicker.videoMaximumDuration = 60.0

            }
            else
            {
                self.imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
                
            }
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))*/
    }
    
    
    @IBAction func btnCancelClicked(btnSender: UIButton)
    {
        isImageUploaded = false
        htImg.constant = 0
        btnCancel.isHidden = true
        
        htVideoView.constant = 0
        vwVideo.isHidden = true
    }
    
    @IBAction func btnRemoveVideoClicked(btnSender: UIButton)
    {
        isVideoUploaded = false
        videoData = Data()
        htVideoView.constant = 0
        vwVideo.isHidden = true
    }
    
    //MARK:- UIImage picker delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let mType: String? = (info[UIImagePickerControllerMediaType] as? String)
        vwVideo.isHidden = false
        htVideoView.constant = 105
        
        if (mType! == kUTTypeMovie as String)
        {
            let selectedVideoURL: URL? = (info["UIImagePickerControllerMediaURL"] as? URL)
            
            isVideoUploaded = true
            htImg.constant = 0
            lblVideoText.isHidden = false
            btnRemoveVideo.isHidden = false
            
            var uploadUrl = NSURL.fileURL(withPath: NSTemporaryDirectory().appending("\(NSDate())").appending(".mov"))
            
            if let videoimag = self.getThumbnailFrom(path: selectedVideoURL!)
            {
                videoThumbnailImage = self.getThumbnailFrom(path: selectedVideoURL!)!
            }

            self.compressVideo(inputURL: selectedVideoURL! as NSURL, outputURL: uploadUrl as NSURL, handler: { (handler) -> Void in
                
                if handler.status == AVAssetExportSessionStatus.completed
                {
                    
                    do {
                        self.videoData = try Data(contentsOf: uploadUrl)
                        // do something with data
                        // if the call fails, the catch block is executed
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
                else if handler.status == AVAssetExportSessionStatus.failed
                {
                    showAlert(strMsg: "There was a problem compressing the video maybe you can try again later. Error: \(handler.error?.localizedDescription ?? "")", vc: self)
                }
            })

          /*  do {
                videoData = try Data(contentsOf: selectedVideoURL!)
                // do something with data
                // if the call fails, the catch block is executed
            } catch {
                print(error.localizedDescription)
            }*/
        }
        else
        {
            isImageUploaded = true
            htImg.constant = 105
            lblVideoText.isHidden = true
            btnRemoveVideo.isHidden = true
            
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage
            {
                imgPost.image = image
                btnCancel.isHidden = false
            } else
            {
                print("Something went wrong")
            }
        }
        self.dismiss(animated:true, completion: nil)
    }
    func compressVideo(inputURL: NSURL, outputURL: NSURL, handler:@escaping (_ session: AVAssetExportSession)-> Void)
    {
        let urlAsset = AVURLAsset(url: inputURL as URL, options: nil)
        
        let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality)
        
        exportSession?.outputURL = outputURL as URL
        
        exportSession?.outputFileType = AVFileTypeQuickTimeMovie
        
        exportSession?.shouldOptimizeForNetworkUse = true
        
        exportSession?.exportAsynchronously { () -> Void in
            handler(exportSession!)
        }
    }
    func getThumbnailFrom(path: URL) -> UIImage?
    {
        do
        {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        }
        catch let error
        {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }

}
