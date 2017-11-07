//
//  ChallengePostListViewController.swift
//  SportsYap!
//
//  Created by Sagar Jagajeev on 29/10/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class ChallengePostListViewController: UIViewController {
    @IBOutlet weak var tblMatch: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var vwNoGame: UIView!
   
    var arrTimelineData = NSArray()
    var strDate = ""
    var date = Date()
    
    var currentGameObject = GameClass()
    var strMatchId = String("")!
    var intMaxComment : Int = 2
    
    //Emoji Configuration
    @IBOutlet weak var vwEmojiView: UIView!
    @IBOutlet weak var cvEmojiCollection: UICollectionView!
    var arrEmojiGIFData = NSArray()
    var arrSelectedEmoji = NSMutableArray()
    @IBOutlet weak var btnPostEmoji: UIButton!
    var EmojiPostID = Int()
    var bfromGameTimeline = Bool()
    @IBOutlet weak var lblScreenTitle: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblScreenTitle.text =  "\(currentGameObject.strTeam1FirstName) \(currentGameObject.strTeam1LastName) vs \(currentGameObject.strTeam2FirstName) \(currentGameObject.strTeam2LastName)"

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tblMatch.estimatedRowHeight = 82.0
        self.tblMatch.rowHeight = UITableViewAutomaticDimension
        getFeedsList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getFeedsList() {
        self.tblMatch.reloadData()
        let dictParameter : [String:AnyObject]  = ["gameId": currentGameObject.strMatchId as AnyObject, "homeTeamId": currentGameObject.strHomeMatchId as AnyObject, "awayTeamId": currentGameObject.strAwayMatchId as AnyObject]
        var strURL = String("")!
        
        if bfromGameTimeline == true
        {
            strURL = "\(base_Url)posts/get-game-timeline"
        }
        else
        {
            strURL = "\(base_Url)sporty-fans-challenge/get-posts"
        }
        
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strURL, parameter: dictParameter, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            let arrData = response as NSDictionary
            self.arrTimelineData = NSArray()
            self.arrTimelineData =  arrData.value(forKey: "data") as! NSArray
            self.tblMatch.reloadData()
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
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
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblMatch)
        let indexPath = self.tblMatch.indexPathForRow(at: buttonPosition)
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
    
    func btnCommentClicked(sender:UIButton) {
        let intRow = sender.tag
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: CommentViewController = cameraStoryboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        tagDetailVC.dictPost = arrTimelineData.object(at: intRow) as! NSDictionary
        tagDetailVC.modalPresentationStyle = .overCurrentContext
        tagDetailVC.strFromScreen = "3"
        tagDetailVC.objChallengeVc = self
        self.present(tagDetailVC, animated: true, completion: nil)
    }
    
    @IBAction func btnBackClicked(sender: UIButton){
        _=self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Function to set Image
    func setImage(img: UIImageView,strUrl: String){
        if strUrl != "" {
            var strURL = String("")!
            strURL = strUrl.replacingOccurrences(of: " ", with: "%20")
            let url2 = URL(string: strURL)
            if url2 != nil {
                img.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
            }
        }
    }
    
    //MARK: Emoji Selection
    func btnEmojiAction(sender:UIButton)
    {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblMatch)
        let indexPath = self.tblMatch.indexPathForRow(at: buttonPosition)
        let intRow = sender.tag
        EmojiPostID = (arrTimelineData.object(at: intRow) as! NSDictionary).value(forKey: "id") as! Int
        
        
        var strURL = String("")!
        strURL = "\(base_Url)sporty-gifs"
        MainReqeustClass.BaseRequestSharedInstance.getData(showLoader: true, url: strURL, parameter: nil, success: { (response:Dictionary<String, AnyObject>) in
            //self.strMatchTpe = strMatchType
            let arrData = response as NSDictionary
            print("Data is \(arrData)")
            
            self.vwEmojiView.isHidden = false
            
            self.arrEmojiGIFData = NSArray()
            self.arrSelectedEmoji = NSMutableArray()
            self.arrEmojiGIFData =  arrData.value(forKey: "data") as! NSArray
            self.cvEmojiCollection.reloadData()
            
        }) { (response:String!) in
            print("Response is not proper")
        }
    }
    
    @IBAction func btnCheckUnCheck(sender: UIButton)
    {
        let interestdata =  self.arrEmojiGIFData[sender.tag] as! NSDictionary
        
        if !self.arrSelectedEmoji.contains(interestdata.value(forKey: "gif_Id")!)
        {
            self.arrSelectedEmoji = NSMutableArray()
            self.arrSelectedEmoji.add(interestdata.value(forKey: "gif_Id")!)
        }
        else
        {
            self.arrSelectedEmoji.remove(interestdata.value(forKey: "gif_Id")!)
        }
        self.cvEmojiCollection.reloadData()
    }
    @IBAction func btnCloseEmojiAction(sender:UIButton)
    {
        vwEmojiView.isHidden = true
    }
    
    @IBAction func btnPostEmojiAction(_ sender: UIButton)
    {
        var strUrl = String()
        strUrl = "posts/add-comment"
        var params : [String:AnyObject]
        
        if arrSelectedEmoji.count > 0
        {
            params = ["post_id": "\(EmojiPostID)" as AnyObject , "gif_id": "\(arrSelectedEmoji[0])" as AnyObject]
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                
                self.vwEmojiView.isHidden = true
                print("Response \(response as NSDictionary)")
                let strMes : String = "\((response as NSDictionary).value(forKey: "message")!)"
                self.getFeedsList()

            })
            { (response:String!) in
                showAlert(strMsg: response, vc: self)
                print("Error is \(response)")
            }
        }
        else
        {
            showAlert(strMsg: "Please select Emoji", vc: self)
        }
    }
    
    //MARK: Delete Post
    func btnDeleteAction(sender:UIButton)
    {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblMatch)
        let intRow = sender.tag
        let iDeleteId : Int = (arrTimelineData.object(at: intRow) as! NSDictionary).value(forKey: "id") as! Int
        
        let alertView = UIAlertController(title: AppName, message: "Are you sure want to delete post?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default)
        { (action) in
            
            var strUrl = String()
            strUrl = "posts/delete"
            var params : [String:AnyObject]
            
            params = ["post_id": "\(iDeleteId)" as AnyObject]
            MainReqeustClass.BaseRequestSharedInstance.PostRequset(showLoader: true, url: strUrl, parameter: params as [String : AnyObject]?, success: { (response:Dictionary<String, AnyObject>) in
                print("Response \(response as NSDictionary)")
                self.getFeedsList()
            })
            { (response:String!) in
                showAlert(strMsg: response, vc: self)
                print("Error is \(response)")
            }
        }
        alertView.addAction(OKAction)
        let CancelAction = UIAlertAction(title: "No", style: .default)
        {
            (action) in
        }
        alertView.addAction(CancelAction)
        self.present(alertView, animated: true, completion: nil)
    }

}

