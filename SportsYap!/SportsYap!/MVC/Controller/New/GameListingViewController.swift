//
//  HomeVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 23/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import SwiftyJSON
class GameListingViewController: UIViewController {
    
    
    @IBOutlet weak var tblMatch: UITableView!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var vwNoGame: UIView!
    var dictStreamData = NSDictionary()
    //var strWowzaUrl = String("https://api-sandbox.cloud.wowza.com/api/v1/stream_sources")
    //Changed as suggested by Anuj 18-09-2017
//    var strWowzaUrl = String("https://cloud.wowza.com/api/v1/stream_sources")

    var strWowzaUrl = String("https://api.cloud.wowza.com/api/v1/stream_sources")

    @IBOutlet weak var btnTodayGame: UIButton!
    private var gameObj = GameClass()
    var arrList = Array<GameClass>()
    var arrTimelineData = NSArray()
    var arrLiveStream = NSArray()
    var intStreamChecked : Int = 0
    var strDate = ""
    var date = Date()
    
    var intSelectedTab : Int = 1
    
    var intMaxComment : Int = 2
    
    @IBOutlet weak var vwPostView: UIView!
    var intSelectedGame : Int = -1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTab()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tblMatch.estimatedRowHeight = 82.0
        self.tblMatch.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    func settingCurrentDate() {
        let dat = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        dateFormatter.timeZone = NSTimeZone.local
        var result1 = dateFormatter.string(from: dat)
        result1 = result1.uppercased()
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        var result2 = dateFormatter.string(from: dat)
        result2 = result2.capitalized
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let result3 = dateFormatter.date(from: result2)
        lblDate.text = result1
        strDate = result2
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        date = Date()
    }
    func changeTab() {
        let dat = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        dateFormatter.timeZone = NSTimeZone.local
        var result1 = dateFormatter.string(from: dat)
        result1 = result1.uppercased()
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        var result2 = dateFormatter.string(from: dat)
        result2 = result2.capitalized
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let result3 = dateFormatter.date(from: result2)
        lblDate.text = result1
        
        strDate = result2
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        date = Date()
        btnNext.isHidden = false
        btnPrevious.isHidden = false
        lblDate.isHidden = false
        btnTodayGame.setTitleColor(UIColor.black, for: .normal)
        self.arrList.removeAll()
        self.tblMatch.reloadData()
        getFootballGameData()
    }
    @IBAction func btnBackClicked(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getNextDate(btnSender: UIButton) {
        self.getDate(isNext: true, isPrevious: false)
        self.getFootballGameData()
    }
    
    @IBAction func getPreviousDate(btnSender: UIButton) {
        self.getDate(isNext: false, isPrevious: true)
        self.getFootballGameData()
    }
    
    private func getDate(isNext:Bool, isPrevious:Bool) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        strDate = formatter.string(from: date)
        if(isNext == true) {
            let myDate = formatter.date(from: strDate)!
            date = Calendar.current.date(byAdding: .day, value: 1, to: myDate)!
            strDate = formatter.string(from: date)
        }
        else if(isPrevious == true) {
            let myDate = formatter.date(from: strDate)!
            date = Calendar.current.date(byAdding: .day, value: -1, to: myDate)!
            strDate = formatter.string(from: date)
        }
        
        let formatterDisp = DateFormatter()
        formatterDisp.dateFormat = "MMMM dd"
        
        var strNewDate = "\(date.dayOfWeek()!), \(formatterDisp.string(from: date))"
        strNewDate = strNewDate.uppercased()
        lblDate.text = strNewDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getFootballGameData() {
        self.vwNoGame.isHidden = true
        self.arrList.removeAll()
        self.tblMatch.reloadData()
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/football/nfl-scores?date=\(strDate)&json=1"
        gameObj.getGameListFor(showLoader: true, strFullURL:strURL ,strMatchType: "football", strDate: "15.01.2017", success: { (response) in
            
            self.arrList = response
            self.getBaseballGameData()
            
        }, failed: { (responser) in
            
            self.getBaseballGameData()
        })
        
    }
    
    
    private func getFeedsList() {
        self.arrList.removeAll()
        self.tblMatch.reloadData()
        
        var strURL = String("")!
        strURL = "\(base_Url)posts/getlist"
        MainReqeustClass.BaseRequestSharedInstance.getData(showLoader: true, url: strURL, parameter: nil, success: { (response:Dictionary<String, AnyObject>) in
            //self.strMatchTpe = strMatchType
            let arrData = response as NSDictionary
            print("Data is \(arrData)")
            
            self.arrTimelineData = NSArray()
            self.arrTimelineData =  arrData.value(forKey: "data") as! NSArray
            self.tblMatch.reloadData()
            /*
             var dict = JSON(response).dictionaryValue
             let tempArray = dict["data"]?.arrayValue
             
             arrTimelineData = NSMutableArray()
             arrTimelineData = dict["data"]?.arrayValue
             
             let tempDict = tempArray?[0].dictionaryValue
             
             print("\(tempArray)")
             print("\(tempDict?["image"]?.stringValue)")
             */
            /*
             var dict = JSON(response.result.value ?? "").dictionaryValue
             
             if(dict["code"]?.intValue == 500) {
             failed((dict["message"]?.stringValue)!)
             }
             else {
             success(dict as Dictionary<String, AnyObject>)
             }
             */
            
            
            //let arrList = self.parsingGameList(responseReq: response as NSDictionary)
            
        }) { (response:String!) in
            print("Response is not proper")
        }
        
        
    }
    private func getBaseballGameData() {
        
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/baseball/usa?date=\(strDate)&json=1"
        
        //let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/baseball/usa?date=15.01.2017&json=1"
        
        //let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/football/nfl-scores?date=15.01.2017&json=1"
        
        gameObj.getGameListFor(showLoader: true, strFullURL:strURL, strMatchType: "baseball", strDate: "15.01.2017", success: { (response) in
            
            for i in 0..<response.count {
                self.arrList.append(response[i])
            }
            self.getBasketballGameData()
            
        }, failed: { (responser) in
            
            self.getBasketballGameData()
            
        })
        
    }
    
    private func getBasketballGameData() {
        
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/bsktbl/nba-scores?json=1&date=\(strDate)"
        
        //let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/bsktbl/nba-scores?json=1&date=15.01.2017"
        
        gameObj.getGameListFor(showLoader: true, strFullURL:strURL ,strMatchType: "bsktbl", strDate: "15.01.2017", success: { (response) in
            
            for i in 0..<response.count {
                self.arrList.append(response[i])
            }
            self.getHockeyGameData()
            
        }, failed: { (responser) in
            
            self.getHockeyGameData()
            
        })
        
    }
    
    private func getHockeyGameData() {
        
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/hockey/nhl-scores?date=\(strDate)&json=1"
        
        //let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/hockey/nhl-scores?date=15.01.2017&json=1"
        
        gameObj.getGameListFor(showLoader: true, strFullURL:strURL, strMatchType: "hockey", strDate: "15.01.2017", success: { (response) in
            
            
            for i in 0..<response.count {
                self.arrList.append(response[i])
            }
            
            if self.arrList.count == 0 {
                self.vwNoGame.isHidden = false
            }
            else {
                self.vwNoGame.isHidden = true
            }
            
            
            self.tblMatch.reloadData()
            
            
            //            self.getSoccerGameData()
            
        }, failed: { (responser) in
            if self.arrList.count == 0 {
                self.vwNoGame.isHidden = false
            }
            else {
                self.vwNoGame.isHidden = true
            }
            self.tblMatch.reloadData()
            
            //            showAlert(strMsg: responser as String, vc: self)
            //            self.getSoccerGameData()
            
        })
        
    }
    
    private func getSoccerGameData() {
        
        //let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/commentaries/soccernew?date=\(strDate)&json=1"
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/commentaries/soccernew?date=15.01.2017&json=1"
        
        gameObj.getGameListFor(showLoader: true, strFullURL:strURL, strMatchType: "commentaries", strDate: "15.01.2017", success: { (response) in
            
            for i in 0..<response.count {
                self.arrList.append(response[i])
            }
            
            self.tblMatch.reloadData()
            
            
        }, failed: { (responser) in
            
            self.tblMatch.reloadData()
            
            //            showAlert(strMsg: responser as String, vc: self)
            
        })
        
    }
    
    //MARK: Button Actions
    @IBAction func btnCreateImagePostClicked(sender: UIButton)
    {
        vwPostView.isHidden = true
        /*
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        postVC.isImageUploaded = true
        self.navigationController?.pushViewController(postVC, animated: true)*/
        
        
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: GameTimeLinePostVC = cameraStoryboard.instantiateViewController(withIdentifier: "GameTimeLinePostVC") as! GameTimeLinePostVC
        postVC.selectedGame = arrList[intSelectedGame]
        postVC.isImageUploaded = true
        self.navigationController?.pushViewController(postVC, animated: true)
        //postVC.isImageUploaded = true
    }
    
    @IBAction func btnCreateVideoPostClicked(sender: UIButton)
    {
        vwPostView.isHidden = true
//        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
//        postVC.isVideoUploaded = true
//        self.navigationController?.pushViewController(postVC, animated: true)
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: GameTimeLinePostVC = cameraStoryboard.instantiateViewController(withIdentifier: "GameTimeLinePostVC") as! GameTimeLinePostVC
        postVC.selectedGame = arrList[intSelectedGame]
        postVC.isVideoUploaded = true
        self.navigationController?.pushViewController(postVC, animated: true)

    }
    @IBAction func btnCreateliveStreamingClicked(sender: UIButton)
    {
        vwPostView.isHidden = true
        self.getLiveStream()
    }
    @IBAction private func btnClosePostView(_ :UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
        }, completion: {
            (value: Bool) in
            
            self.vwPostView.isHidden = true
        })
    }

    
}

