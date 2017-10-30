//
//  HomeVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 23/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import SwiftyJSON


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var tblMatch: UITableView!
    @IBOutlet weak var cvMatchList: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBOutlet weak var btnTodayGame: UIButton!
    @IBOutlet weak var btnTimeline: UIButton!
    
    @IBOutlet weak var vwNoGame: UIView!
    
    private var gameObj = GameClass()
    
    var arrList = Array<GameClass>()
    var arrTimelineData = NSArray()
    var strDate = ""
    var date = Date()
    
    var intSelectedTab : Int = 1
    
    var intMaxComment : Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addBtnToTab()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        //self.settingCurrentDate()
        //lblDate.text = "Sunday, January 15"
        
        
        
        //cvMatchList.register(UINib(nibName: "MatchCCell", bundle: nil), forCellWithReuseIdentifier: "MatchCCell")
        
        
        //cvMatchList.register(UINib(nibName: "TimelineCell", bundle: nil), forCellWithReuseIdentifier: "TimelineCell")
        
        cvMatchList.isHidden = true
        if(AppUserDefaults.getValueForKey(key: "SHOWTUTORIAL") == "YES") {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tutorialVC = storyboard.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
                
                appDelegate.tabbar.view.addSubview(tutorialVC.view)
                appDelegate.tabbar.addChildViewController(tutorialVC)
                
                AppUserDefaults.setValue(value: "NO", key: "SHOWTUTORIAL")
                
            }
            
        
        }
        //Temporary commented
        //self.getDate(isNext: false, isPrevious: false)
        
        //lblDate.text = "SUNDAY, JANUARY 15"
        
        //strDate = "15.01.2017"
        //let formatter = DateFormatter()
        //formatter.dateFormat = "dd.MM.yyyy"
        //date = formatter.date(from: strDate)!
        
        //self.tblMatch.sectionHeaderHeight = 0//UITableViewAutomaticDimension
        //self.tblMatch.estimatedSectionHeaderHeight = 400
        
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
        
        
        
        print(Date().localDateString())
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let result3 = dateFormatter.date(from: result2)
        
        
        
        lblDate.text = result1
        
        strDate = result2
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        date = Date()
        
        
        
        print("Result \(result1)")
        print("Result2 \(result2)")
        print("Result3 \(result3)")
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
        /*
        strDate = "15.01.2017"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        date = formatter.date(from: strDate)!
        */
        if intSelectedTab == 0 {
            btnNext.isHidden = true
            btnPrevious.isHidden = true
            lblDate.isHidden = true
            
            
            btnTimeline.setTitleColor(UIColor.black, for: .normal)
            btnTodayGame.setTitleColor(UIColor.lightGray, for: .normal)
            self.arrTimelineData = NSMutableArray()
            self.tblMatch.reloadData()
            
            getFeedsList()
            
            //cvMatchList.reloadData()
        }
        else if intSelectedTab == 1 {
            btnNext.isHidden = false
            btnPrevious.isHidden = false
            lblDate.isHidden = false
            btnTimeline.setTitleColor(UIColor.lightGray, for: .normal)
            btnTodayGame.setTitleColor(UIColor.black, for: .normal)
            self.arrList.removeAll()
            self.tblMatch.reloadData()
            getFootballGameData()
        }
    }
    @IBAction func btnActionTimelineClicked(btnSender: UIButton) {
        lblDate.text = "SUNDAY, JANUARY 15"
        strDate = "15.01.2017"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        date = formatter.date(from: strDate)!
        
        intSelectedTab = 0
        changeTab()
    }
    
    @IBAction func btnActionTodayGameClicked(btnSender: UIButton) {
        lblDate.text = "SUNDAY, JANUARY 15"
        strDate = "15.01.2017"
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        date = formatter.date(from: strDate)!
        
        
        
        intSelectedTab = 1
        changeTab()
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
        vwNoGame.isHidden = true
        self.arrList.removeAll()
        self.tblMatch.reloadData()
        
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/football/nfl-scores?date=\(strDate)&json=1"
        
        //let strURL = "http://69.64.77.92/getfeed/596fc07949d14d3c8c5684dcb8712ce8/football/nfl-scores?json=1"
        
        //let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/football/nfl-scores?date=15.01.2017&json=1"
        
        
        gameObj.getGameListFor(showLoader: true, strFullURL:strURL ,strMatchType: "football", strDate: "15.01.2017", success: { (response) in
            
            self.arrList = response
            self.getBaseballGameData()
            
        }, failed: { (responser) in
            
            self.getBaseballGameData()
        })
        
    }
    
    
    private func getFeedsList() {
        self.vwNoGame.isHidden = true
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
            else
            {
                self.vwNoGame.isHidden = true
            }
            self.tblMatch.reloadData()
            self.activity.isHidden = true
            
//            self.getSoccerGameData()
            
        }, failed: { (responser) in
            if self.arrList.count == 0 {
                self.vwNoGame.isHidden = false
            }
            else
            {
                self.vwNoGame.isHidden = true
            }
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

extension HomeVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if intSelectedTab == 0 {
            return arrTimelineData.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if intSelectedTab == 0 {
            let mainDict : NSDictionary = arrTimelineData.object(at: section) as! NSDictionary
            let arrComment : NSArray = mainDict.value(forKey: "postComments") as! NSArray
            
            var count : Int = (arrComment.count > intMaxComment) ? intMaxComment : arrComment.count
            count = count + 1
            return count
        }
        else
        {
            return arrList.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {         
        let cell : timelineCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell") as! timelineCell
        
        let dict : NSDictionary = arrTimelineData.object(at: section) as! NSDictionary
        cell.lblTime.text = dict.value(forKey: "created_at") as! String
        
        cell.lblVenue.text = dict.value(forKey: "description") as! String
        cell.txtVenue?.text = dict.value(forKey: "description") as! String

        
        let intLikeCount : Int = dict.value(forKey: "postLikeCount") as! Int
        let intCommentCount : Int = dict.value(forKey: "postCommentCount") as! Int
        //For Like
        if intLikeCount > 0 {
            cell.btnLike.setTitle("\(intLikeCount) Likes", for: .normal)
        }
        else {
            cell.btnLike.setTitle("Like", for: .normal)
        }
        cell.btnLike.tag = section
        cell.btnLike.addTarget(self, action: #selector(self.btnLikeClicked(sender:)), for: .touchUpInside)
        
        //For Comment
        if intCommentCount > 0 {
            cell.btnComment.setTitle("\(intCommentCount) Comments", for: .normal)
        }
        else
        {
            cell.btnComment.setTitle("Comment", for: .normal)
        }
        cell.btnComment.tag = section
        cell.btnComment.addTarget(self, action: #selector(self.btnCommentClicked(sender:)), for: .touchUpInside)
        //cell.imgGameType.image = UIImage(named: "sball0")
        
        if let intIsLiked = dict.value(forKey: "is_liked") {
            if "\(intIsLiked)" == "0" {
                cell.btnLike.backgroundColor = UIColor.white
                cell.btnLike.setTitleColor(#colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1), for: .normal)
            }
            else
            {
                cell.btnLike.backgroundColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1)
                cell.btnLike.setTitleColor(UIColor.white, for: .normal)
            }
        }
        let strImg = dict.value(forKey: "image") as! String
        if strImg == "" {
            cell.heightLayout.constant = 0
        }
        else
        {
            cell.heightLayout.constant = 234
            cell.imgPost.layer.cornerRadius = 10.0
            cell.imgPost.clipsToBounds = true
            cell.imgPost.tag = section
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.imgTapped(sender:)))
            cell.imgPost.addGestureRecognizer(gesture)
            
            let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
            let url2 = URL(string: strURL)
            if url2 != nil {
                cell.imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
            }
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if intSelectedTab == 1 {
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if intSelectedTab == 1 {
            return UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if intSelectedTab == 1 {/*
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tagDetailVC: TagGameVC = cameraStoryboard.instantiateViewController(withIdentifier: "TagGameVC") as! TagGameVC
            tagDetailVC.arrList = arrList
            self.navigationController?.pushViewController(tagDetailVC, animated: true)*/
            appDelegate.arrGameList = arrList
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let gameDetailVC: GameDetailVC = cameraStoryboard.instantiateViewController(withIdentifier: "GameDetailVC") as! GameDetailVC
            gameDetailVC.isCurrentMatch = true
            var gameObject : GameClass = arrList[indexPath.row] as! GameClass
            gameDetailVC.currentGameObject = gameObject
            self.navigationController?.pushViewController(gameDetailVC, animated: true)
            
            
        }
        else
        {
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tagDetailVC: CommentViewController = cameraStoryboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
            tagDetailVC.dictPost = arrTimelineData.object(at: indexPath.section) as! NSDictionary
            tagDetailVC.objHomeVc = self
            tagDetailVC.modalPresentationStyle = .overCurrentContext
            self.present(tagDetailVC, animated: true, completion: nil)
            //self.view.addSubview(tagDetailVC.view)
            //self.addChildViewController(tagDetailVC)
            
            //self.navigationController?.pushViewController(tagDetailVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var mainCell = UITableViewCell()
        
        
        if intSelectedTab == 1 {
            
            //let cell: matchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchCell", for: indexPath) as! matchCell
            let cell : matchCell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! matchCell
            
            //cell.ivChallenge.isHidden = true
            //cell.lblStatusIcon.isHidden = true
            
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
            //        if(indexPath.row == 0) {
            //            cell.ivChallenge.isHidden = false
            //            cell.lblStatusIcon.isHidden = false
            //        }
            //        else {
            //            cell.ivChallenge.isHidden = true
            //            cell.lblStatusIcon.isHidden = true
            //        }
            
            //cell.ivImage.image = UIImage(named: "Game_image\(0)")
            
            
            mainCell = cell
            
        }
        else if intSelectedTab == 0 {
            
            
            
            if indexPath.row == 0 {
                let cell : timelineCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell") as! timelineCell
                
                let dict : NSDictionary = arrTimelineData.object(at: indexPath.section) as! NSDictionary
                //cell.lblTime.text = dict.value(forKey: "created_at") as! String
                
                if let dictUser = dict.value(forKey: "postCreator") {
                    cell.lblName.text = (dictUser as! NSDictionary).value(forKey: "name") as! String?

                    //cell.lblName.text = "\(dictUser)"
                }
                cell.lblVenue.text = dict.value(forKey: "description") as? String
                cell.txtVenue?.text = dict.value(forKey: "description") as? String
                cell.txtVenue?.sizeToFit()

                let intLikeCount : Int = dict.value(forKey: "postLikeCount") as! Int
                let intCommentCount : Int = dict.value(forKey: "postCommentCount") as! Int
                //For Like
                if intLikeCount > 0 {
                    cell.btnLike.setTitle("\(intLikeCount) Likes", for: .normal)
                }
                else {
                    cell.btnLike.setTitle("Like", for: .normal)
                }
                cell.btnLike.tag = indexPath.section
                cell.btnLike.addTarget(self, action: #selector(self.btnLikeClicked(sender:)), for: .touchUpInside)
                
                //For Comment
                if intCommentCount > 0 {
                    cell.btnComment.setTitle("\(intCommentCount) Comments", for: .normal)
                }
                else
                {
                    cell.btnComment.setTitle("Comment", for: .normal)
                }
                cell.btnComment.tag = indexPath.section
                cell.btnComment.addTarget(self, action: #selector(self.btnCommentClicked(sender:)), for: .touchUpInside)
                //cell.imgGameType.image = UIImage(named: "sball0")
                
                if let intIsLiked = dict.value(forKey: "is_liked") {
                    if "\(intIsLiked)" == "0" {
                        cell.btnLike.backgroundColor = UIColor.white
                        cell.btnLike.setTitleColor(#colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1), for: .normal)
                    }
                    else
                    {
                        cell.btnLike.backgroundColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1)
                        cell.btnLike.setTitleColor(UIColor.white, for: .normal)
                    }
                }
                /*
                let strvideo = dict.value(forKey: "video") as! String
                if strvideo == "" {
                }
                else
                {
                    cell.lblVenue.text = (dict.value(forKey: "description") as? String)! + "\n\(strvideo)"
                    cell.txtVenue?.text = (dict.value(forKey: "description") as? String)! + "\n\(strvideo)"
                }
                cell.txtVenue?.isScrollEnabled = false
                cell.txtVenue?.sizeToFit()
                */
                
                let strImg = dict.value(forKey: "image") as! String
                let strvideo = dict.value(forKey: "video") as! String
                if strImg == ""  && strvideo == "" {
                    cell.heightLayout.constant = 0
                }
                else
                {
                    cell.heightLayout.constant = screenWidth
                    //cell.imgPost.layer.cornerRadius = 10.0
                    //cell.imgPost.clipsToBounds = true
                    cell.imgPost.tag = indexPath.section
                    let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.imgTapped(sender:)))
                    cell.imgPost.addGestureRecognizer(gesture)
                    
                    var strURL = String("")!
                    //Video thumbnai is to be displayed
                    if strImg == "" {
                        let strVideoThumbUrl = dict.value(forKey: "videoImg") as! String
                       strURL = strVideoThumbUrl.replacingOccurrences(of: " ", with: "%20")
                        /*let imgVw : UIImageView = UIImageView(frame: CGRect(x: (screenWidth - 50)/2, y: (screenWidth - 50)/2, width: 50, height: 50))
                        imgVw.image = UIImage(named: "nogameIcon")
 
                        cell.imgPost.addSubview(imgVw)*/
                        
                    }
                    else
                    {
                        strURL = strImg.replacingOccurrences(of: " ", with: "%20")
                    }
                    
                    //let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
                    let url2 = URL(string: strURL)
                    if url2 != nil {
                        cell.imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
                    }
                }
                mainCell = cell
            }
            else
            {
            let cell: commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! commentCell
            let mainDict : NSDictionary = arrTimelineData.object(at: indexPath.section) as! NSDictionary
            let arrComment : NSArray = mainDict.value(forKey: "postComments") as! NSArray
            
            var total : Int = arrComment.count
        
            total = (total > intMaxComment) ? (total - intMaxComment) + indexPath.row : indexPath.row
            
            total = total - 1
            //total = (total - 2) + indexPath.row
            
            //let arrComment : NSArray = mainDict.value(forKey: "postComments") as! NSArray
            let dictComment : NSDictionary = arrComment.object(at: total) as! NSDictionary
                
            let strUserName : String = dictComment.value(forKey: "name") as! String
                
            let strComment : String = dictComment.value(forKey: "commentText") as! String
            
            let usernameFont = UIFont.boldSystemFont(ofSize:  17.0)
            var attrUserNameString = NSMutableAttributedString(
                    string: strUserName + ": ",
                    attributes: [NSFontAttributeName:usernameFont,NSForegroundColorAttributeName:UIColor.black])
            let commentFont = UIFont.systemFont(ofSize: 17.0)
            let attrCommentString = NSMutableAttributedString(
                    string: strComment,
                    attributes: [NSFontAttributeName:commentFont])
            attrUserNameString.append(attrCommentString)
                
            //cell.lblUserName.text = dictComment.value(forKey: "name") as! String
            cell.lblComment.attributedText = attrUserNameString//strUserName + ": " + strComment//dictComment.value(forKey: "commentText") as! String
            cell.lblTime.text = dictComment.value(forKey: "commentCreatedAt") as! String
            var strImgLink : String = "\(dictComment.value(forKey: "image")!)"
            let strURL : String = strImgLink.replacingOccurrences(of: " ", with: "%20")
            let url2 = URL(string: strURL)
            if url2 != nil {
                cell.imgUser.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_image"))
            }
            mainCell = cell
                
            }
        }
    return mainCell
    }
    
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    //Collection view delegare
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if intSelectedTab == 0 {
            return arrTimelineData.count
        }
        return arrList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        //return CGSize(width: (screenWidth*304)/320, height: (screenHeight*130)/568)
        
        if intSelectedTab == 1 {
            return CGSize(width: (screenWidth*304)/320, height: 125)
        }
        else if intSelectedTab == 0 {
            let dict : NSDictionary = arrTimelineData.object(at: indexPath.row) as! NSDictionary
            var strImg = dict.value(forKey: "image") as! String
            
            if strImg == "" {
                return CGSize(width: (screenWidth*304)/320, height: 125)
            }
            else
            {
                return CGSize(width: (screenWidth*304)/320, height: 250)
            }
            
        }
        return CGSize(width: (screenWidth*304)/320, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var mainCell = UICollectionViewCell()
        
        
        if intSelectedTab == 1 {
        
            let cell: MatchCCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCCell", for: indexPath) as! MatchCCell
            
            cell.ivChallenge.isHidden = true
            cell.lblStatusIcon.isHidden = true
            
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
            //        if(indexPath.row == 0) {
            //            cell.ivChallenge.isHidden = false
            //            cell.lblStatusIcon.isHidden = false
            //        }
            //        else {
            //            cell.ivChallenge.isHidden = true
            //            cell.lblStatusIcon.isHidden = true
            //        }
            
            //cell.ivImage.image = UIImage(named: "Game_image\(0)")
            
            
            mainCell = cell
            
        }
        else if intSelectedTab == 0 {
            let cell: TimelineCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineCell", for: indexPath) as! TimelineCell
            
            let dict : NSDictionary = arrTimelineData.object(at: indexPath.row) as! NSDictionary
            
            cell.lblTime.text = dict.value(forKey: "created_at") as! String
            //cell.imgGameType.image = UIImage(named: "sball3")
            cell.lblVenue.text = dict.value(forKey: "description") as! String
            
            //cell.lblVenue.sizeToFit()
            
            
            let intLikeCount : Int = dict.value(forKey: "postLikeCount") as! Int
            
            
            let intCommentCount : Int = dict.value(forKey: "postCommentCount") as! Int
            
            //For Like
            if intLikeCount > 0 {
                cell.btnLike.setTitle("\(intLikeCount) Likes", for: .normal)
            }
            else {
                cell.btnLike.setTitle("Like", for: .normal)
            }
            
            
            cell.btnLike.addTarget(self, action: #selector(self.btnLikeClicked(sender:)), for: .touchUpInside)
            
            //For Comment
            if intCommentCount > 0 {
                cell.btnComment.setTitle("\(intCommentCount) Comments", for: .normal)
            }
            else
            {
                 cell.btnComment.setTitle("Comment", for: .normal)
            }
            
            cell.btnComment.addTarget(self, action: #selector(self.btnCommentClicked(sender:)), for: .touchUpInside)
            
            /*
            let intCategory : Int = dict.value(forKey: "postCategory") as! Int
            if intCategory == 1 {
                //Hockey
                //sball2 - Hockey
                cell.imgGameType.image = UIImage(named: "sball2")
            }
            else if intCategory == 2 {
                //Soccer
                //sBall1
                cell.imgGameType.image = UIImage(named: "sball1")
            }
            else if intCategory == 3 {
                //Football
                //sball4 - Football
                cell.imgGameType.image = UIImage(named: "sball4")
            }
            else if intCategory == 4 {
                //Basketball
                //sball2 - Basketball
                cell.imgGameType.image = UIImage(named: "sball2")
            }
            else if intCategory == 5 {
                //baseball
                //sball3- Baseball
                cell.imgGameType.image = UIImage(named: "sball3")
            }
            */
            cell.imgGameType.image = UIImage(named: "sball0")
            
            if let intIsLiked = dict.value(forKey: "is_liked") {
                if "\(intIsLiked)" == "0" {
                    cell.btnLike.backgroundColor = UIColor.white
                    cell.btnLike.setTitleColor(#colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1), for: .normal)
                }
                else
                {
                    cell.btnLike.backgroundColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1)
                    cell.btnLike.setTitleColor(UIColor.white, for: .normal)
                }
            }
            let strImg = dict.value(forKey: "image") as! String
            if strImg == "" {
                cell.heightLayout.constant = 0
                //return CGSize(width: (screenWidth*304)/320, height: 125)
            }
            else
            {
                cell.heightLayout.constant = 128
                cell.imgPost.tag = indexPath.row
                let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.imgTapped(sender:)))
                cell.imgPost.addGestureRecognizer(gesture)
                
                let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
                let url2 = URL(string: strURL)
                if url2 != nil {
                    cell.imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
                }
                
                //cell.imgPost.downloadImage(from: strImg)
                //return CGSize(width: (screenWidth*304)/320, height: 250)
            }
            
            /*
            HOCKEY = 1;
            SOCCER = 2;
            FOOTBALL = 3;
            BASKETBALL = 4;
            BASEBALL = 5;
            */
            
            
            let intHt : CGFloat = 30
            let intTotalItems : Int = 5
            let intDifference : CGFloat = intHt - 5.0
            
            
            //cell.vwPerson.subviews.removeAll()
            /*
            for i in (0...intTotalItems).reversed() {
                //print(i) // prints 10 through 1
                let img1 = UIImageView(frame: CGRect(x: (CGFloat(i)*intDifference), y: 0, width: intHt, height: intHt))

                img1.layer.shadowColor = UIColor.gray.cgColor
                img1.layer.shadowOffset = CGSize(width: 0, height: 1)
                img1.layer.shadowOpacity = 1
                img1.layer.shadowRadius = 1.0
                
                
                img1.layer.cornerRadius = intHt/2
                img1.layer.borderWidth = 1
                img1.layer.borderColor = #colorLiteral(red: 0.7079399824, green: 0.7501713037, blue: 0.703009069, alpha: 1).cgColor
                
                cell.vwPerson.addSubview(img1)
            }
            */
            mainCell = cell
        }
        
        
        return mainCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        /*
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gameDetailVC: GameDetailVC = cameraStoryboard.instantiateViewController(withIdentifier: "GameDetailVC") as! GameDetailVC
        
        if(indexPath.row == 0) {
            gameDetailVC.isCurrentMatch = true
        }
        else {
            gameDetailVC.isCurrentMatch = false
        }
        
        self.navigationController?.pushViewController(gameDetailVC, animated: true)
        */
        if intSelectedTab == 1 {
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tagDetailVC: TagGameVC = cameraStoryboard.instantiateViewController(withIdentifier: "TagGameVC") as! TagGameVC
            tagDetailVC.arrList = arrList
            
            
            self.navigationController?.pushViewController(tagDetailVC, animated: true)
            
        }
        else
        {
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tagDetailVC: CommentViewController = cameraStoryboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
            tagDetailVC.dictPost = arrTimelineData.object(at: indexPath.row) as! NSDictionary
            self.navigationController?.pushViewController(tagDetailVC, animated: true)
        }
        
    }
    
    func imgTapped(sender : UITapGestureRecognizer) {
        let imgVw : UIImageView = sender.view as! UIImageView
        let dic : NSDictionary = arrTimelineData.object(at: imgVw.tag) as! NSDictionary
        let strImgLink : String = dic.value(forKey: "image") as! String
        
        //This is video
        if strImgLink == "" {
            let strVideoLink : String = dic.value(forKey: "video") as! String
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let videoVC = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            
            videoVC.strLink = strVideoLink
            self.navigationController?.pushViewController(videoVC, animated: true)
        }
        else
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let imageVC = storyboard.instantiateViewController(withIdentifier: "ZoomImageViewController") as! ZoomImageViewController
            imageVC.strLink = strImgLink
            self.view.addSubview(imageVC.view)
            self.addChildViewController(imageVC)
        }
        
        
        
    }
    
    func btnLikeClicked(sender:UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.cvMatchList)
        //let indexPath = self.cvMatchList.indexPathForItem(at: buttonPosition)
        let indexPath = self.tblMatch.indexPathForRow(at: buttonPosition)
        //print("likeclicke \(indexPath?.row)")
        
        
        let intRow = sender.tag
        
        let id : Int = (arrTimelineData.object(at: intRow) as! NSDictionary).value(forKey: "id") as! Int
        
        
        let intLiked : Int =  (arrTimelineData.object(at: intRow) as! NSDictionary).value(forKey: "is_liked") as! Int
        var strUrl = String()
        
        //post has been liked so need to call unlike
        if intLiked == 1 {
            strUrl = "posts/unlike"
        }
        else
        {
            strUrl = "posts/like"
        }
        
        //let strUrl : String = "posts/like"
        var params : [String:AnyObject]
        params = ["post_id": "\(id)" as AnyObject]
        MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
            print("Response \(response as NSDictionary)")
            let strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
            self.changeTab()
            //showAlert(strMsg: strMes, vc: self)
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
        
        
    }
    
    func btnCommentClicked(sender:UIButton) {
        //let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.cvMatchList)
        let intRow = sender.tag//self.tblMatch.indexPathForRow(at: buttonPosition)
        //let indexPath = self.cvMatchList.indexPathForItem(at: buttonPosition)
        
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: CommentViewController = cameraStoryboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        tagDetailVC.dictPost = arrTimelineData.object(at: intRow) as! NSDictionary
        tagDetailVC.modalPresentationStyle = .overCurrentContext
        tagDetailVC.strFromScreen = "1"
        tagDetailVC.objHomeVc = self
        self.present(tagDetailVC, animated: true, completion: nil)
        //self.view.addSubview(tagDetailVC.view)
        //self.addChildViewController(tagDetailVC)
        
        //self.navigationController?.pushViewController(tagDetailVC, animated: true)
        
    }
    
    //MARK:- Creating function that will add custom button to the tab
    func addBtnToTab() {
        let flHt : CGFloat = 50
        let flWidth : CGFloat = 70
        let button = UIButton(frame: CGRect(x: (screenWidth - flWidth), y: ( screenHeight - flHt) , width: flWidth, height: flHt))
        button.backgroundColor = UIColor.clear
        button.setImage(#imageLiteral(resourceName: "Record"), for: .normal)
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        appDelegate.tabbar.addingCustomButton(button)
    }
    
    func buttonAction(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tutorialVC = storyboard.instantiateViewController(withIdentifier: "TransparentViewController") as! TransparentViewController
        appDelegate.tabbar.view.addSubview(tutorialVC.view)
        appDelegate.tabbar.addChildViewController(tutorialVC)
    }
}

class timelineCell: UITableViewCell {
    @IBOutlet weak var imgGameType: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblVenue: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var vwPerson: UIView!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    @IBOutlet weak var txtVenue: UITextView?

    @IBOutlet weak var wvheightLayout: NSLayoutConstraint?
    @IBOutlet weak var webvwVideo: UIWebView?

    
    
    override func awakeFromNib() {
        btnLike.layer.cornerRadius = 5
        btnLike.layer.borderWidth = 1
        btnLike.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
        btnComment.layer.cornerRadius = 5
        btnComment.layer.borderWidth = 1
        btnComment.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
    }
}

class matchCell: UITableViewCell {
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var ivChallenge: UIImageView!
    @IBOutlet weak var lblScore2: UILabel!
    @IBOutlet weak var lblScore1: UILabel!
    @IBOutlet weak var lblStatusIcon: UILabel!
    
    @IBOutlet weak var lblFirstNameTeam1: UILabel!
    @IBOutlet weak var lblLastNameTeam1: UILabel!
    @IBOutlet weak var lblFirstNameTeam2: UILabel!
    @IBOutlet weak var lblLastNameTeam2: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 5
        //setCornurRedius(idObject: lblStatusIcon, radius: lblStatusIcon.frame.size.height/2)
    }
}

extension Date {
    @nonobjc static var localFormatter: DateFormatter = {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateStyle = .long
        dateStringFormatter.timeStyle = .long
        return dateStringFormatter
    }()
    
    func localDateString() -> String
    {
        return Date.localFormatter.string(from: self)
    }
}
