//
//  PostToGameViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 26/08/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class PostToGameViewController: UIViewController,WZStatusCallback,WZAudioSink,WZVideoSink {

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
    
    var strhosted_page_url = String()
    
    //30-09-2017
    var goCoderConfig:WowzaConfig!
    var goCoderRegistrationChecked = false
    var receivedGoCoderEventCodes = Array<WZEvent>()
    var blackAndWhiteVideoEffect = false

    
    //var error : Error = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        WowzaGoCoder.setLogLevel(.default)
        goCoderConfig = WowzaConfig()
        goCoderConfig.videoEnabled = true
        goCoderConfig.videoHeight = 640
        goCoderConfig.videoWidth = 480
        goCoderConfig.videoFrameRate = 30
        goCoderConfig.videoKeyFrameInterval = 30
        goCoderConfig.videoBitrate = 3750000
        goCoderConfig.mirrorFrontCamera = false
        goCoderConfig.audioEnabled = true
        goCoderConfig.audioChannels = 2
        goCoderConfig.audioSampleRate = 0
        goCoderConfig.audioBitrate = 0
        goCoderConfig.videoPreviewRotates = false
        goCoderConfig.capturedVideoRotates = true
        goCoderConfig.broadcastVideoOrientation = .sameAsDevice
        goCoderConfig.broadcastScaleMode = .aspectFit
        goCoderConfig.videoBitrateLowBandwidthScalingFactor = 0.75
        goCoderConfig.videoFrameBufferSizeMultiplier = 4
        goCoderConfig.videoFrameRateLowBandwidthSkipCount = 4
        goCoderConfig.backgroundBroadcastEnabled = false
        
        // Log version and platform info
        print("WowzaGoCoderSDK version =\n major: \(WZVersionInfo.majorVersion())\n minor: \(WZVersionInfo.minorVersion())\n revision: \(WZVersionInfo.revision())\n build: \(WZVersionInfo.buildNumber())\n string: \(WZVersionInfo.string())\n verbose string: \(WZVersionInfo.verboseString())")
        
        print("Platform Info:\n\(WZPlatformInfo.string())")
        
        if let goCoderLicensingError = WowzaGoCoder.registerLicenseKey(strLicenceKey!)
        {
            showAlert(strMsg: goCoderLicensingError.localizedDescription, vc: self)
        }
        
        
        self.callStartStreamApi()
//        getStreamState()
        //configueLicenceKey()
    }
    
    //MARK: View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        goCoder?.cameraPreview?.previewLayer?.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !goCoderRegistrationChecked
        {
            goCoderRegistrationChecked = true
            if let goCoderLicensingError = WowzaGoCoder.registerLicenseKey(strLicenceKey!)
            {
                showAlert(strMsg: goCoderLicensingError.localizedDescription, vc: self)
            }
            else
            {
                // Initialize the GoCoder SDK
                if let goCoder = WowzaGoCoder.sharedInstance()
                {
                    self.goCoder = goCoder
                    
                    // Request camera and microphone permissions
                    WowzaGoCoder.requestPermission(for: .camera, response: { (permission) in
                        print("Camera permission is: \(permission == .authorized ? "authorized" : "denied")")
                    })
                    
                    WowzaGoCoder.requestPermission(for: .microphone, response: { (permission) in
                        print("Microphone permission is: \(permission == .authorized ? "authorized" : "denied")")
                    })
                    
                    self.goCoder?.register(self as WZAudioSink)
                    self.goCoder?.register(self as WZVideoSink)
                    self.goCoder?.config = self.goCoderConfig
                    
                    // Specify the view in which to display the camera preview
                    self.goCoder?.cameraView = self.view
                    
                    // Start the camera preview
                    self.goCoder?.cameraPreview?.start()
                }
            }
        }
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
//        goCoderBroadcastConfig.load(WZFrameSizePreset.preset1280x720)
        goCoderBroadcastConfig.hostAddress = strHostAdd
        goCoderBroadcastConfig.portNumber = intPortNumber
        goCoderBroadcastConfig.applicationName = strAppName
        goCoderBroadcastConfig.streamName = strStreamName