extension GameListingViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
            tableView.deselectRow(at: indexPath, animated: true)
            intSelectedGame = indexPath.row
            self.callCheckFanChallenge()
        
        //        tableView.deselectRow(at: indexPath, animated: true)
//        
//        view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
//        vwPostView.isHidden = false

       /* let uiAlert = UIAlertController(title: AppName, message: "Select Option:", preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Live Streaming", style: .default, handler: { action in
            //self.callWowzaApi()
            self.getLiveStream()
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            
        }))
        self.present(uiAlert, animated: true, completion: nil)*/
        
        /*
         tableView.deselectRow(at: indexPath, animated: true)
         let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let tagDetailVC: TagGameVC = cameraStoryboard.instantiateViewController(withIdentifier: "TagGameVC") as! TagGameVC
         tagDetailVC.arrList = arrList
         self.navigationController?.pushViewController(tagDetailVC, animated: true)*/
        
    }
    func callCheckFanChallenge()
    {
        if intSelectedGame != -1
        {
            let gameObj : GameClass =  arrList[intSelectedGame]
            let dictParameter : [String:AnyObject]  = ["gameId": gameObj.strMatchId as AnyObject, "homeTeamId": gameObj.strHomeMatchId as AnyObject, "awayTeamId": gameObj.strAwayMatchId as AnyObject]
            //let dictParameter : [String:AnyObject]  = ["gameId": 1 as AnyObject, "homeTeamId": 1699 as AnyObject, "awayTeamId": 1701 as AnyObject]
            var strUrl = String("")!
            strUrl = "\(base_Url)posts/check-game-timeline"
            MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
                let dicData : NSDictionary = (response as NSDictionary).value(forKey: "data")! as! NSDictionary
                
                let intFanFound : Int = dicData.value(forKey: "postFound")! as! Int
                
                if intFanFound == 1
                {
                    let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let postVC: ChallengePostListViewController = cameraStoryboard.instantiateViewController(withIdentifier: "ChallengePostListViewController") as! ChallengePostListViewController
                    postVC.currentGameObject = gameObj
                    postVC.bfromGameTimeline = true
                    self.navigationController?.pushViewController(postVC, animated: true)
                }
                else
                {
                    //Call function to create fan challenge
                    self.view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
                    self.vwPostView.isHidden = false
                }
                //showAlert(strMsg: "\(dicData.value(forKey: "message")!)", vc: self)
                print("\(dicData)")
            })
            {
                (response:String!) in
                showAlert(strMsg: response, vc: self)
                print("Error is \(response)")
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : matchCell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! matchCell
        let gameDetail = arrList[indexPath.row]
        cell.lblScore1.text = gameDetail.strTeam1Score
        cell.lblScore2.text = gameDetail.strTeam2Score
        cell.lblTime.text = "VS\n\(gameDetail.strTime)"
        cell.lblFirstNameTeam1.text = gameDetail.strTeam1FirstName
        cell.lblLastNameTeam1.text = gameDetail.strTeam1LastName
        cell.lblFirstNameTeam2.text = gameDetail.strTeam2FirstName
        cell.lblLastNameTeam2.text = gameDetail.strTeam2LastName
        if gameDetail.strMatchTpe == "football" {
            cell.ivImage.image = UIImage(named: "Game_image1")
        }
        else if gameDetail.strMatchTpe == "baseball" {
            cell.ivImage.image = UIImage(named: "Game_image2")
        }
        else if gameDetail.strMatchTpe == "bsktbl" {
            cell.ivImage.image = UIImage(named: "Game_image3")
        }
        else if gameDetail.strMatchTpe == "hockey" {
            cell.ivImage.image = UIImage(named: "Game_image0")
        }
        else
        {
            cell.ivImage.image = UIImage(named: "Game_image0")
        }
        return cell
    }
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
                    self.intStreamChecked = self.intStreamChecked + 1
                }
                
                
            }) { (response:String!) in
                showAlert(strMsg: response, vc: self)
                print("Error is \(response)")
            }
        
        }
        else
        {
            
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
