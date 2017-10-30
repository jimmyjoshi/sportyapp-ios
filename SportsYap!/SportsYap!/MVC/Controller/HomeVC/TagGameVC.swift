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
       
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: ChallengePostListViewController = cameraStoryboard.instantiateViewController(withIdentifier: "ChallengePostListViewController") as! ChallengePostListViewController
        postVC.currentGameObject = arrList[intSelectedValue.0]
        //postVC.strMatchId = self.currentGame.strMatchId
        self.navigationController?.pushViewController(postVC, animated: true)
        
        /*
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gameDetailVC: GameDetailVC = cameraStoryboard.instantiateViewController(withIdentifier: "GameDetailVC") as! GameDetailVC
        gameDetailVC.isCurrentMatch = true
        var gameObject : GameClass = arrList[intSelectedValue.0] as! GameClass
        gameDetailVC.currentGameObject = gameObject
        self.navigationController?.pushViewController(gameDetailVC, animated: true)*/
        
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

