//
//  DiscoverVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 24/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit



class SportsTypeDiscoverCell: UICollectionViewCell {
    @IBOutlet weak var btnGame: UIButton!
    
    override func awakeFromNib() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btnGame.layer.cornerRadius = self.btnGame.frame.size.height/2
            self.btnGame.layer.masksToBounds = true
            self.btnGame.layer.borderColor = UIColor.black.cgColor
        }
    }
    
}
class DiscoverVC: UIViewController {
    var intMaxComment : Int = 2
    @IBOutlet weak var tblPostList: UITableView!
    var arrTimelineData = NSArray()
    var arrList = Array<GameClass>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblPostList.estimatedRowHeight = 82.0
        self.tblPostList.rowHeight = UITableViewAutomaticDimension
        self.getFeedsList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnSearchPressed(_ : UIButton) {
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let discoverUserVC = homeStoryboard.instantiateViewController(withIdentifier: "DiscoverUserVC")
        self.navigationController?.pushViewController(discoverUserVC, animated: true)
    }
    func imgTapped(sender : UITapGestureRecognizer) {
        let imgVw : UIImageView = sender.view as! UIImageView
        let dic : NSDictionary = arrTimelineData.object(at: imgVw.tag) as! NSDictionary
        let strImgLink : String = dic.value(forKey: "image") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageVC = storyboard.instantiateViewController(withIdentifier: "ZoomImageViewController") as! ZoomImageViewController
        imageVC.strLink = strImgLink
        self.view.addSubview(imageVC.view)
        self.addChildViewController(imageVC)
        
    }
    
    func btnLikeClicked(sender:UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblPostList)
        let indexPath = self.tblPostList.indexPathForRow(at: buttonPosition)
        //print("likeclicke \(indexPath?.row)")
        let intRow = sender.tag
        let id : Int = (arrTimelineData.object(at: intRow) as! NSDictionary).value(forKey: "id") as! Int
        let intLiked : Int =  (arrTimelineData.object(at: intRow) as! NSDictionary).value(forKey: "is_liked") as! Int
        var strUrl = String()
        
        //post has been liked so need to call unlike
        if intLiked == 1 {
            strUrl = "posts/unlike"
        }
        else
        {
            strUrl = "posts/like"
        }
        
        //let strUrl : String = "posts/like"
        var params : [String:AnyObject]
        params = ["post_id": "\(id)" as AnyObject]
        MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
            print("Response \(response as NSDictionary)")
            let strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
            self.getFeedsList()
            //showAlert(strMsg: strMes, vc: self)
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    func getFeedsList() {
        self.arrList.removeAll()
        self.tblPostList.reloadData()
        var strURL = String("")!
        strURL = "\(base_Url)posts/discover-posts"
        MainReqeustClass.BaseRequestSharedInstance.getData(showLoader: true, url: strURL, parameter: nil, success: { (response:Dictionary<String, AnyObject>) in
            //self.strMatchTpe = strMatchType
            let arrData = response as NSDictionary
            print("Data is \(arrData)")
            self.arrTimelineData = NSArray()
            self.arrTimelineData =  arrData.value(forKey: "data") as! NSArray
            self.tblPostList.reloadData()
        }) { (response:String!) in
            print("Response is not proper")
        }
    }
    
