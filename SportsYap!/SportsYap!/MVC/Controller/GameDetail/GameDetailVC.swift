//
//  GameDetailVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 30/05/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit


class FansCell: UITableViewCell {
    
    @IBOutlet weak var ivVarify: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    override func awakeFromNib() {
        setCornurRedius(idObject: ivImage, radius: ivImage.frame.size.height/2)
        ivImage.layer.borderWidth = 1.5
        ivImage.layer.borderColor = UIColor.lightGray.cgColor
        
        setCornurRedius(idObject: ivVarify, radius: ivVarify.frame.size.height/2)
    }
    
}

class NewsCell: UITableViewCell {
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblFollowTime: UILabel!
    @IBOutlet var lblDescription: UILabel!
}


class GameDetailVC: UIViewController {

    @IBOutlet private var viewRounded: UIView!
    @IBOutlet private var viewDot: UILabel!
    @IBOutlet private var btnFanmeter: UIButton!
    @IBOutlet fileprivate var btnNews: UIButton!
    @IBOutlet fileprivate var btnFans: UIButton!
    @IBOutlet public var tblList: UITableView!
    @IBOutlet private var slider: UISlider!
    @IBOutlet private var cntHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblTeam1FirstName: UILabel!
    @IBOutlet weak var lblTeam1LastName: UILabel!
    @IBOutlet weak var lblTeam1Score: UILabel!
    
    @IBOutlet weak var lblTeam2FirstName: UILabel!
    @IBOutlet weak var lblTeam2LastName: UILabel!
    @IBOutlet weak var lblTeam2Score: UILabel!
    
    @IBOutlet weak var lblMatchTime: UILabel!
    
    @IBOutlet weak var imgGameType: UIImageView!
    
    fileprivate var isFans: Bool!
    var isCurrentMatch: Bool!
    
    var currentGameObject = GameClass()
    
    var dictFan = NSMutableDictionary()
    var arrNews = NSMutableArray()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*
        if(isCurrentMatch == true) {
            cntHeight.constant = 100
        }*/
        
        cntHeight.constant = 0
        
        isFans = true
        
