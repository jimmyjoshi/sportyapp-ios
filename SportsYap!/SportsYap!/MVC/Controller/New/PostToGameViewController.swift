//
//  PostToGameViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 26/08/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class PostToGameViewController: UIViewController,WZStatusCallback {

    @IBOutlet weak var goCoder: WowzaGoCoder!
    
    
    @IBOutlet weak var btnStartStreaming: UIButton!
    var isStreaming : Bool = false
    var strLicenceKey = String("GSDK-0144-0000-04A2-EDC5-EC61")
    /*
    var strHostAdd = String("3456bc.entrypoint.cloud.wowza.com")
    var intPortNumber : UInt = 1935
    var strAppName = String("sportyApp")
    var strStreamName = String("095fe02a")
    var strUsername = String("client25020")
    var strPassword = String("7dcb3420")
    */
    
    
    var strHostAdd = String("5e64b8.entrypoint.cloud.wowza.com")
    var intPortNumber : UInt = 1935
    var strAppName = String("app-bf19")
    var strStreamName = String("29664e65")
    var strUsername = String("client25020")
    var strPassword = String("c2a3db23")
    
    
    /*
    goCoderBroadcastConfig.hostAddress = @"5e64b8.entrypoint.cloud.wowza.com";
    goCoderBroadcastConfig.portNumber = 1935;
    goCoderBroadcastConfig.applicationName = @"app-bf19";
    goCoderBroadcastConfig.streamName = @"29664e65";
    goCoderBroadcastConfig.username= @"client25020";
    goCoderBroadcastConfig.password = @"c2a3db23";
   */
    
    //var error : Error = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        configueLicenceKey()
    }

    func configueLicenceKey() {
        //error = WowzaGoCoder.registerLicenseKey(strLicenceKey!)! as NSError
        if WowzaGoCoder.registerLicenseKey(strLicenceKey!) != nil {
            let uiAlert = UIAlertController(title: AppName, message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
            uiAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                
            }))
            self.present(uiAlert, animated: true, completion: nil)
        }
        else {
            self.goCoder = WowzaGoCoder.sharedInstance()
        }
        
        
        if self.goCoder != nil {
            self.goCoder.cameraView = self.view
            self.goCoder.cameraPreview?.start()
            configuringWowzaCloud()
        }
        
        
        /*
        let error : Error = WowzaGoCoder.registerLicenseKey(strLicenceKey!)!
        //error = WowzaGoCoder.registerLicenseKey(strLicenceKey!)! as Error
        if error != nil {
            print("\(error.localizedDescription)")
            
            
            let uiAlert = UIAlertController(title: AppName, message: "\(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
            uiAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                
            }))
            self.present(uiAlert, animated: true, completion: nil)
            
        
        }
        else
        {
            self.goCoder = WowzaGoCoder.sharedInstance()
        }
        if self.goCoder != nil {
            self.goCoder.cameraView = self.view
            self.goCoder.cameraPreview?.start()
            configuringWowzaCloud()
        }
        */
        
    }
    func configuringWowzaCloud() {
        var goCoderBroadcastConfig = WowzaConfig()
        goCoderBroadcastConfig = self.goCoder.config
        goCoderBroadcastConfig.load(WZFrameSizePreset.preset1280x720)
        goCoderBroadcastConfig.hostAddress = strHostAdd
        goCoderBroadcastConfig.portNumber = intPortNumber
        goCoderBroadcastConfig.applicationName = strAppName
        goCoderBroadcastConfig.streamName = strStreamName
        goCoderBroadcastConfig.username = strUsername
        goCoderBroadcastConfig.password = strPassword
        
        self.goCoder.config = goCoderBroadcastConfig
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClicked(sender:UIButton) {
        
        if isStreaming == false {
            isStreaming = true
            btnStartStreaming.setTitle("STOP STREAMING", for: .normal)
            self.startLiveStreaming()
        }
        else
        {
            isStreaming = false
            btnStartStreaming.setTitle("START STREAMING", for: .normal)
            self.endLiveStreaming()
        }
        
    }
    
    
    @IBAction func btnBackClicked(sender:UIButton) {
        if isStreaming == false {
            
        }
        else
        {
            self.endLiveStreaming()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func endLiveStreaming() {
        self.goCoder.endStreaming(self)
    }
    
    
    func startLiveStreaming() {
        //var configValidationError = NSError()
        //configValidationError = self.goCoder.config.validateForBroadcast() as! NSError
        
        
        if self.goCoder.config.validateForBroadcast() != nil {
            let uiAlert = UIAlertController(title: AppName, message: "\(self.goCoder.status.description)", preferredStyle: UIAlertControllerStyle.alert)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            self.present(uiAlert, animated: true, completion: nil)
            print("\(self.goCoder.status.description)")
        }
        else if self.goCoder.status.state != .running {
            self.goCoder.startStreaming(self)
        }
        else
        {
            self.goCoder.endStreaming(self)
        }
    }
    
    //MARK:- Wowza Delegate methods
    func onWZStatus(_ status: WZStatus!) {
        switch status.state {
        case WZState.idle:
            print("IDLE")
            self.view.makeToast("Status Idle")
            break
        case WZState.starting:
            self.view.makeToast("Status Starting")
            break
        case WZState.running:
            self.view.makeToast("Status Running")
            break
        case WZState.stopping:
            self.view.makeToast("Status Stopping")
            break
        default:
            self.view.makeToast("Status Unmatched")
        }
    }
    
    func onWZError(_ status: WZStatus!) {
        let uiAlert = UIAlertController(title: AppName, message: "\(status.description)", preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
        }))
        self.present(uiAlert, animated: true, completion: nil)
    }
}