    func btnCommentClicked(sender:UIButton) {
        //let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.cvMatchList)
        let intRow = sender.tag//self.tblMatch.indexPathForRow(at: buttonPosition)
        //let indexPath = self.cvMatchList.indexPathForItem(at: buttonPosition)
        
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: CommentViewController = cameraStoryboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        tagDetailVC.dictPost = arrTimelineData.object(at: intRow) as! NSDictionary
        tagDetailVC.modalPresentationStyle = .overCurrentContext
        tagDetailVC.objDiscoverVc = self
        //tagDetailVC.objHomeVc = self
        self.present(tagDetailVC, animated: true, completion: nil)
       
    }
    
}
extension DiscoverVC: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrTimelineData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mainDict : NSDictionary = arrTimelineData.object(at: section) as! NSDictionary
        let arrComment : NSArray = mainDict.value(forKey: "postComments") as! NSArray
        var count : Int = (arrComment.count > intMaxComment) ? intMaxComment : arrComment.count
        count = count + 1
        return count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell : timelineCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell") as! timelineCell
        
        let dict : NSDictionary = arrTimelineData.object(at: section) as! NSDictionary
        cell.lblTime.text = dict.value(forKey: "created_at") as! String
        
        cell.lblVenue.text = dict.value(forKey: "description") as! String
        cell.txtVenue?.text = dict.value(forKey: "description") as! String
        
        
        let intLikeCount : Int = dict.value(forKey: "postLikeCount") as! Int
        let intCommentCount : Int = dict.value(forKey: "postCommentCount") as! Int
        //For Like
        if intLikeCount > 0 {
            cell.btnLike.setTitle("\(intLikeCount) Likes", for: .normal)
        }
        else {
            cell.btnLike.setTitle("Like", for: .normal)
        }
        cell.btnLike.tag = section
        cell.btnLike.addTarget(self, action: #selector(self.btnLikeClicked(sender:)), for: .touchUpInside)
        
        //For Comment
        if intCommentCount > 0 {
            cell.btnComment.setTitle("\(intCommentCount) Comments", for: .normal)
        }
        else
        {
            cell.btnComment.setTitle("Comment", for: .normal)
        }
        cell.btnComment.tag = section
        cell.btnComment.addTarget(self, action: #selector(self.btnCommentClicked(sender:)), for: .touchUpInside)
        //cell.imgGameType.image = UIImage(named: "sball0")
        
        if let intIsLiked = dict.value(forKey: "is_liked") {
            if "\(intIsLiked)" == "0" {
                cell.btnLike.backgroundColor = UIColor.white
                cell.btnLike.setTitleColor(#colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1), for: .normal)
            }
            else
            {
                cell.btnLike.backgroundColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1)
                cell.btnLike.setTitleColor(UIColor.white, for: .normal)
            }
        }
        let strImg = dict.value(forKey: "image") as! String
        if strImg == "" {
            cell.heightLayout.constant = 0
        }
        else
        {
            cell.heightLayout.constant = 234
            cell.imgPost.layer.cornerRadius = 10.0
            cell.imgPost.clipsToBounds = true
            cell.imgPost.tag = section
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.imgTapped(sender:)))
            cell.imgPost.addGestureRecognizer(gesture)
            
            let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
            let url2 = URL(string: strURL)
            if url2 != nil {
                cell.imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
            }
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: CommentViewController = cameraStoryboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        tagDetailVC.dictPost = arrTimelineData.object(at: indexPath.section) as! NSDictionary
        
        //tagDetailVC.objHomeVc = self
        tagDetailVC.modalPresentationStyle = .overCurrentContext
        self.present(tagDetailVC, animated: true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var mainCell = UITableViewCell()
        if indexPath.row == 0 {
            let cell : timelineCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell") as! timelineCell
            
            let dict : NSDictionary = arrTimelineData.object(at: indexPath.section) as! NSDictionary
            //cell.lblTime.text = dict.value(forKey: "created_at") as! String
            
            if let dictUser = dict.value(forKey: "postCreator") {
                cell.lblName.text = (dictUser as! NSDictionary).value(forKey: "name") as! String?
            }
            cell.lblVenue.text = dict.value(forKey: "description") as? String
            cell.txtVenue?.text = dict.value(forKey: "description") as? String
            let intLikeCount : Int = dict.value(forKey: "postLikeCount") as! Int
            let intCommentCount : Int = dict.value(forKey: "postCommentCount") as! Int
            //For Like
            if intLikeCount > 0 {
                cell.btnLike.setTitle("\(intLikeCount) Likes", for: .normal)
            }
            else {
                cell.btnLike.setTitle("Like", for: .normal)
            }
            cell.btnLike.tag = indexPath.section
            cell.btnLike.addTarget(self, action: #selector(self.btnLikeClicked(sender:)), for: .touchUpInside)
            
            //For Comment
            if intCommentCount > 0 {
                cell.btnComment.setTitle("\(intCommentCount) Comments", for: .normal)
            }
            else
            {
                cell.btnComment.setTitle("Comment", for: .normal)
            }
            cell.btnComment.tag = indexPath.section
            cell.btnComment.addTarget(self, action: #selector(self.btnCommentClicked(sender:)), for: .touchUpInside)
            if let intIsLiked = dict.value(forKey: "is_liked") {
                if "\(intIsLiked)" == "0" {
                    cell.btnLike.backgroundColor = UIColor.white
                    cell.btnLike.setTitleColor(#colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1), for: .normal)
                }
                else
                {
                    cell.btnLike.backgroundColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1)
                    cell.btnLike.setTitleColor(UIColor.white, for: .normal)
                }
            }
            
            let strvideo = dict.value(forKey: "video") as! String
            if strvideo == "" {
            }
            else
            {
                cell.lblVenue.text = (dict.value(forKey: "description") as? String)! + "\n\(strvideo)"
                cell.txtVenue?.text = (dict.value(forKey: "description") as? String)! + "\n\(strvideo)"
            }
            cell.txtVenue?.isScrollEnabled = false
            cell.txtVenue?.sizeToFit()
            
            
            let strImg = dict.value(forKey: "image") as! String
            if strImg == "" {
                cell.heightLayout.constant = 0
            }
            else
            {
                cell.heightLayout.constant = screenWidth
                cell.imgPost.tag = indexPath.section
                let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.imgTapped(sender:)))
                cell.imgPost.addGestureRecognizer(gesture)
                
                let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
                let url2 = URL(string: strURL)
                if url2 != nil {
                    cell.imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
                }
            }
            mainCell = cell
        }
        else
        {
            let cell: commentCell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! commentCell
            let mainDict : NSDictionary = arrTimelineData.object(at: indexPath.section) as! NSDictionary
            let arrComment : NSArray = mainDict.value(forKey: "postComments") as! NSArray
            
            var total : Int = arrComment.count
            
            total = (total > intMaxComment) ? (total - intMaxComment) + indexPath.row : indexPath.row
            
            total = total - 1
            let dictComment : NSDictionary = arrComment.object(at: total) as! NSDictionary
            
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
            cell.lblComment.attributedText = attrUserNameString
            cell.lblTime.text = dictComment.value(forKey: "commentCreatedAt") as! String
            var strImgLink : String = "\(dictComment.value(forKey: "image")!)"
            let strURL : String = strImgLink.replacingOccurrences(of: " ", with: "%20")
            let url2 = URL(string: strURL)
            if url2 != nil {
                cell.imgUser.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_image"))
            }
            mainCell = cell
        }
        return mainCell
    }
}
