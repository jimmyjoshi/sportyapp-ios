//
//  AddTeamVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 26/05/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit


class AddTeamsCell: UITableViewCell {
    
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    
    override func awakeFromNib() {
        setCornurRedius(idObject: ivImage, radius: ivImage.frame.size.height/2)
        ivImage.layer.borderWidth = 1.5
        ivImage.layer.borderColor = UIColor.lightGray.cgColor
        
        setCornurRedius(idObject: btnFollow, radius: 3)
        btnFollow.layer.borderWidth = 0.7
        btnFollow.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
    }
    
}

class AddTeamVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblUserLost: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var isSearching = false
    var discover = DiscoverClass()
    var arrList = Array<DiscoverClass>()
    var arrSearchList = Array<DiscoverClass>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WSCall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - WS Calls
    
    private func WSCall() {
        
        discover.getUserListFor(showLoader: false, strSerarchWord: "", success: { (response) in
            
            self.arrList = response
            self.arrSearchList = response
            self.tblUserLost.reloadData()
            self.activity.isHidden = true
            
        }, failed: { (responser) in
            
            self.activity.isHidden = true
            showAlert(strMsg: responser as String, vc: self)
            
        })
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnCancelPress(_ : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddTeamVC: UISearchBarDelegate {
    
    //MARK:- UISearchBar Delegate
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        isSearching = false
        self.view.endEditing(true)
        self.tblUserLost.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = true;
        self.tblUserLost.reloadData()
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        arrSearchList = arrList.filter{ ($0.strName.lowercased().contains((searchBar.text?.lowercased())!))}
        
        if(arrSearchList.count == 0){
            isSearching = false
        } else {
            isSearching = true
        }
        self.tblUserLost.reloadData()
    }
    
}

extension AddTeamVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isSearching) {
            return arrSearchList.count
        } else {
            return arrList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AddTeamsCell = tableView.dequeueReusableCell(withIdentifier: "AddTeamsCell") as! AddTeamsCell
        
        var userDetail = arrList[indexPath.row]
        
        if(isSearching) {
            userDetail = arrSearchList[indexPath.row]
        }
        
        
        cell.lblName.text = userDetail.strName
        cell.lblLocation.text = userDetail.strLocation
        cell.ivImage.sd_setImage(with: userDetail.urlProfile, placeholderImage: #imageLiteral(resourceName: "team_circle"))
        
        return cell
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