//        goCoderBroadcastConfig.username = strUsername
//        goCoderBroadcastConfig.password = strPassword
        self.goCoder.config = goCoderBroadcastConfig
    
        //01-10-2017
        self.perform(#selector(startstream), with: nil, afterDelay: 1)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClicked(sender:UIButton)
    {
        if isStreaming == false
        {
            let strUrl : String = "posts/create"
            var params : [String:AnyObject]
            params = ["description": strhosted_page_url as AnyObject,"is_wowza":"1" as AnyObject]
            
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strUrl, parameter: params, success: { (response:Dictionary<String, AnyObject>) in
                print("Response \(response as NSDictionary)")
            }) { (response:String!) in
                print("Error is \(response)")
            }
            
            isStreaming = true
            btnStartStreaming.setTitle("STOP STREAMING", for: .normal)
            self.startLiveStreaming()
        }
        else
        {
            isStreaming = false
            btnStartStreaming.setTitle("START STREAMING", for: .normal)
            
            if self.goCoder.status.state == .running
            {
                self.goCoder.endStreaming(self)
                self.callEndStreamingApi()
            }
        }
    }
    
    func startstream()
    {
        if isStreaming == false
        {
            let strUrl : String = "posts/create"
            var params : [String:AnyObject]
            params = ["description": strhosted_page_url as AnyObject,"is_wowza":"1" as AnyObject]
            
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strUrl, parameter: params, success: { (response:Dictionary<String, AnyObject>) in
                print("Response \(response as NSDictionary)")
            }) { (response:String!) in
                print("Error is \(response)")
            }
            

            isStreaming = true
            btnStartStreaming.setTitle("STOP STREAMING", for: .normal)
            self.startLiveStreaming()
        }
    }
    
    
    @IBAction func btnBackClicked(sender:UIButton)
    {
        if self.goCoder.status.state == .running
        {
            self.goCoder.endStreaming(self)
            self.callEndStreamingApi()
        }
        self.goCoder?.cameraPreview?.stop()
        self.navigationController?.popViewController(animated: true)
    }
    
    func endLiveStreaming()
    {
        self.goCoder.endStreaming(self)
        //self.callEndStreamingApi()
    }
    
    func startLiveStreaming()
    {
        if self.goCoder.config.validateForBroadcast() != nil
        {
            let uiAlert = UIAlertController(title: AppName, message: "\(self.goCoder.status.description)", preferredStyle: UIAlertControllerStyle.alert)
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                
            }))
            self.present(uiAlert, animated: true, completion: nil)
            print("\(self.goCoder.status.description)")
        }
        else if self.goCoder.status.state != .running
        {
            self.receivedGoCoderEventCodes.removeAll()
            
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
//        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: url, parameter: nil, header: getWowzaHeader(), success: { (response:Dictionary<String,AnyObject>) in
//            let dictData = (response as NSDictionary)
//            print("Dict Data \(dictData)")
//        }) { (response:String!) in
//            showAlert(strMsg: response, vc: self)
//            print("Error is \(response)")
//        }
        MainReqeustClass.BaseRequestSharedInstance.putRequest(showLoader: true, url: url, parameter: nil, header: getWowzaHeader(), success: { (response:Dictionary<String,AnyObject>) in
            let dictData = (response as NSDictionary)
            print("Dict Data \(dictData)")
            
            self.getStreamState()

            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    
    func callEndStreamingApi() {
        let url : String = "https://api.cloud.wowza.com/api/v1/live_streams/\(strStreamId)/stop"
        MainReqeustClass.BaseRequestSharedInstance.putRequest(showLoader: true, url: url, parameter: nil, header: getWowzaHeader(), success: { (response:Dictionary<String,AnyObject>) in
            let dictData = (response as NSDictionary)
            print("Dict Data \(dictData)")
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    //30-09-2017
    
    func getStreamState() {
//        let url : String = "https://cloud.wowza.com/api/v1/live_streams/\(strStreamName)/state"

        //"https://api.cloud.wowza.com/api/v1/live_streams/[live_stream_id]/stats"
        let url : String = "https://api.cloud.wowza.com/api/v1/live_streams/\(strStreamId)/state"

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
    
    //30-09-2017
    //MARK: - WZStatusCallback Protocol Instance Methods
    
    
    func onWZEvent(_ status: WZStatus!) {
        // If an event is reported by the GoCoder SDK, display an alert dialog describing the event,
        // but only if we haven't already shown an alert for this event
        
        DispatchQueue.main.async
            { () -> Void in
            if !self.receivedGoCoderEventCodes.contains(status.event)
            {
                self.receivedGoCoderEventCodes.append(status.event)
                self.view.makeToast("Live Streaming Event")
            }
            
        }
    }
    
    //MARK: - WZVideoSink Protocol Methods
    func videoFrameWasCaptured(_ imageBuffer: CVImageBuffer, framePresentationTime: CMTime, frameDuration: CMTime)
    {
        if goCoder != nil && goCoder!.isStreaming && blackAndWhiteVideoEffect {
            // convert frame to b/w using CoreImage tonal filter
            var frameImage = CIImage(cvImageBuffer: imageBuffer)
            if let grayFilter = CIFilter(name: "CIPhotoEffectTonal") {
                grayFilter.setValue(frameImage, forKeyPath: "inputImage")
                if let outImage = grayFilter.outputImage {
                    frameImage = outImage
                    
                    let context = CIContext(options: nil)
                    context.render(frameImage, to: imageBuffer)
                }
                
            }
        }
    }
    
    func videoCaptureInterruptionStarted()
    {
        goCoder?.endStreaming(self)
    }
    
    
    //MARK: - WZAudioSink Protocol Methods
    func audioLevelDidChange(_ level: Float)
    {
        //        print("Audio level did change: \(level)");
    }
    
}
