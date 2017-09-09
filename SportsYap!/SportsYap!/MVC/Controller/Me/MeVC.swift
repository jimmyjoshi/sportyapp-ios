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
    @IBOutlet weak var cvMatches: UICollectionView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var btnFollowHeight: NSLayoutConstraint!
    @IBOutlet weak var ivFollow: UIImageView!
    
    var userDetail: DiscoverClass!
    var isOtherProfile: Bool!
    
    
    var arrTeamData = NSMutableArray()
    
    
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
            
            //lblUserName.text = userDetail.strUserName
            lblUserName.text = userDetail.strName
            btnProfile.sd_setImage(with: userDetail.urlProfile, for: .normal)
            lblName.text = userDetail.strName
            lblLocation.text = userDetail.strLocation
            btnSettings.isHidden = true
            btnBack.isHidden = false
            
            if(userDetail.isFollow == true) {
                ivFollow.isHidden = false
                btnFollow.isSelected = false
            }
            else {
                btnFollow.isSelected = true
            }
        }
        else {
            
            btnFollowHeight.constant = 0
            
            //lblUserName.text = UserClass.sharedInstance.strUserName
            lblUserName.text = UserClass.sharedInstance.strName
            btnProfile.sd_setImage(with: UserClass.sharedInstance.urlProfile, for: .normal)
            lblName.text = UserClass.sharedInstance.strName
            lblLocation.text = UserClass.sharedInstance.strLocation
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction Methods
    
    
    func setTeamData()
    {
        
        arrTeamData = NSMutableArray()
//        arrTeamData.add([KMatchVenueKey:"L.A Memorial Coliseum",KTeam1FirstNameKey: "Carolina",KTeam1LastNameKey: "PANTHERS",KTeam1ScoreKey:"0",KTeam2FirstNameKey: "Los Angelese",KTeam2LastNameKey: "RAMS",KTeam2ScoreKey:"22",KMatchTimeKey:"",KMatchShotKey:"5",KMatchFanKey:"22"] as! NSDictionary)
//        arrTeamData.add([KMatchVenueKey:"L.A Memorial Coliseum",KTeam1FirstNameKey: "Carolina",KTeam1LastNameKey: "PANTHERS",KTeam1ScoreKey:"0",KTeam2FirstNameKey: "Los Angelese",KTeam2LastNameKey: "RAMS",KTeam2ScoreKey:"22",KMatchTimeKey:"",KMatchShotKey:"5",KMatchFanKey:"22"] as! NSDictionary)
        
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
    
}


extension MeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView.tag == 100) {
            return 4
        }
        else {
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        if(collectionView.tag == 100) {
            return CGSize(width: 82, height: 25)
        }
        else {
            //return CGSize(width: (screenWidth*304)/320, height: (screenHeight*130)/568)
            return CGSize(width: (screenWidth*304)/320, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView.tag == 100) {
            
            let cell: MeTeamCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeTeamCell", for: indexPath) as! MeTeamCell
            
            var index = indexPath.row
            
            if(index >= 14) {
                index = indexPath.row % 14
            }
            
            
            
            //cell.ivImage.image = UIImage(named: "team\(index)")
            
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
        else {
            
            let cell: MeMatchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeMatchCell", for: indexPath) as! MeMatchCell
            
            var index = indexPath.row
            
            if(index >= 5) {
                index = indexPath.row % 5
            }
            
            cell.ivImage.image = UIImage(named: "Game_image\(index)")
            
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

