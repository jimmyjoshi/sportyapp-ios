//
//  TagGameVC.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 12/07/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class TagGameVC: UIViewController {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var tblTagGame: UITableView!
    //First value indicates section i.e 0,1 and second tableview row
    var intSelectedValue : (Int,Int) = (-1,-1)
    var arrList = Array<GameClass>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnAdd.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeButtonTitle() {
        //Changing button title will be called on clicking button
        
        var gameDetail : GameClass = arrList[intSelectedValue.0]
        var strTeamName = String("")
        if intSelectedValue.1 == 0 {
            strTeamName = gameDetail.strTeam1LastName
        }
        else if intSelectedValue.1 == 1 {
            strTeamName = gameDetail.strTeam2LastName
        }
        strTeamName = "Add shot to \(strTeamName!) Game Day \u{2794}"
        btnAdd.setTitle(strTeamName, for: .normal)
    }

    @IBAction func btnActionAddTagClicked(sender : UIButton) {
        var gameDetail : GameClass = arrList[intSelectedValue.0]
        var strTeamName = String("")
        if intSelectedValue.1 == 0 {
            strTeamName = gameDetail.strAwayMatchId
        }
        else if intSelectedValue.1 == 1 {
            strTeamName = gameDetail.strHomeMatchId
        }
        callAddTeamRatio(strFollowTeam: strTeamName!)
    }
    
    func callAddTeamRatio(strFollowTeam: String) {
        let dictParameter : [String:AnyObject]  = ["gameId": self.arrList[0].strMatchId as AnyObject,"homeTeamId": self.arrList[0].strHomeMatchId as AnyObject,"awayTeamId": self.arrList[0].strAwayMatchId as AnyObject,"followTeam": strFollowTeam as AnyObject]
        var strUrl = String("")!
        strUrl = "\(base_Url)sporty-fans/add-team-ratio"
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            let dictFanMeter : NSDictionary  = ((response as NSDictionary).value(forKey: "data") as! NSDictionary)
            let intHomeCount : Int = dictFanMeter.value(forKey: "homeCount") as! Int
            let intAwayCount : Int = dictFanMeter.value(forKey: "awayCount") as! Int
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let postVC: ChallengePostListViewController = cameraStoryboard.instantiateViewController(withIdentifier: "ChallengePostListViewController") as! ChallengePostListViewController
            postVC.currentGameObject = self.arrList[0]
            self.navigationController?.pushViewController(postVC, animated: true)
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    @IBAction func btnActionBackClicked(sender : UIButton) {
         _ = self.navigationController?.popViewController(animated: true)
    }

}



extension TagGameVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TagGameCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TagGameCell") as! TagGameCellTableViewCell
        cell.tagGame = self
        var gameDetail : GameClass = arrList[indexPath.row] as! GameClass
        
        cell.lblFirstName1.text = gameDetail.strTeam1FirstName
        cell.lblLastName1.text = gameDetail.strTeam1LastName
        cell.lblScore1.text = gameDetail.strTeam1Score
        
        cell.lblFirstName2.text = gameDetail.strTeam2FirstName
        cell.lblLastName2.text = gameDetail.strTeam2LastName
        cell.lblScore2.text = gameDetail.strTeam2Score
        
        cell.lblTime.text = gameDetail.strTime
        
        if gameDetail.strMatchTpe == "football" {
            cell.imgBackground.image = UIImage(named: "Game_image1")
        }
        else if gameDetail.strMatchTpe == "baseball" {
            cell.imgBackground.image = UIImage(named: "Game_image2")
        }
        else if gameDetail.strMatchTpe == "bsktbl" {
            cell.imgBackground.image = UIImage(named: "Game_image3")
        }
        else if gameDetail.strMatchTpe == "hockey" {
            cell.imgBackground.image = UIImage(named: "Game_image0")
        }
        else
        {
            cell.imgBackground.image = UIImage(named: "Game_image0")
        }
        
        if indexPath.row == intSelectedValue.0 {
            if intSelectedValue.1 == 0 {
                cell.btnBg1.layer.borderWidth = 3.0
                cell.btnBg1.layer.borderColor = themeBlueColor.cgColor
                
                
                cell.btnBg2.layer.borderColor = UIColor.clear.cgColor
                
            }
            else if intSelectedValue.1 == 1{
                cell.btnBg2.layer.borderWidth = 3.0
                cell.btnBg2.layer.borderColor = themeBlueColor.cgColor
                
                
                cell.btnBg1.layer.borderColor = UIColor.clear.cgColor
            }
        }
        else
        {
            cell.btnBg1.layer.borderColor = UIColor.clear.cgColor
            cell.btnBg2.layer.borderColor = UIColor.clear.cgColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