extension ChallengePostListViewController: UITableViewDataSource,UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
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
        /*
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: CommentViewController = cameraStoryboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        tagDetailVC.dictPost = arrTimelineData.object(at: indexPath.section) as! NSDictionary
        tagDetailVC.objHomeVc = self
        tagDetailVC.modalPresentationStyle = .overCurrentContext
        self.present(tagDetailVC, animated: true, completion: nil)*/
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var mainCell = UITableViewCell()
        if indexPath.row == 0 {
            let cell : timelineCell = tableView.dequeueReusableCell(withIdentifier: "timelineCell") as! timelineCell
            
            let dict : NSDictionary = arrTimelineData.object(at: indexPath.section) as! NSDictionary
            //cell.lblTime.text = dict.value(forKey: "created_at") as! String
            
            if let dictUser = dict.value(forKey: "postCreator") {
                cell.lblName.text = (dictUser as! NSDictionary).value(forKey: "name") as! String?
                
                //cell.lblName.text = "\(dictUser)"
                if let userImage = (dictUser as! NSDictionary).value(forKey: "image")
                {
                    setImage(img: cell.imgUser, strUrl: "\(userImage)")
                }
            }
            cell.lblVenue.text = dict.value(forKey: "description") as? String
            cell.txtVenue?.text = dict.value(forKey: "description") as? String
            cell.txtVenue?.sizeToFit()
            
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
            //cell.imgGameType.image = UIImage(named: "sball0")
            
            cell.btnEmoji?.tag = indexPath.section
            cell.btnEmoji?.addTarget(self, action: #selector(self.btnEmojiAction(sender:)), for: .touchUpInside)
            
            
            if let iImageGIF = dict.value(forKey: "can_delete")
            {
                if iImageGIF as! Int == 1
                {
                    cell.btnDeleteWidthLayout?.constant = 46
                }
                else
                {
                    cell.btnDeleteWidthLayout?.constant = 0
                }
            }
            else
            {
                cell.btnDeleteWidthLayout?.constant = 0
            }
            
            cell.btnDelete?.tag = indexPath.section
            cell.btnDelete?.addTarget(self, action: #selector(self.btnDeleteAction(sender:)), for: .touchUpInside)

            
            
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
            let strvideo = dict.value(forKey: "video") as! String
            if strImg == ""  && strvideo == "" {
                cell.heightLayout.constant = 0
            }
            else
            {
                cell.heightLayout.constant = screenWidth
                //cell.imgPost.layer.cornerRadius = 10.0
                //cell.imgPost.clipsToBounds = true
                cell.imgPost.tag = indexPath.section
                let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.imgTapped(sender:)))
                cell.imgPost.addGestureRecognizer(gesture)
                
                var strURL = String("")!
                //Video thumbnai is to be displayed
                if strImg == "" {
                    let strVideoThumbUrl = dict.value(forKey: "videoImg") as! String
                    strURL = strVideoThumbUrl.replacingOccurrences(of: " ", with: "%20")
                    /*let imgVw : UIImageView = UIImageView(frame: CGRect(x: (screenWidth - 50)/2, y: (screenWidth - 50)/2, width: 50, height: 50))
                     imgVw.image = UIImage(named: "nogameIcon")
                     
                     cell.imgPost.addSubview(imgVw)*/
                    
                }
                else
                {
                    strURL = strImg.replacingOccurrences(of: " ", with: "%20")
                }
                
                //let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
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
            //total = (total - 2) + indexPath.row
            
            //let arrComment : NSArray = mainDict.value(forKey: "postComments") as! NSArray
            let dictComment : NSDictionary = arrComment.object(at: total) as! NSDictionary
            
            let strUserName : String = dictComment.value(forKey: "name") as! String
            
            let strComment : String = dictComment.value(forKey: "commentText") as! String
            
            //GIF Integration
            if let iImageGIF = dictComment.value(forKey: "is_image")
            {
                if iImageGIF as! Int == 1
                {
                    cell.imgGIFheightLayout?.constant = 60
                    let strImgLink : String = "\(dictComment.value(forKey: "commentImage")!)"
                    let strURL : String = strImgLink.replacingOccurrences(of: " ", with: "%20")
                    let url2 = URL(string: strURL)
                    if url2 != nil {
                        cell.imgGIF?.sd_setImage(with: url2, placeholderImage: UIImage(named: "profile_image"))
                    }
                }
                else
                {
                    cell.imgGIFheightLayout?.constant = 0
                }
            }
            else
            {
                cell.imgGIFheightLayout?.constant = 0
            }

            
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
            cell.lblComment.attributedText = attrUserNameString//strUserName + ": " + strComment//dictComment.value(forKey: "commentText") as! String
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
extension ChallengePostListViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    //Collection view delegare
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
            return arrEmojiGIFData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
            return CGSize(width: 75, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var mainCell = UICollectionViewCell()
        let identifier = "cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! EmojiCell
        let interestdata =  self.arrEmojiGIFData[indexPath.row] as! NSDictionary
        
        cell.imgview.layer.cornerRadius = 5.0
        cell.imgview.layer.masksToBounds = true
        if self.arrSelectedEmoji.count > 0
        {
            if self.arrSelectedEmoji.contains(interestdata.value(forKey: "gif_Id")!)
            {
                cell.btnCheck.isSelected = true
            }
            else
            {
                cell.btnCheck.isSelected = false
            }
        }
        else
        {
            cell.btnCheck.isSelected = false
        }
        
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(btnCheckUnCheck(sender:)), for: .touchUpInside)
        
        if let url = interestdata["gif_Image"]
        {
            cell.imgview.sd_setImage(with:URL(string: url as! String), placeholderImage:nil)
        }
        else
        {
            cell.imgview.image = UIImage(named: "")
        }
        
        mainCell = cell
        return mainCell
    }
}
