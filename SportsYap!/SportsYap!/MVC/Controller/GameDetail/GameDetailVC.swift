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
    
}


class GameDetailVC: UIViewController {

    @IBOutlet private var viewRounded: UIView!
    @IBOutlet private var viewDot: UILabel!
    @IBOutlet private var btnFanmeter: UIButton!
    @IBOutlet fileprivate var btnNews: UIButton!
    @IBOutlet fileprivate var btnFans: UIButton!
    @IBOutlet private var tblList: UITableView!
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if(isCurrentMatch == true) {
            cntHeight.constant = 100
        }
        
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBAction Methods
    
    @IBAction private func btnFansPress(_ : UIButton) {
        
        isFans = true
        
        btnFans.setTitleColor(UIColor.black, for: .normal)
        btnNews.setTitleColor(UIColor.darkGray, for: .normal)
        
        tblList.reloadData()
    }
    
    @IBAction private func btnBackPress(_ : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func btnEnterFieldClicked(_ : UIButton) {
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let objEnter: EnterFieldViewController = cameraStoryboard.instantiateViewController(withIdentifier: "EnterFieldViewController") as! EnterFieldViewController
        objEnter.strTitle = "\(currentGameObject.strTeam1FirstName) Vs \(currentGameObject.strTeam2FirstName)"
        self.navigationController?.pushViewController(objEnter, animated: true)
    }
    
    @IBAction private func btnNewsPress(_ : UIButton) {
        
        isFans = false
        
        btnNews.setTitleColor(UIColor.black, for: .normal)
        btnFans.setTitleColor(UIColor.darkGray, for: .normal)
        
        tblList.reloadData()
    }
    
    @IBAction func btnMorePassPress(_ : UIButton) {
        self.view.endEditing(true)
        
        let moreVC = storyboard?.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
        view.addSubview(moreVC.view)
        addChildViewController(moreVC)
    }
}

extension GameDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if(isFans == true) {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
                return "     FRIENDS AT THE GAME"
            }
        }
        else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(isFans == true) {
            
            let cell: FansCell = tableView.dequeueReusableCell(withIdentifier: "FansCell") as! FansCell
            
            if(indexPath.section == 0) {
                cell.ivVarify.isHidden = false
            }
            else {
                cell.ivVarify.isHidden = true
            }
            
            return cell
        }
        else {
            let cell: NewsCell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
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



