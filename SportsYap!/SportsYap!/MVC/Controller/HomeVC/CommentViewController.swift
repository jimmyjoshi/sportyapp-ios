//
//  CommentViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 05/08/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtPost: UITextField!
    @IBOutlet weak var tblComment: UITableView!
    @IBOutlet weak var vwBg: UIView!
    var objHomeVc : HomeVC?
    var objDiscoverVc : DiscoverVC?
    var objChallengeVc : ChallengePostListViewController?
    
    var strFromScreen = String("")!
    var dictPost = NSDictionary()
    var arrComment = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.vwTapped(sender:)))
        self.vwBg.addGestureRecognizer(gesture)
        arrComment = NSMutableArray()
        arrComment = (dictPost.value(forKey: "postComments") as! NSArray).mutableCopy() as! NSMutableArray
        txtPost.delegate = self
        // Do any additional setup after loading the view.
        tblComment.delegate = self
        tblComment.dataSource = self
        tblComment.estimatedRowHeight = 150.0
        tblComment.rowHeight = UITableViewAutomaticDimension
        tblComment.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnPostClicked(sender: UIButton) {
        self.view.endEditing(true)
        txtPost.text = txtPost.text?.trimmingCharacters(in: .whitespaces)
        if isValid() {
            callCommentPostApi()
        }
    }
    
    @IBAction func btnBackClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func vwTapped(sender : UITapGestureRecognizer) {
        // Do what you want
        UIView.animate(withDuration: 0.3, animations: {
            //self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    //MARK:- Textfield delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.3, animations: {
            //self.view.alpha = 0
        }, completion: {
            (value: Bool) in
            
            self.tblComment.isHidden = false
            
        })
        return false
    }
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        UIView.animate(withDuration: 0.3, animations: {
            //self.view.alpha = 0
        }, completion: {
            (value: Bool) in
            self.tblComment.isHidden = false
        })
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            //self.view.alpha = 0
        }, completion: {
            (value: Bool) in
            
            self.tblComment.isHidden = true
            
        })
    }
    func isValid()->Bool {
        txtPost.text = txtPost.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if txtPost.text?.characters.count == 0 {
            showAlert(strMsg: "Please comment to post.", vc: self)
            return false
        }
        return true
    }

    func callCommentPostApi() {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy hh:mm:ss"
        let strDate = dateFormatterGet.string(from: NSDate() as Date)
        
        var dictComment = NSMutableDictionary()
        dictComment.setValue(UserClass.sharedInstance.strName, forKey: "name")
        dictComment.setValue(txtPost.text, forKey: "commentText")
        dictComment.setValue(strDate, forKey: "commentCreatedAt")
        dictComment.setValue(UserClass.sharedInstance.urlProfile, forKey: "image")
        
        
        var userId : String = "\(dictPost.value(forKey: "id")!)"
        let strUrl : String = "posts/add-comment"
        var params : [String:AnyObject]
        params = ["comment": txtPost.text as AnyObject,
                 "post_id": userId as AnyObject]
        MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
            print("Response \(response as NSDictionary)")
            var strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
            
            showAlert(strMsg: strMes, vc: self)
            self.txtPost.text = ""
            self.arrComment.add(dictComment)
            self.tblComment.reloadData()
            
            UIView.animate(withDuration: 0.3, animations: {
                
                if self.strFromScreen == "1"
                {
                    self.objHomeVc?.changeTab()
                }
                else if self.strFromScreen == "2" {
                    self.objDiscoverVc?.getFeedsList()
                }
                else if self.strFromScreen == "3" {
                    self.objChallengeVc?.getFeedsList()
                }
                /*
                if self.objHomeVc == nil
                {
                    self.objDiscoverVc?.getFeedsList()
                }
                else if self.objChallengeVc == nil {
                    self.objHomeVc?.changeTab()
                }
                else
                {
                    self.objChallengeVc?.getFeedsList()
                }*/
                
            }, completion: {
                (value: Bool) in
                self.tblComment.isHidden = false
            })
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
        
    }

}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! commentCell
        
        var dictComment : NSDictionary = arrComment.object(at: indexPath.row) as! NSDictionary
        
        let strUserName : String = dictComment.value(forKey: "name") as! String
        let strComment : String = dictComment.value(forKey: "commentText") as! String
        let usernameFont = UIFont.boldSystemFont(ofSize:  17.0)
        var attrUserNameString = NSMutableAttributedString(
            string: strUserName + ": ",
            attributes: [NSFontAttributeName:usernameFont,NSForegroundColorAttributeName:UIColor.black])
        let commentFont = UIFont.systemFont(ofSize: 17.0)
        let attrCommentString = NSMutableAttributedString(
            string: strComment,
            attributes: [NSFontAttributeName:commentFont])
        attrUserNameString.append(attrCommentString)
        
        //cell.lblUserName.text = dictComment.value(forKey: "name") as! String
        //cell.lblComment.attributedText = attrUserNameString
        
        //cell.lblUserName.text = dictComment.value(forKey: "name") as! String
        cell.lblComment.attributedText = attrUserNameString//dictComment.value(forKey: "commentText") as! String
        cell.lblTime.text = dictComment.value(forKey: "commentCreatedAt") as! String

        var strImgLink : String = "\(dictComment.value(forKey: "image")!)"
        let strURL : String = strImgLink.replacingOccurrences(of: " ", with: "%20")
        let url2 = URL(string: strURL)
        if url2 != nil {
            cell.imgUser.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_image"))
        }
        
        //cell.imgUser.downloadImage(from: "\(dictComment.value(forKey: "image")!)")
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class commentCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var imgGIF: UIImageView?
    @IBOutlet weak var imgGIFheightLayout: NSLayoutConstraint?
}