        slider.setThumbImage(#imageLiteral(resourceName: "FaceSlider"), for: .normal)
        slider.setThumbImage(#imageLiteral(resourceName: "FaceSlider"), for: .selected)
        slider.setThumbImage(#imageLiteral(resourceName: "FaceSlider"), for: .highlighted)
        
        tblList.estimatedRowHeight = 71
        tblList.rowHeight = UITableViewAutomaticDimension
        
        setCornurRedius(idObject: viewRounded, radius: 4.0)
        setCornurRedius(idObject: viewDot, radius: viewDot.frame.size.height/2)
        btnFanmeter.layer.borderWidth = 1
        btnFanmeter.layer.borderColor = UIColor.white.cgColor
        setCornurRedius(idObject: btnFanmeter, radius: 5.0)
        
        
        setTeamValues()
    }
    
    func setTeamValues() {
        lblTeam1FirstName.text = currentGameObject.strTeam1FirstName
        lblTeam1LastName.text = currentGameObject.strTeam1LastName
        lblTeam1Score.text = currentGameObject.strTeam1Score
        lblTeam2FirstName.text = currentGameObject.strTeam2FirstName
        lblTeam2LastName.text = currentGameObject.strTeam2LastName
        lblTeam2Score.text = currentGameObject.strTeam2Score
        lblMatchTime.text = currentGameObject.strTime
        
        
        
        if currentGameObject.strMatchTpe == "football" {
            imgGameType.image = UIImage(named: "Game_image1")
        }
        else if currentGameObject.strMatchTpe == "baseball" {
            imgGameType.image = UIImage(named: "Game_image2")
        }
        else if currentGameObject.strMatchTpe == "bsktbl" {
            imgGameType.image = UIImage(named: "Game_image3")
        }
        else if currentGameObject.strMatchTpe == "hockey" {
            imgGameType.image = UIImage(named: "Game_image0")
        }
        else
        {
            imgGameType.image = UIImage(named: "Game_image0")
        }
        
        
        //callFanApi()
        
        //callNewsApi()

    }

    override func viewWillAppear(_ animated: Bool) {
        callFanApi()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBAction Methods
    
    @IBAction private func btnFansPress(_ : UIButton) {
        
        isFans = true
        
        btnFans.setTitleColor(UIColor.black, for: .normal)
        btnNews.setTitleColor(UIColor.darkGray, for: .normal)
        
        if dictFan.allKeys.count > 0
        {
            tblList.reloadData()
        }
        else
        {
            self.callFanApi()
        }
        
        
    }
    
    @IBAction private func btnBackPress(_ : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func btnEnterFieldClicked(_ : UIButton) {
        callIsTeamRatioAdded()
    }
    
    @IBAction private func btnNewsPress(_ : UIButton) {
        
        isFans = false
        
        btnNews.setTitleColor(UIColor.black, for: .normal)
        btnFans.setTitleColor(UIColor.darkGray, for: .normal)
        
        if arrNews.count > 0 {
            tblList.reloadData()
        }
        else
        {
            self.callNewsApi()
        }
        
        
    }
    
    @IBAction func btnFanChallengeClicked(sender: UIButton){
        self.view.endEditing(true)
        let moreVC = storyboard?.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        moreVC.currentGame = currentGameObject
        view.addSubview(moreVC.view)
        addChildViewController(moreVC)
    }
    
    func setFanSlider(intHomeCount: Int, intAwayCount: Int) {
        
        var intPercent : Int = 0
        
        if intHomeCount == 0 && intAwayCount == 0 {
            intPercent = 50
        }
        else if intHomeCount == 0 {
            intPercent = 100
        }
        else if intAwayCount == 0 {
            intPercent = 0
        }
        else
        {
            intPercent = ((intHomeCount*100)/(intAwayCount+intHomeCount))
            
            intPercent = 100 - intPercent
        }
        
        //let intPercent : Int = ((intHomeCount*100)/(intAwayCount+intHomeCount))
        slider.value = Float(intPercent)
        
        print("Percent is \(intPercent)")
        
    }
    
    func openActionSheet() {
        let uiAlert = UIAlertController(title: AppName, message: "Select Team to follow", preferredStyle: UIAlertControllerStyle.actionSheet)
        self.present(uiAlert, animated: true, completion: nil)
        
        
        uiAlert.addAction(UIAlertAction(title: currentGameObject.strTeam1FirstName, style: .default, handler: { action in
            //First away
            
            self.callAddTeamRatio(strFollowTeam: self.currentGameObject.strHomeMatchId)
        }))
        
        uiAlert.addAction(UIAlertAction(title: currentGameObject.strTeam2FirstName, style: .default, handler: { action in
            //Second Home
            self.callAddTeamRatio(strFollowTeam: self.currentGameObject.strAwayMatchId)
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            
        }))
    }
    //MARK:- API Call & Return Methods
    func callFanApi() {
        var strUrl = String("")!
        strUrl = "\(base_Url)users/get-fans"
        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: strUrl, parameter: nil, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            //let dictData = ((response as NSDictionary).value(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            self.dictFan = ((response as NSDictionary).value(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            self.tblList.reloadData()
            
            self.getFanMeter()
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
            
            self.getFanMeter()
        }
    }
    
    func callNewsApi() {
        var strUrl = String("")!
        strUrl = "\(base_Url)users/get-news"
        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: strUrl, parameter: nil, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            self.arrNews = NSMutableArray()
            self.arrNews  = ((response as NSDictionary).value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
            print("\(self.arrNews)")
            self.tblList.reloadData()
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    func getFanMeter() {
        let dictParameter : [String:AnyObject]  = ["gameId": currentGameObject.strMatchId as AnyObject,"homeTeamId": currentGameObject.strHomeMatchId as AnyObject,"awayTeamId": currentGameObject.strAwayMatchId as AnyObject]
        
        /*
        let dictParameter : [String:AnyObject]  = ["gameId": currentGameObject.strMatchId as AnyObject]*/
        var strUrl = String("")!
        strUrl = "\(base_Url)sporty-fans/get-team-ratio"
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            
            let dictFanMeter : NSDictionary  = ((response as NSDictionary).value(forKey: "data") as! NSDictionary)
            let intHomeCount : Int = dictFanMeter.value(forKey: "homeCount") as! Int
            let intAwayCount : Int = dictFanMeter.value(forKey: "awayCount") as! Int
            self.setFanSlider(intHomeCount: intHomeCount, intAwayCount: intAwayCount)
            
            self.callCheckFanChallenge()
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
            self.callCheckFanChallenge()
        }
    }
    //
    func callAddTeamRatio(strFollowTeam: String) {
        let dictParameter : [String:AnyObject]  = ["gameId": currentGameObject.strMatchId as AnyObject,"homeTeamId": currentGameObject.strHomeMatchId as AnyObject,"awayTeamId": currentGameObject.strAwayMatchId as AnyObject,"followTeam": strFollowTeam as AnyObject]
        var strUrl = String("")!
        strUrl = "\(base_Url)sporty-fans/add-team-ratio"
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            
            var dictFanMeter : NSDictionary  = ((response as NSDictionary).value(forKey: "data") as! NSDictionary)
            
            var intHomeCount : Int = dictFanMeter.value(forKey: "homeCount") as! Int
            var intAwayCount : Int = dictFanMeter.value(forKey: "awayCount") as! Int
            
            self.setFanSlider(intHomeCount: intHomeCount, intAwayCount: intAwayCount)
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    func callCheckFanChallenge() {
        let dictParameter : [String:AnyObject]  = ["gameId": currentGameObject.strMatchId as AnyObject, "homeTeamId": currentGameObject.strHomeMatchId as AnyObject, "awayTeamId": currentGameObject.strAwayMatchId as AnyObject]
        var strUrl = String("")!
        strUrl = "\(base_Url)sporty-fans-challenge/check"
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            let dicData : NSDictionary = (response as NSDictionary).value(forKey: "data")! as! NSDictionary
            var intFanFound : Int = dicData.value(forKey: "fanFound")! as! Int
            //Check if fan challenge has been created previously
            if intFanFound == 1 {
                //Showing alert that fan challenge has been created would you like to post
                self.cntHeight.constant = 100
            }
                //NO fan challenge has been created
            else
            {
                self.cntHeight.constant = 0
                //Call function to create fan challenge
                
            }
            print("\(dicData)")
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            self.cntHeight.constant = 0
            print("Error is \(response)")
        }
    }
    func callIsTeamRatioAdded() {
        let dictParameter : [String:AnyObject]  = ["gameId": currentGameObject.strMatchId as AnyObject, "homeTeamId": currentGameObject.strHomeMatchId as AnyObject, "awayTeamId": currentGameObject.strAwayMatchId as AnyObject]
        var strUrl = String("")!
        strUrl = "\(base_Url)sporty-fans/check"
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            let dicData : NSDictionary = (response as NSDictionary).value(forKey: "data")! as! NSDictionary
            var intFanFound : Int = dicData.value(forKey: "fanMeterFound")! as! Int
            //Check if fan challenge has been created previously
            if intFanFound == 1 {
                let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let postVC: ChallengePostListViewController = cameraStoryboard.instantiateViewController(withIdentifier: "ChallengePostListViewController") as! ChallengePostListViewController
                postVC.currentGameObject = self.currentGameObject
                postVC.bfromGameTimeline = false
                self.navigationController?.pushViewController(postVC, animated: true)
            }
            else
            {
                var arrGameList = Array<GameClass>()
                arrGameList.append(self.currentGameObject)
                let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tagDetailVC: TagGameVC = cameraStoryboard.instantiateViewController(withIdentifier: "TagGameVC") as! TagGameVC
                tagDetailVC.arrList = arrGameList
                self.navigationController?.pushViewController(tagDetailVC, animated: true)
            }
            
            print("\(dicData)")
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            
            print("Error is \(response)")
        }
    }
    
}

extension GameDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if(isFans == true) {
            return 2
            //return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 10
        if isFans == true {
            if section == 1 {
                if dictFan.allKeys.count > 0 {
                    var intCount = (dictFan.value(forKey: "celebrity") as! NSArray).count
                    return intCount
                }
                else {
                    return 0
                }
                
            }
            else
            {
                if dictFan.allKeys.count > 0 {
                    var intCount = (dictFan.value(forKey: "normal") as! NSArray).count
                    return intCount
                }
                else {
                    return 0
                }
            }
            //return arrFan.count
        }
        else
        {
            return arrNews.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(isFans == true) {
            if(section == 0) {
                return "     FRONT ROW"
            }
            else {
                return "     BUDDIES AT THE GAME"
            }
        }
        else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(isFans == true) {
            
            let cell: FansCell = tableView.dequeueReusableCell(withIdentifier: "FansCell") as! FansCell
            
            var dictInfo = NSDictionary()
            
            if(indexPath.section == 0) {
                dictInfo = (dictFan.value(forKey: "celebrity") as! NSArray).object(at: indexPath.row) as! NSDictionary
                //cell.ivVarify.isHidden = false
            }
            else {
                dictInfo = (dictFan.value(forKey: "normal") as! NSArray).object(at: indexPath.row) as! NSDictionary
                //cell.ivVarify.isHidden = true
            }
            
            
            if let name = dictInfo.value(forKey: "name") {
                cell.lblName.text = "\(name)"
            }
            
            if let team = dictInfo.value(forKey: "team") {
                cell.lblTeam.text = "\(team)"
            }
            
            if let followtime = dictInfo.value(forKey: "follow_time") {
                cell.lblTime.text = "\(followtime)"
            }
            
            if let isFollow = dictInfo.value(forKey: "is_follow") {
                if "\(isFollow)" == "1" {
                    cell.ivVarify.isHidden = false
                }
                else
                {
                    cell.ivVarify.isHidden = true
                }
            }
            
            if let img = dictInfo.value(forKey: "image") {
                let strImg = dictInfo.value(forKey: "image") as! String
                if strImg == "" {
                    
                }
                else
                {
                    let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
                    let url2 = URL(string: strURL)
                    if url2 != nil {
                        cell.ivImage.sd_setImage(with: url2, placeholderImage: nil)
                    }
                }
            }
            
            return cell
        }
        else {
            let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
            var dictInfo = arrNews[indexPath.row] as! NSDictionary
            
            if let img = dictInfo.value(forKey: "image") {
                //cell.imgUser.downloadImage(from: "\(img!)")
                let strImg = dictInfo.value(forKey: "image") as! String
                if strImg == "" {
                    
                }
                else
                {
                    let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
                    let url2 = URL(string: strURL)
                    if url2 != nil {
                        cell.imgUser.sd_setImage(with: url2, placeholderImage: nil)
                    }
                }
            }
            
            if let desc = dictInfo.value(forKey: "description") {
                cell.lblDescription.text = "\(desc)"
            }
            
            if let time = dictInfo.value(forKey: "news_time") {
                cell.lblFollowTime.text = "\(time)"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        var userDetail = arrList[indexPath.row]
//        
//        if(isSearching) {
//            userDetail = arrSearchList[indexPath.row]
//        }
//        
//        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let meVC = homeStoryboard.instantiateViewController(withIdentifier: "MeVC") as! MeVC
//        meVC.isOtherProfile = true
//        meVC.userDetail = userDetail
//        self.navigationController?.pushViewController(meVC, animated: true)
        
    }
    
    
    
    
    
}



