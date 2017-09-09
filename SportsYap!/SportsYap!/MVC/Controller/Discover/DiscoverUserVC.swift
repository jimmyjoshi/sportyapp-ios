//
//  DiscoverUserVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 25/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class DiscoverPlayerCell: UITableViewCell {
    
    @IBOutlet weak var ivVarify: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    
    override func awakeFromNib() {
        setCornurRedius(idObject: ivImage, radius: ivImage.frame.size.height/2)
        ivImage.layer.borderWidth = 1.5
        ivImage.layer.borderColor = UIColor.lightGray.cgColor
        
        setCornurRedius(idObject: ivVarify, radius: ivVarify.frame.size.height/2)
    }
    
}

class DiscoverUserVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblUserLost: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    var isSearching = false
    var discover = DiscoverClass()
    var arrList = Array<DiscoverClass>()
    var arrSearchList = Array<DiscoverClass>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnBack.isHidden = false
        lblTitle.text = "Top User"
        
        
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

extension DiscoverUserVC: UISearchBarDelegate {
    
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

extension DiscoverUserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isSearching) {
            return arrSearchList.count
        } else {
            return arrList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: DiscoverPlayerCell = tableView.dequeueReusableCell(withIdentifier: "DiscoverPlayerCell") as! DiscoverPlayerCell
        
        var userDetail = arrList[indexPath.row]
        
        if(isSearching) {
            userDetail = arrSearchList[indexPath.row]
        }
        
        
        cell.ivVarify.isHidden = !userDetail.isFollow
        cell.lblName.text = userDetail.strName
        cell.lblLocation.text = userDetail.strLocation
        cell.ivImage.sd_setImage(with: userDetail.urlProfile, placeholderImage: #imageLiteral(resourceName: "team_circle"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var userDetail = arrList[indexPath.row]
        
        if(isSearching) {
            userDetail = arrSearchList[indexPath.row]
        }
        
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let meVC = homeStoryboard.instantiateViewController(withIdentifier: "MeVC") as! MeVC
        meVC.isOtherProfile = true
        meVC.userDetail = userDetail
        self.navigationController?.pushViewController(meVC, animated: true)
        
    }
}

