//
//  TeamVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 16/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import SDWebImage

class PlayerCell: UITableViewCell {
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    override func awakeFromNib() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.ivImage.layer.cornerRadius = self.ivImage.frame.size.height/2
            self.ivImage.layer.masksToBounds = true
            self.ivImage.layer.borderColor = UIColor.lightGray.cgColor
            self.ivImage.layer.borderWidth = 0
        }
    }
    
}

class SportsTypeCell: UICollectionViewCell {
    @IBOutlet weak var btnGame: UIButton!
    
    override func awakeFromNib() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btnGame.layer.cornerRadius = self.btnGame.frame.size.height/2
            self.btnGame.layer.masksToBounds = true
            self.btnGame.layer.borderColor = UIColor.black.cgColor
        }
    }
    
}

class TeamVC: UIViewController {
    
    var teamClass = TeamClass()
    var selectedIndex: Int!
    var arrList = Array<Array<TeamClass>>()
    @IBOutlet weak var tblList: UITableView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        selectedIndex = 0
        
        teamClass.getTeamList(showLoader: true, success: { (response) in
            
            self.arrList = response
            self.tblList.delegate = self
            self.tblList.dataSource = self
            self.tblList.reloadData()
            
        }, failed: { (responser) in
            
            showAlert(strMsg: responser as String, vc: self)
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnCancelPress(_ : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFinishPress(_ : UIButton) {
        AppUserDefaults.setValue(value: "YES", key: "SHOWTUTORIAL")
        setTabbar()
    }
    
    //MARK:- UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension TeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList[selectedIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: PlayerCell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as! PlayerCell
        
        let team = arrList[selectedIndex][indexPath.row]
        
        cell.btnSelection.isSelected = team.isSelected
        cell.lblCity.text = team.strCity
        cell.lblName.text = team.strName
        
        //cell.ivImage.sd_setImage(with: team.urlProfile, placeholderImage: UIImage(named:"placeholdeTeam"))
        
        var index = indexPath.row
        
        if(index >= 14) {
            index = indexPath.row % 14
        }
        
        cell.ivImage.image = UIImage(named: "team\(index)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let team = arrList[selectedIndex][indexPath.row]
        
        team.isSelected = !team.isSelected
        let cell: PlayerCell = tableView.cellForRow(at: indexPath) as! PlayerCell
        cell.btnSelection.isSelected = team.isSelected
        
    }
}

extension TeamVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SportsTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportsTypeCell", for: indexPath) as! SportsTypeCell
        
        
        if(indexPath.row == selectedIndex) {
            cell.btnGame.setImage(UIImage(named: "sball\(indexPath.row)"), for: .normal)
        }
        else {
            cell.btnGame.setImage(UIImage(named: "usball\(indexPath.row)"), for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var cell: SportsTypeCell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as! SportsTypeCell
        cell.btnGame.setImage(UIImage(named: "usball\(selectedIndex!)"), for: .normal)
        
        
        selectedIndex = indexPath.row
        cell = collectionView.cellForItem(at: indexPath) as! SportsTypeCell
        cell.btnGame.setImage(UIImage(named: "sball\(indexPath.row)"), for: .normal)
        
        tblList.reloadData()
        
    }
    
}
