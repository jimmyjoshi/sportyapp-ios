//
//  FollowingsVC.swift
//  SportsYap!
//
//  Created by Yash on 11/11/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class FollowingsVC: UIViewController
{
    @IBOutlet weak var tblUserLost: UITableView!
    var arrList = NSMutableArray()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.callGetFollowers()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callGetFollowers()
    {
        var strUrl = String("")!
        strUrl = "\(base_Url)users/user-followings"
        MainReqeustClass.BaseRequestSharedInstance.getRequest(showLoader: true, url: strUrl, parameter: nil, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            var arrTmp = NSMutableArray()
            arrTmp  = ((response as NSDictionary).value(forKey: "data") as! NSArray).mutableCopy() as! NSMutableArray
            self.convertToMutable(arrMain: arrTmp)
        })
        { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    func convertToMutable(arrMain: NSMutableArray)
    {
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
    @IBAction func btnCancelPress(_ : UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
extension FollowingsVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: FollowingsCell = tableView.dequeueReusableCell(withIdentifier: "FollowingsCell") as! FollowingsCell
        
        var dictInfo = NSDictionary()
        dictInfo = arrList[indexPath.row] as! NSDictionary
        
        if let img = dictInfo.value(forKey: "image")
        {
            let strImg = dictInfo.value(forKey: "image") as! String
            if strImg == ""
            {
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
        
        if let name = dictInfo.value(forKey: "name")
        {
            cell.lblName.text = "\(name)"
        }
        
        if let location = dictInfo.value(forKey: "location")
        {
            cell.lblLocation.text = "\(location)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        /*
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
        self.navigationController?.pushViewController(meVC, animated: true)*/
    }
}
class FollowingsCell: UITableViewCell
{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    
    override func awakeFromNib()
    {
        setCornurRedius(idObject: ivImage, radius: ivImage.frame.size.height/2)
        ivImage.layer.borderWidth = 1.5
        ivImage.layer.borderColor = UIColor.lightGray.cgColor
    }
}
