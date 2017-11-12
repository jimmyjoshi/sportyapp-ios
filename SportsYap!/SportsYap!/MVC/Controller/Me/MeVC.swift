//
//  MeVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 24/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class MeTeamCell: UICollectionViewCell {
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblTeamName : UILabel!
    override func awakeFromNib() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.ivImage.layer.cornerRadius = self.ivImage.frame.size.height/2
            self.ivImage.layer.masksToBounds = true
            self.ivImage.layer.borderColor = UIColor.black.cgColor
            
            self.contentView.layer.cornerRadius = 12.5
            self.contentView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
            self.contentView.layer.borderWidth = 2
        }
    }
    
}


class MeMatchCell: UICollectionViewCell {
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblScore1: UILabel!
    @IBOutlet weak var lblScore2: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFirstNameTeam1: UILabel!
    @IBOutlet weak var lblLastNameTeam1: UILabel!
    @IBOutlet weak var lblFirstNameTeam2: UILabel!
    @IBOutlet weak var lblLastNameTeam2: UILabel!
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 5
    }
    
}


class MeVC: UIViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblShotsCount: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    @IBOutlet weak var cvTeams: UICollectionView!
    //@IBOutlet weak var cvMatches: UICollectionView!
    
    
    @IBOutlet weak var tblMatch: UITableView!
    @IBOutlet weak var vwNoMatch: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var btnFollowHeight: NSLayoutConstraint!
    @IBOutlet weak var ivFollow: UIImageView!
    @IBOutlet weak var btnLogout: UIButton!

    var userDetail: DiscoverClass!
    var isOtherProfile: Bool!
    
    private var gameObj = GameClass()
    var strDate = ""
    var date = Date()
    //var arrTeamData = NSMutableArray()
    
    var arrList = Array<GameClass>()
    
    //Declaring constant
    
    var KMatchVenueKey = String("MatchVenue")
    var KTeam1FirstNameKey = String("Team1FirstName")
    var KTeam1LastNameKey = String("Team1LastName")
    var KTeam1ScoreKey = String("Team1Score")
    var KTeam2FirstNameKey = String("Team2FirstName")
    var KTeam2LastNameKey = String("Team2LastName")
    var KTeam2ScoreKey = String("Team2Score")
    
    var KMatchTimeKey = String("MatchTime")
    var KMatchShotKey = String("Shots")
    var KMatchFanKey = String("Fans")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btnProfile.layer.cornerRadius = self.btnProfile.frame.size.height/2
            self.btnProfile.layer.masksToBounds = true
            self.btnProfile.layer.borderColor = UIColor.lightGray.cgColor
            self.btnProfile.layer.borderWidth = 2
        }
        
        if(isOtherProfile == true) {
            
            lblUserName.text = userDetail.strUserName
            //lblUserName.text = userDetail.strName
            btnProfile.sd_setImage(with: userDetail.urlProfile, for: .normal)
            lblName.text = userDetail.strName
            lblLocation.text = userDetail.strLocation
            btnSettings.isHidden = true
            btnBack.isHidden = false
            btnLogout.isHidden = true
            
            if(userDetail.isFollow == true) {
                ivFollow.isHidden = false
                btnFollow.isSelected = false
            }
            else {
                btnFollow.isSelected = true
            }
            self.getOtherUserProfile()
        }
        else {
            btnFollowHeight.constant = 0
            lblUserName.text = UserClass.sharedInstance.strUserName
            //lblUserName.text = UserClass.sharedInstance.strName
            btnProfile.sd_setImage(with: UserClass.sharedInstance.urlProfile, for: .normal)
            lblName.text = UserClass.sharedInstance.strName
            lblLocation.text = UserClass.sharedInstance.strLocation
            self.getProfile()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Method for Logg off
    @IBAction func btnLogOff(sender: UIButton){
        
        let alertView = UIAlertController(title: AppName, message: "Do you want to log off?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default)
        { (action) in
            if let win = appDelegate.window {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let logVC : LoginOptionVC = mainStoryBoard.instantiateViewController(withIdentifier: "LoginOptionVC") as! LoginOptionVC
                AppUserDefaults.removeAllValues()
                win.rootViewController = logVC
            }
        }
        alertView.addAction(OKAction)
        let CancelAction = UIAlertAction(title: "No", style: .default)
        {
            (action) in
        }
        alertView.addAction(CancelAction)
        self.present(alertView, animated: true, completion: nil)
    
        
        
        
    }
    
    //MARK:- API Call for getting profile details
    func getProfile() {
        var strUrl = String("")!
        strUrl = "\(base_Url)users/get-profile"
        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: strUrl, parameter: nil, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            
            var dictData : NSDictionary = (response as! NSDictionary).value(forKey: "data") as! NSDictionary
            self.lblFollowersCount.text = "\(dictData.value(forKey: "followers_count")!)"
            self.lblFollowingCount.text = "\(dictData.value(forKey: "following_count")!)"
            self.lblShotsCount.text = "\(dictData.value(forKey: "total_shots")!)"
            
            self.callGetMatchApi()
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
            self.callGetMatchApi()
        }
        
        
    }
    
    func getOtherUserProfile() {
        let dictParameter : [String:AnyObject]  = ["user_id": userDetail.strUserId as AnyObject]
       
        var strUrl = String("")!
        strUrl = "\(base_Url)users/get-user-profile"
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            let dictData : NSDictionary = (response as! NSDictionary).value(forKey: "data") as! NSDictionary
            

            if let cntFollower = dictData.value(forKey: "followers_count")
            {
                self.lblFollowersCount.text = "\(cntFollower)"
            }
            else
            {
                self.lblFollowersCount.text = "0"
            }
            
            if let cntFollower = dictData.value(forKey: "following_count") {
                self.lblFollowingCount.text = "\(cntFollower)"
            }
            else
            {
                self.lblFollowingCount.text = "0"
            }
            
            if let shots = dictData.value(forKey: "total_shots") {
                self.lblShotsCount.text = "\(shots)"
            }
            else
            {
                self.lblShotsCount.text = "0"
            }
            /*
            self.lblFollowersCount.text = "\(dictData.value(forKey: "followers_count")!)"
            self.lblFollowingCount.text = "\(dictData.value(forKey: "following_count")!)"
            self.lblShotsCount.text = "\(dictData.value(forKey: "total_shots")!)"
            */
            self.callGetMatchApi()
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
            self.callGetMatchApi()
        }
    }
    //MARK:- Match related api call and response
    func callGetMatchApi() {
        
        self.tblMatch.estimatedRowHeight = 82.0
        self.tblMatch.rowHeight = UITableViewAutomaticDimension
        
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
        //self..reloadData()
        getFootballGameData()
        
    }
    private func getFootballGameData() {
        self.vwNoMatch.isHidden = true
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
                self.vwNoMatch.isHidden = false
            }
            else
            {
                self.vwNoMatch.isHidden = true
            }
            
            self.tblMatch.reloadData()
        }, failed: { (responser) in
            if self.arrList.count == 0 {
                self.vwNoMatch.isHidden = false
            }
            else
            {
                self.vwNoMatch.isHidden = true
            }
            self.tblMatch.reloadData()
        })
    }
    
    private func getSoccerGameData() {
        let strURL = "http://www.goalserve.com/getfeed/596fc07949d14d3c8c5684dcb8712ce8/commentaries/soccernew?date=15.01.2017&json=1"
        gameObj.getGameListFor(showLoader: true, strFullURL:strURL, strMatchType: "commentaries", strDate: "15.01.2017", success: { (response) in
            for i in 0..<response.count {
                self.arrList.append(response[i])
            }
           self.tblMatch.reloadData()
            //self.activity.isHidden = true
        }, failed: { (responser) in
            self.tblMatch.reloadData()
            //self.activity.isHidden = true
        })
        
    }
    @IBAction private func btnBackPressed(_ : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func btnFollowingPressed(_ : UIButton) {
        
        if(userDetail.isFollow == true) {
            //Unfollow User call
            
            userDetail.unfollowUser(showLoader: true, success: { (response) in
                
                self.ivFollow.isHidden = true
                self.btnFollow.isSelected = true
                self.userDetail.isFollow = false
                
            }, failed: { (response) in
                showAlert(strMsg: response as String, vc: self)
            })
            
        }
        else {
            //Follow User call
            
            userDetail.followUser(showLoader: true, success: { (response) in
                
                self.userDetail.isFollow = true
                self.ivFollow.isHidden = false
                self.btnFollow.isSelected = false
                
            }, failed: { (response) in
                showAlert(strMsg: response as String, vc: self)
            })
        }
        
    }
    
    //MARK: Get Follower List
    @IBAction func btnBuddiesClicked(sender: UIButton)
    {
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: BuddiesViewController = cameraStoryboard.instantiateViewController(withIdentifier: "BuddiesViewController") as! BuddiesViewController
        self.navigationController?.pushViewController(tagDetailVC, animated: true)
    }
    
    @IBAction func btnFollowingsVCClicked(sender: UIButton)
    {
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: FollowingsVC = cameraStoryboard.instantiateViewController(withIdentifier: "FollowingsVC") as! FollowingsVC
        self.navigationController?.pushViewController(tagDetailVC, animated: true)
    }
    
    @IBAction func btnShotsVCClicked(sender: UIButton)
    {
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: ShotsVC = cameraStoryboard.instantiateViewController(withIdentifier: "ShotsVC") as! ShotsVC
        self.navigationController?.pushViewController(tagDetailVC, animated: true)
    }

}
extension MeVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*
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
        else{
            cell.ivImage.image = UIImage(named: "Game_image0")
        }
        
        return cell
    }
    
}

extension MeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //if(collectionView.tag == 100) {
            return 0
        //}
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        //if(collectionView.tag == 100) {
            return CGSize(width: 82, height: 25)
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MeTeamCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeTeamCell", for: indexPath) as! MeTeamCell
        var index = indexPath.row
        if(index >= 14) {
            index = indexPath.row % 14
        }
        switch indexPath.row {
        case 0:
            cell.lblTeamName.text = "Dodgers"
            cell.ivImage.image = UIImage(named: "team9")
            break
        case 1:
            cell.lblTeamName.text = "Clippers"
            cell.ivImage.image = UIImage(named: "team10")
            break
        case 2:
            cell.lblTeamName.text = "Lakers"
            cell.ivImage.image = UIImage(named: "team6")
            break
        case 3:
            cell.lblTeamName.text = "Rams"
            cell.ivImage.image = UIImage(named: "team2")
            break
        default:
            cell.lblTeamName.text = "Dodgers"
            cell.ivImage.image = UIImage(named: "team2")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

