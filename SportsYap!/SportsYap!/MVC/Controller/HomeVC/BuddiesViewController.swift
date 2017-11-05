//
//  BuddiesViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 02/11/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class BuddiesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblUserLost: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var isSearching = false
    var discover = DiscoverClass()
    
    //var arrList = Array<DiscoverClass>()
    //var arrSearchList = Array<DiscoverClass>()
    
    
    var arrList = NSMutableArray()
    var arrSearchList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.WSCall()
        //self.callGetAllTeam()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.callGetFollowers()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func callGetFollowers() {
        var strUrl = String("")!
        strUrl = "\(base_Url)users/user-followers"
        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: strUrl, parameter: nil, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            var arrTmp = NSMutableArray()
            arrTmp  = ((response as NSDictionary).value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
            self.convertToMutable(arrMain: arrTmp)
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    func convertToMutable(arrMain: NSMutableArray) {
        var arrTemp = NSMutableArray()
        for arr in arrMain {
            let dict : NSMutableDictionary = (arr as! NSDictionary).mutableCopy() as! NSMutableDictionary
            arrTemp.add(dict)
        }
        arrList = NSMutableArray()
        arrList = arrTemp
        self.tblUserLost.reloadData()
    }
    
    //MARK: - IBAction Methods
    @IBAction func btnCancelPress(_ : UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Follow Clicked Method
    func btnFollowUnFollowClicked(sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblUserLost)
        let ip = self.tblUserLost.indexPathForRow(at: buttonPosition)
        print("Index path \(ip?.row)")
        
        var dict = NSDictionary()
        dict = arrList[(ip?.row)!] as! NSDictionary
        let usr = DiscoverClass()
        usr.strUserId = "\(dict.value(forKey: "id")!)"
        usr.strEmail = dict.value(forKey: "email") as! String
        usr.urlProfile =  URL(fileURLWithPath: "\(dict.value(forKey: "image")!)")//dict.value(forKey: "image") as! URL!
        usr.strLocation = dict.value(forKey: "location") as! String
        usr.strName = dict.value(forKey: "name") as! String
        usr.strUserName = dict.value(forKey: "username") as! String
        usr.isFollow = dict.value(forKey: "is_follow") as! Bool!
        
        //Unfollow User call
        usr.unfollowUser(showLoader: true, success: { (response) in
            self.callGetFollowers()
        }, failed: { (response) in
            showAlert(strMsg: response as String, vc: self)
            self.callGetFollowers()
        })
        
        }
}

extension BuddiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(isSearching) {
            return arrSearchList.count
        } else {
            return arrList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AddTeamsCell = tableView.dequeueReusableCell(withIdentifier: "AddTeamsCell") as! AddTeamsCell
        
        //var userDetail = arrList[indexPath.row]
        
        
        var dictInfo = NSDictionary()
        dictInfo = arrList[indexPath.row] as! NSDictionary
        
        if(isSearching) {
            dictInfo = arrSearchList[indexPath.row] as! NSDictionary
        }
        
        
        if let img = dictInfo.value(forKey: "image") {
            let strImg = dictInfo.value(forKey: "image") as! String
            if strImg == "" {
                
            }
            else
            {
                let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
                let url2 = URL(string: strURL)
                if url2 != nil {
                    cell.ivImage.sd_setImage(with: url2, placeholderImage: nil)
                }
            }
        }
        
        if let name = dictInfo.value(forKey: "name") {
            cell.lblName.text = "\(name)"
        }
        
        if let location = dictInfo.value(forKey: "location") {
            cell.lblLocation.text = "\(location)"
        }
        
        
        if let isFollow = dictInfo.value(forKey: "is_follow") {
            if "\(isFollow)" == "1" {
                cell.btnFollow.setTitle("Unfollow", for: .normal)
            }
            else
            {
                cell.btnFollow.setTitle("Follow", for: .normal)
            }
            cell.btnFollow.addTarget(self, action: #selector(self.btnFollowUnFollowClicked(sender:)), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict : NSDictionary = arrList[indexPath.row] as! NSDictionary
        let usr = DiscoverClass()
        usr.strUserId = "\(dict.value(forKey: "id")!)"
        usr.strEmail = dict.value(forKey: "email") as! String
        usr.urlProfile =  URL(fileURLWithPath: "\(dict.value(forKey: "image")!)")//dict.value(forKey: "image") as! URL!
        usr.strLocation = dict.value(forKey: "location") as! String
        usr.strName = dict.value(forKey: "name") as! String
        usr.strUserName = dict.value(forKey: "username") as! String
        usr.isFollow = dict.value(forKey: "is_follow") as! Bool!
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let meVC = homeStoryboard.instantiateViewController(withIdentifier: "MeVC") as! MeVC
        meVC.isOtherProfile = true
        meVC.userDetail = usr
        self.navigationController?.pushViewController(meVC, animated: true)
        
    }
}
