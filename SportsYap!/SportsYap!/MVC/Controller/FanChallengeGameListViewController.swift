//
//  HomeVC.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 28/10/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import SwiftyJSON
class FanChallengeGameListViewController: UIViewController {
    @IBOutlet weak var tblMatch: UITableView!
    @IBOutlet weak var vwNoGame: UIView!
    @IBOutlet weak var vwPostView: UIView!
    var dictStreamData = NSDictionary()
    
    private var gameObj = GameClass()
    var arrList = Array<GameClass>()
    var arrTimelineData = NSArray()
    var arrLiveStream = NSArray()
    var intStreamChecked : Int = 0
    var strDate = ""
    var date = Date()
    
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
    /*
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
        
        strDate = result2
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        date = Date()
    }*/
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
        
        
        strDate = result2
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        date = Date()
        
        self.arrList.removeAll()
        self.tblMatch.reloadData()
        getFootballGameData()
    }
    @IBAction func btnBackClicked(sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getFootballGameData() {
        self.vwNoGame.isHidden = true
        self.arrList.removeAll()
        self.tblMatch.reloadData()
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/football/nfl-scores?date=\(strDate)&json=1"
        
        //let strURL = "http://69.64.77.92/getfeed/596fc07949d14d3c8c5684dcb8712ce8/football/nfl-scores?json=1"
        
        
        gameObj.getGameListFor(showLoader: true, strFullURL:strURL ,strMatchType: "football", strDate: "15.01.2017", success: { (response) in
            
            self.arrList = response
            self.getBaseballGameData()
            
        }, failed: { (responser) in
            
            self.getBaseballGameData()
        })
        
    }

    private func getBaseballGameData() {
        
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/baseball/usa?date=\(strDate)&json=1"
        
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
        }, failed: { (responser) in
            if self.arrList.count == 0 {
                self.vwNoGame.isHidden = false
            }
            else {
                self.vwNoGame.isHidden = true
            }
            self.tblMatch.reloadData()
        })
        
    }
    
    @IBAction func btnActionImageClicked(sender: UIButton){
        
        if intSelectedGame != -1 {
            vwPostView.isHidden = true
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
            postVC.isImageUploaded = true
            postVC.selectedGame = arrList[intSelectedGame] 
            postVC.isCreateFanChallengeScreen = true
            self.navigationController?.pushViewController(postVC, animated: true)
        }
        
        
    }
    
    @IBAction func btnActionVideoClicked(sender: UIButton){
        if intSelectedGame != -1 {
            vwPostView.isHidden = true
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
            postVC.isVideoUploaded = true
            postVC.isCreateFanChallengeScreen = true
            postVC.selectedGame = arrList[intSelectedGame] 
            self.navigationController?.pushViewController(postVC, animated: true)
        }
       
    }
    @IBAction func btnCloseOptionView(sender: UIButton) {
        //view?.backgroundColor = UIColor(white: 1, alpha: 1)
       self.hidePostView()
    }
    
    private func getSoccerGameData() {
        
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/commentaries/soccernew?date=15.01.2017&json=1"
        
        gameObj.getGameListFor(showLoader: true, strFullURL:strURL, strMatchType: "commentaries", strDate: "15.01.2017", success: { (response) in
            for i in 0..<response.count {
                self.arrList.append(response[i])
            }
            self.tblMatch.reloadData()
        }, failed: { (responser) in
            self.tblMatch.reloadData()
        })
        
    }
    //MARK:- Create New Fan Challenge API
    func callCreateNewFanChallenge() {
        if intSelectedGame != -1 {
            let gameObj : GameClass =  arrList[intSelectedGame]
            let dictParameter : [String:AnyObject]  = ["gameId": gameObj.strMatchId as AnyObject, "homeTeamId": gameObj.strHomeMatchId as AnyObject, "awayTeamId": gameObj.strAwayMatchId as AnyObject]
            //let dictParameter : [String:AnyObject]  = ["gameId": 1 as AnyObject, "homeTeamId": 1699 as AnyObject, "awayTeamId": 1701 as AnyObject]
            var strUrl = String("")!
            strUrl = "\(base_Url)sporty-fans-challenge/create"
            MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
                let dicData : NSDictionary = (response as NSDictionary).value(forKey: "data")! as! NSDictionary
                
                print("\(dicData)")
                
                let uiAlert = UIAlertController(title: AppName, message: "\(dicData.value(forKey: "message")!)", preferredStyle: UIAlertControllerStyle.alert)
                uiAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(uiAlert, animated: true, completion: nil)
                
            }) { (response:String!) in
                showAlert(strMsg: response, vc: self)
                print("Error is \(response)")
            }
        }
    }
    
    
    func callCheckFanChallenge() {
        if intSelectedGame != -1 {
            let gameObj : GameClass =  arrList[intSelectedGame]
            let dictParameter : [String:AnyObject]  = ["gameId": gameObj.strMatchId as AnyObject, "homeTeamId": gameObj.strHomeMatchId as AnyObject, "awayTeamId": gameObj.strAwayMatchId as AnyObject]
            //let dictParameter : [String:AnyObject]  = ["gameId": 1 as AnyObject, "homeTeamId": 1699 as AnyObject, "awayTeamId": 1701 as AnyObject]
            var strUrl = String("")!
            strUrl = "\(base_Url)sporty-fans-challenge/check"
            MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
                let dicData : NSDictionary = (response as NSDictionary).value(forKey: "data")! as! NSDictionary
                
                
                var intFanFound : Int = dicData.value(forKey: "fanFound")! as! Int
                
                //Check if fan challenge has been created previously
                if intFanFound == 1 {
                    //Showing alert that fan challenge has been created would you like to post
                    self.openActionSheet()
                }
                //NO fan challenge has been created
                else
                {
                    //Call function to create fan challenge
                    self.callCreateNewFanChallenge()
                }
                //showAlert(strMsg: "\(dicData.value(forKey: "message")!)", vc: self)
                print("\(dicData)")
            }) { (response:String!) in
                showAlert(strMsg: response, vc: self)
                print("Error is \(response)")
            }
        }
    }
    
    func openActionSheet() {
        let uiAlert = UIAlertController(title: AppName, message: "Fan Challenge has been created. Would you like to post?", preferredStyle: UIAlertControllerStyle.alert)
         uiAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
         //Code for opening
            self.showPostView()
         }))
         
         uiAlert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { action in
         
         }))
         self.present(uiAlert, animated: true, completion: nil)
    }
    //MARK:- Hide and Show Pop Up View for displaying option for images and video.
    func showPostView(){
        vwPostView.isHidden = false
    }
    func hidePostView(){
        vwPostView.isHidden = true
    }
}

extension FanChallengeGameListViewController: UITableViewDataSource,UITableViewDelegate {
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
}
