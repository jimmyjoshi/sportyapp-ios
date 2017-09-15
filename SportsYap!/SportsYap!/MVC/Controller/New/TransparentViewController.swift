//
//  TransparentViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 07/08/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class TransparentViewController: UIViewController {

    @IBOutlet weak var btnCreateFanChallenge: UIButton!
    @IBOutlet weak var btnPostToTimeLine: UIButton!
    @IBOutlet weak var btnPostToGame: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwBg: UIView!
    
    
    //Wowza temporary details
    var strWowzaUrl = String("https://api-sandbox.cloud.wowza.com/api/v1/stream_sources")
    var strApiKey = String("VWoCyxlmOreQePaJEwsyVi20piZXv7QCrUsbNunP0rVrMAV3rhzfgK9c7rh83708")
    var strAccessKey = String("6DLEcrOZpdPQAQFibiLY6zIIw8328Bq6imGBHjQ6IO5Kcntj4y2G68FaWk7Q304a")
    var strContentType = String("application/json")
    
    
    var strBackUpAdd = String("12.13.14.16")
    var strIpAdd = String("12.13.14.16")
    var strLocation = String("us_west_california")
    var strLocationMethod = String("region")
    var strMyStreamSource = String("My Stream Source")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
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
    
    @IBAction func btnCreatePostClicked(sender: UIButton) {
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        self.navigationController?.pushViewController(postVC, animated: true)
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    @IBAction func btnCreateFanChallengeClicked(sender: UIButton) {
        
    }
    
    @IBAction func btnCreatePostToGameClicked(sender: UIButton) {
        
        /*
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: PostToGameViewController = cameraStoryboard.instantiateViewController(withIdentifier: "PostToGameViewController") as! PostToGameViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        */
        
        
        /*
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: GameListingViewController = cameraStoryboard.instantiateViewController(withIdentifier: "GameListingViewController") as! GameListingViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()*/
        
        callWowzaApi()
    }
    
    
    func callWowzaApi() {
        
        var dictHeader : [String:AnyObject]
        dictHeader = ["wsc-api-key": strApiKey as AnyObject,"wsc-access-key":strAccessKey as AnyObject,"Content-Type": "application/json" as AnyObject]
        
        
        var params : [String:AnyObject]
        params = ["backup_ip_address" : strBackUpAdd as AnyObject,
        "ip_address": strIpAdd as AnyObject,
        "location": strLocation as AnyObject,
        "location_method": strLocationMethod as AnyObject,
        "name" : "My Stream Source" as AnyObject]
        
        
        var mainDict : [String:AnyObject]
        mainDict = ["stream_source": params as AnyObject]
        
        
           
        
    /*
        
        MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strWowzaUrl!, parameter: mainDict as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
            print("Response \(response as NSDictionary)")
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
        
        */
        
        
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strWowzaUrl!, parameter: mainDict, header: dictHeader, success: { (response:Dictionary<String, AnyObject>) in
            print("Response \(response as NSDictionary)")
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
        
    }
    
}
