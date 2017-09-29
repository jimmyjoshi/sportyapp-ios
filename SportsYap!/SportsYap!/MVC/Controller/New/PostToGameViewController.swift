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
    var strStreamId = String("")!
    var isStreaming : Bool = false
    var strLicenceKey = String("GSDK-0144-0000-04A2-EDC5-EC61")
    var apiTimer = Timer()
    
    /*
    var strHostAdd = String("5e64b8.entrypoint.cloud.wowza.com")!
    var intPortNumber : UInt = 1935
    //var strAppName = String("app-bf19")!
    var strAppName = String("app-d290")!
    var strStreamName = String("29664e65")!
    var strUsername = String("client25020")!
    var strPassword = String("c2a3db23")!
    */
    
    
    var strHostAdd = String("5e64b8.entrypoint.cloud.wowza.com")!
    var intPortNumber : UInt = 1935
    //var strAppName = String("app-bf19")!
    var strAppName = String("app-d290")!
    var strStreamName = String("29664e65")!
    var strUsername = String("client25020")!
    var strPassword = String("c2a3db23")!
    
    //var error : Error = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getStreamState()
        //configueLicenceKey()
    }

    
    func startTimer() {
        apiTimer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(self.callWowzaStatusCheckApi), userInfo: self, repeats: true)
    }
    
    
    func callWowzaStatusCheckApi() {
        print("check status")
        apiTimer.invalidate()
    }
    
    
    func callWowzaStatusCheckWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
            self.callWowzaStatusCheckApi()
        })
    }
    func settingValues() {
        //strStreamName = appDelegate.strStreamName
        //strUsername = appDelegate.strUsername
        //strPassword = appDelegate.strPassword
        //configueLicenceKey()
    }
    
    func configueLicenceKey() {
        if WowzaGoCoder.registerLicenseKey(strLicenceKey!) != nil {
            let uiAlert = UIAlertController(title: AppName, message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
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
        //self.callEndStreamingApi()
    }
    func startLiveStreaming() {
        if self.goCoder.config.validateForBroadcast() != nil {
            let uiAlert = UIAlertController(title: AppName, message: "\(self.goCoder.status.description)", preferredStyle: UIAlertControllerStyle.alert)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            self.present(uiAlert, animated: true, completion: nil)
            print("\(self.goCoder.status.description)")
        }
        else if self.goCoder.status.state != .running {
            self.goCoder.startStreaming(self)
            
            //self.callStartStreamApi()
        }
        else
        {
            self.goCoder.endStreaming(self)
            
            //self.callStartStreamApi()
        }
    }
    
    func callStartStreamApi() {
        let url : String = "https://api.cloud.wowza.com/api/v1/live_streams/\(strStreamId)/start"
        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: url, parameter: nil, header: getWowzaHeader(), success: { (response:Dictionary<String,AnyObject>) in
            let dictData = (response as NSDictionary)
            print("Dict Data \(dictData)")
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    
    func callEndStreamingApi() {
        let url : String = "https://api.cloud.wowza.com/api/v1/live_streams/\(strStreamId)/stop"
        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: url, parameter: nil, header: getWowzaHeader(), success: { (response:Dictionary<String,AnyObject>) in
            let dictData = (response as NSDictionary)
            print("Dict Data \(dictData)")
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    
    func getStreamState() {
        let url : String = "https://cloud.wowza.com/api/v1/live_streams/\(strStreamName)/state"
        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: url, parameter: nil, header: getWowzaHeader(), success: { (response:Dictionary<String,AnyObject>) in
            let dictData = (response as NSDictionary)
            let strState : String = (dictData.value(forKey: "live_stream") as! NSDictionary).value(forKey: "state") as! String
            if strState == "starting" {
                //self.getStreamInformation()
                print("Stream Starting")
                
                self.perform(#selector(self.getStreamState), with: nil, afterDelay: 0.8)
                //self.getStreamState()
            }
            else if strState == "started" {
                print("Stream started")
                 self.perform(#selector(self.configueLicenceKey), with: nil, afterDelay: 1.2)
            }
            
            
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    
    func getWowzaHeader() -> Dictionary<String, String> {
        var dictHeader : [String:String]
        dictHeader = ["wsc-api-key": kWowzaApiKey,"wsc-access-key":kWowzaAccessKey,"Content-Type": "application/json"]
        return dictHeader
    }
    //MARK:- Wowza Delegate methods
    func onWZStatus(_ status: WZStatus!) {
        switch status.state {
        case WZState.idle:
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
        /*
        let uiAlert = UIAlertController(title: AppName, message: "\(status.description)", preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
        }))
        self.present(uiAlert, animated: true, completion: nil)
        */
        
        self.view.makeToast("ERROR :- \(status.description)")
    }
}
