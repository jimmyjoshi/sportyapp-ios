//
//  BuddiesViewController.swift
//  SportsYap!
//
//  Created by Sagar Jagajeev on 02/11/17.
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
        self.callGetAllTeam()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - WS Calls
    private func WSCall() {
        
    }
    
    
    func callGetAllTeam() {
        var strUrl = String("")!
        strUrl = "\(base_Url)users/get-all-teams"
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
        
        var dictInfo = NSDictionary()
        dictInfo = arrList[(ip?.row)!] as! NSDictionary
        
        if(isSearching) {
            dictInfo = arrSearchList[(ip?.row)!] as! NSDictionary
        }
        
        //let dictInfo = arrTeam[(ip?.row)!] as! NSDictionary
        var strUrl = String("")!
        if let isFollow = dictInfo.value(forKey: "is_follow") {
            if "\(isFollow)" == "1" {
                strUrl = "\(base_Url)users/un-follow-team"
            }
            else
            {
                strUrl = "\(base_Url)users/follow-team"
            }
            var strTeamId : String = "\(dictInfo.value(forKey: "team_id")!)"
            let dictParameter:[String:String] = ["team_id":strTeamId]
            MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strUrl, parameter: dictParameter as [String : AnyObject]?, header: getHeaderData(), success: { (response:Dictionary<String, AnyObject>) in
                print("Response \(response as NSDictionary)")
                let intCode : Int = (response as NSDictionary).value(forKey: "code")! as! Int
                
                let dicData : NSDictionary = (response as NSDictionary).value(forKey: "data")! as! NSDictionary
                
                if intCode == 200 {
                    var dictTeam = NSMutableDictionary()
                    dictTeam = self.arrList[(ip?.row)!] as! NSMutableDictionary
                    
                    if(self.isSearching) {
                        dictTeam = self.arrSearchList[(ip?.row)!] as! NSMutableDictionary
                    }
                    //let dictTeam = self.arrTeam[(ip?.row)!] as! NSMutableDictionary
                    let intIsFollow = dictTeam.value(forKey: "is_follow") as! Int
                    dictTeam.setValue((intIsFollow
                        == 0 ? 1 : 0), forKey: "is_follow")
                    let indexPath = IndexPath(item: (ip?.row)!, section: 0)
                    self.tblUserLost.reloadRows(at: [indexPath], with: .automatic)
                }
                else
                {
                    let strMsg : String = dicData.value(forKey: "reason") as! String
                    showAlert(strMsg: strMsg, vc: self)
                }
            }) { (response:String!) in
                showAlert(strMsg: response, vc: self)
                print("Error is \(response)")
            }
        }
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
        
    }
}
