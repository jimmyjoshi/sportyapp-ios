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
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var btnTodayGame: UIButton!
    private var gameObj = GameClass()
    var arrList = Array<GameClass>()
    var arrTimelineData = NSArray()
    var strDate = ""
    var date = Date()
    
    var intSelectedTab : Int = 1
    
    var intMaxComment : Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tblMatch.estimatedRowHeight = 82.0
        self.tblMatch.rowHeight = UITableViewAutomaticDimension
        changeTab()
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
        
        let strURL = "http://52.66.73.127/sportyapp/public/api/posts/getlist"
        
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
            
            self.tblMatch.reloadData()
            self.activity.isHidden = true
            
            //            self.getSoccerGameData()
            
        }, failed: { (responser) in
            
            self.tblMatch.reloadData()
            self.activity.isHidden = true
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
            self.activity.isHidden = true
            
        }, failed: { (responser) in
            
            self.tblMatch.reloadData()
            self.activity.isHidden = true
            //            showAlert(strMsg: responser as String, vc: self)
            
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let uiAlert = UIAlertController(title: AppName, message: "Select Option:", preferredStyle: UIAlertControllerStyle.alert)
        uiAlert.addAction(UIAlertAction(title: "Image", style: .default, handler: { action in
            
        }))
        uiAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            
        }))
        uiAlert.addAction(UIAlertAction(title: "Live Streaming", style: .default, handler: { action in
            /*
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let postVC: PostToGameViewController = cameraStoryboard.instantiateViewController(withIdentifier: "PostToGameViewController") as! PostToGameViewController
            self.navigationController?.pushViewController(postVC, animated: true)*/
        }))
        
        uiAlert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
           
        }))
        self.present(uiAlert, animated: true, completion: nil)
        
        /*
        tableView.deselectRow(at: indexPath, animated: true)
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: TagGameVC = cameraStoryboard.instantiateViewController(withIdentifier: "TagGameVC") as! TagGameVC
        tagDetailVC.arrList = arrList
        self.navigationController?.pushViewController(tagDetailVC, animated: true)*/
        
        
        
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
