//
//  TransparentViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 07/08/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransparentViewController: UIViewController {

    @IBOutlet weak var btnCreateFanChallenge: UIButton!
    @IBOutlet weak var btnPostToTimeLine: UIButton!
    @IBOutlet weak var btnPostToGame: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var vwPostView: UIView!
    
    
    //Wowza temporary details
    var strApiKey = String("VWoCyxlmOreQePaJEwsyVi20piZXv7QCrUsbNunP0rVrMAV3rhzfgK9c7rh83708")
    var strAccessKey = String("6DLEcrOZpdPQAQFibiLY6zIIw8328Bq6imGBHjQ6IO5Kcntj4y2G68FaWk7Q304a")
    var strContentType = String("application/json")
    
    
    var strBackUpAdd = String("12.13.14.16")
    var strIpAdd = String("12.13.14.16")
    var strLocation = String("us_west_california")
    var strLocationMethod = String("region")
    var strMyStreamSource = String("My Stream Source")
    
    //Wowza
    var strWowzaUrl = String("https://api.cloud.wowza.com/api/v1/stream_sources")
    var arrLiveStream = NSArray()
    var intStreamChecked : Int = 0

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        vwPostView.isHidden = true
        
        btnCreateFanChallenge.setRoundedCorner(radius: nil)
        btnPostToGame.setRoundedCorner(radius: nil)
        btnPostToTimeLine.setRoundedCorner(radius: nil)
        btnClose.setRoundedCorner(radius: nil)
        
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.vwTapped(sender:)))
        self.vwBg.addGestureRecognizer(gesture)
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- View Clicked Event
    func vwTapped(sender : UITapGestureRecognizer) {
        // Do what you want
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
    }

    @IBAction private func btnCloseView(_ :UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
        
    }
    
    
    @IBAction private func btnClosePostView(_ :UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            
        }, completion: {
            (value: Bool) in
            
            self.vwBg.isHidden = false
            self.vwPostView.isHidden = true
        })
        
    }
    
    @IBAction func btnCreatePostClicked(sender: UIButton)
    {
        view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        vwBg.isHidden = true
        vwPostView.isHidden = false
        /*
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        self.navigationController?.pushViewController(postVC, animated: true)
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()*/
    }
    
    @IBAction func btnCreateImagePostClicked(sender: UIButton)
    {
        
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        postVC.isImageUploaded = true
        postVC.bolyGallery = true
        self.navigationController?.pushViewController(postVC, animated: true)
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnCreateCameraPostClicked(sender: UIButton)
    {
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        postVC.bonlyCamera = true
        postVC.isImageUploaded = true
        self.navigationController?.pushViewController(postVC, animated: true)
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    @IBAction func btnCreateVideoPostClicked(sender: UIButton)
    {
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        postVC.isVideoUploaded = true
        postVC.bonlyCamera = false
        self.navigationController?.pushViewController(postVC, animated: true)
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnCreateliveStreamingClicked(sender: UIButton)
    {
        vwPostView.isHidden = true
        self.getLiveStream()
        
    }

    
    @IBAction func btnCreateFanChallengeClicked(sender: UIButton) {
        
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: FanChallengeGameListViewController = cameraStoryboard.instantiateViewController(withIdentifier: "FanChallengeGameListViewController") as! FanChallengeGameListViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    @IBAction func btnCreatePostToGameClicked(sender: UIButton) {
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: GameListingViewController = cameraStoryboard.instantiateViewController(withIdentifier: "GameListingViewController") as! GameListingViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    //MARK: Wowza Post
    func getLiveStream() {
        
        //"https://api.cloud.wowza.com/api/v1/live_streams"
        //"https://cloud.wowza.com/api/v1/live_streams/"
        
        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: "https://api.cloud.wowza.com/api/v1/live_streams/", parameter: nil, header: getWowzaHeader(), success: { (response:Dictionary<String,AnyObject>) in
            let dictData = (response as NSDictionary)
            self.arrLiveStream = NSArray()
            self.intStreamChecked = 0
            self.arrLiveStream = dictData.value(forKey: "live_streams") as! NSArray
            self.getStreamState()
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
        /*
         let dictparam = NSMutableDictionary()
         dictparam.setValue("cloud.wowza.com", forKey: "backup_ip_address")
         dictparam.setValue("cloud.wowza.com", forKey: "ip_address")
         dictparam.setValue("us_west_california", forKey: "location")
         dictparam.setValue("region", forKey: "location_method")
         dictparam.setValue("My Stream Source", forKey: "name")
         var dictMain = NSDictionary()
         dictMain = [
         "stream_source": dictparam]
         
         MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: "https://api.cloud.wowza.com/api/v1/live_streams", parameter: nil, header: getWowzaHeader(), success: { (response:Dictionary<String, AnyObject>) in
         print("Response \(response as NSDictionary)")
         let dictResponse = response as NSDictionary
         if let dictTempData = dictResponse.value(forKey: "stream_source") {
         let dictData = (response as NSDictionary)
         self.arrLiveStream = NSArray()
         self.intStreamChecked = 0
         self.arrLiveStream = dictData.value(forKey: "stream_source") as! NSArray
         self.getStreamState()
         }
         else if let dictTmp = dictResponse.value(forKey: "meta") {
         let strMessage : String = ((dictTmp as! NSDictionary).value(forKey: "message") as! String)
         showAlert(strMsg: strMessage, vc: self)
         }
         }) { (response:String!) in
         showAlert(strMsg: response, vc: self)
         print("Error is \(response)")
         }*/
    }
    
    func getStreamState() {
        if intStreamChecked < arrLiveStream.count {
            let dictLiveStream : NSDictionary = arrLiveStream[intStreamChecked] as! NSDictionary
            let strId : String = "\(dictLiveStream.value(forKey: "id")!)"
            //            let url : String = "https://cloud.wowza.com/api/v1/live_streams/\(strId)/state"
            let url : String = "https://api.cloud.wowza.com/api/v1/live_streams/\(strId)/state"
            
            
            MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: url, parameter: nil, header: getWowzaHeader(), success: { (response:Dictionary<String,AnyObject>) in
                let dictData = (response as NSDictionary)
                let strState : String = (dictData.value(forKey: "live_stream") as! NSDictionary).value(forKey: "state") as! String
                if strState == "stopped" {
                    //Call api
                    self.getStreamInformation()
                }
                else
                {
//                    self.intStreamChecked = self.intStreamChecked + 1
                    self.getStreamInformation()

                }
                
                
            }) { (response:String!) in
                showAlert(strMsg: response, vc: self)
                print("Error is \(response)")
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
            }
            
        }
        else
        {
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
    func getStreamInformation() {
        let dictLiveStream : NSDictionary = arrLiveStream[intStreamChecked] as! NSDictionary
        let dictInfo : NSDictionary = dictLiveStream.value(forKey: "source_connection_information") as! NSDictionary
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: PostToGameViewController = cameraStoryboard.instantiateViewController(withIdentifier: "PostToGameViewController") as! PostToGameViewController
        
        postVC.intPortNumber = dictInfo.value(forKey: "host_port") as! UInt
        postVC.strUsername = "\(dictInfo.value(forKey: "username")!)"
        postVC.strPassword = "\(dictInfo.value(forKey: "password")!)"
        postVC.strStreamName = "\(dictInfo.value(forKey: "stream_name")!)"
        postVC.strHostAdd = "\(dictInfo.value(forKey: "primary_server")!)"
        postVC.strAppName = "\(dictInfo.value(forKey: "application")!)"
        //        postVC.strAppName = "app-d290"
        postVC.strStreamId = "\(dictLiveStream.value(forKey: "id")!)"
        postVC.strhosted_page_url = "\(dictLiveStream.value(forKey: "hosted_page_url")!)"
        
        self.navigationController?.pushViewController(postVC, animated: true)
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        

    }
    
    func getWowzaHeader() -> Dictionary<String, String> {
        var dictHeader : [String:String]
        dictHeader = ["wsc-api-key": kWowzaApiKey,"wsc-access-key":kWowzaAccessKey,"Content-Type": "application/json"]
        return dictHeader
    }
    
    func callWowzaApi() {
        var dictparam = NSMutableDictionary()
        dictparam.setValue("12.13.14.16", forKey: "backup_ip_address")
        dictparam.setValue("12.13.14.16", forKey: "ip_address")
        dictparam.setValue("us_west_california", forKey: "location")
        dictparam.setValue("region", forKey: "location_method")
        dictparam.setValue("My Stream Source", forKey: "name")
        var dictMain = NSDictionary()
        dictMain = [
            "stream_source": dictparam]
        
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strWowzaUrl!, parameter: dictMain as! [String : AnyObject], header: nil, success: { (response:Dictionary<String, AnyObject>) in
            print("Response \(response as NSDictionary)")
            let dictResponse = response as NSDictionary
            if let dictTempData = dictResponse.value(forKey: "stream_source") {
                let dictData = ((response as NSDictionary).value(forKey: "stream_source") as! NSDictionary)
                //Storing userfull variables
                appDelegate.strStreamName =  "\(dictData.value(forKey: "stream_name")!)"
                appDelegate.strUsername = "\(dictData.value(forKey: "username")!)"
                appDelegate.strPassword = "\(dictData.value(forKey: "password")!)"
                let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let postVC: PostToGameViewController = cameraStoryboard.instantiateViewController(withIdentifier: "PostToGameViewController") as! PostToGameViewController
                
                self.navigationController?.pushViewController(postVC, animated: true)
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
                

            }
            else if let dictTmp = dictResponse.value(forKey: "meta") {
                let strMessage : String = ((dictTmp as! NSDictionary).value(forKey: "message") as! String)
                showAlert(strMsg: strMessage, vc: self)
            }
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }

}
