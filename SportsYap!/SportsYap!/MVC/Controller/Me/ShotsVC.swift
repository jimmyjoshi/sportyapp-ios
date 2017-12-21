//
//  ShotsVC.swift
//  SportsYap!
//
//  Created by Yash on 12/11/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ShotsVC: UIViewController, MWPhotoBrowserDelegate
{
    @IBOutlet weak var tblMatch: UITableView!
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
    
    @IBOutlet weak var vwPostView: UIView!
    var bfromVideoPlayer = Bool()

    //MWPhotoBrowser
    var photos = NSMutableArray()
    let windowButton: UIButton = UIButton(type: UIButtonType.custom)
    var browser:MWPhotoBrowser? // declared outside functions

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(false)
        self.tblMatch.estimatedRowHeight = 82.0
        self.tblMatch.rowHeight = UITableViewAutomaticDimension
        
        if bfromVideoPlayer == true
        {
            bfromVideoPlayer = false
        }
        else
        {
            getFeedsList()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getFeedsList()
    {
        var strURL = String("")!
            strURL = "\(base_Url)posts/user/shots"
        
        MainReqeustClass.BaseRequestSharedInstance.postRequest(showLoader: true, url: strURL, parameter: nil, header: getHeaderData(), success: { (response:Dictionary<String,AnyObject>) in
            let arrData = response as NSDictionary
            self.arrTimelineData = NSArray()
            self.arrTimelineData =  arrData.value(forKey: "data") as! NSArray
            self.tblMatch.reloadData()
            
        }) { (response:String!) in
            showAlert(strMsg: response, vc: self)
            print("Error is \(response)")
        }
    }
    
    func imgTapped(sender : UITapGestureRecognizer)
    {
        let imgVw : UIImageView = sender.view as! UIImageView
        let dic : NSDictionary = arrTimelineData.object(at: imgVw.tag) as! NSDictionary
        let strImgLink : String = dic.value(forKey: "image") as! String
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageVC = storyboard.instantiateViewController(withIdentifier: "ZoomImageViewController") as! ZoomImageViewController
        imageVC.strLink = strImgLink
        //            imageVC.strScreenTitle = (dic.value(forKey: "description") as? String)!
        imageVC.dictofPost = dic
        self.navigationController?.pushViewController(imageVC, animated: true)

        /*
        let photo:MWPhoto = MWPhoto(url: URL(string:strImgLink))
        photo.caption = dic.value(forKey: "description") as? String
        self.photos = [photo]
        
        browser = MWPhotoBrowser(delegate: self)
        
        browser?.displayActionButton = true
        browser?.displayNavArrows = true
        browser?.displaySelectionButtons = false
        browser?.zoomPhotosToFill = true
        browser?.alwaysShowControls = true
        browser?.enableGrid = false
        browser?.startOnGrid = false
        browser?.enableSwipeToDismiss = true
        browser?.setCurrentPhotoIndex(0)
        
        self.present(browser!, animated: true, completion: {
            self.windowButton.frame = CGRect(x: 10, y: 20, width: 44, height: 44)
            self.windowButton.setImage(UIImage(named: "backIcon"), for: .normal)
            self.windowButton.addTarget(self, action: #selector(self.dismissFunc), for: UIControlEvents.touchDown)
            if let window:UIWindow = (UIApplication.shared.delegate?.window)! {
                window.addSubview(self.windowButton)
            }
        })*/

        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageVC = storyboard.instantiateViewController(withIdentifier: "ZoomImageViewController") as! ZoomImageViewController
        imageVC.strLink = strImgLink
        self.view.addSubview(imageVC.view)
        self.addChildViewController(imageVC)*/
        
    }
    
    //MARK: MWphotoBrowser
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol!
    {
        if Int(index) < self.photos.count
        {
            return photos.object(at: Int(index)) as! MWPhoto
        }
        return nil
    }
    
    func photoBrowserDidFinishModalPresentation(_ photoBrowser:MWPhotoBrowser)
    {
        self.dismiss(animated: true, completion:nil)
    }
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.photos.count)
        
    }
    func dismissFunc()
    {
        self.windowButton.removeFromSuperview()
        self.browser?.dismiss(animated: true, completion: {
        })
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
    
    func btnCommentClicked(sender:UIButton)
    {
        let intRow = sender.tag
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tagDetailVC: CommentViewController = cameraStoryboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        tagDetailVC.dictPost = arrTimelineData.object(at: intRow) as! NSDictionary
        tagDetailVC.modalPresentationStyle = .overCurrentContext
        tagDetailVC.strFromScreen = "4"
        tagDetailVC.objShotsVC = self
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
        let intRow = sender.tag
        let iDeleteId : Int = (arrTimelineData.object(at: intRow) as! NSDictionary).value(forKey: "id") as! Int
        
        if let iImageGIF = (arrTimelineData.object(at: intRow) as! NSDictionary).value(forKey: "can_delete")
        {
            if iImageGIF as! Int == 1
            {
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
            else
            {
                let intRow = sender.tag
                let iDeleteId : Int = (arrTimelineData.object(at: intRow) as! NSDictionary).value(forKey: "id") as! Int
                
                let alertView = UIAlertController(title: AppName, message: "Are you sure want to report post?", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "Yes", style: .default)
                { (action) in
                    
                    var strUrl = String()
                    strUrl = "report-post"
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
    }
    
    //MARK:- Delete Comment
    func btnDeleteComment(sender: UIButton){
        let iDeleteId : Int = sender.tag
        let alertView = UIAlertController(title: AppName, message: "Are you sure want to delete comment?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Yes", style: .default)
        { (action) in
            
            var strUrl = String()
            strUrl = "posts/delete-comment"
            var params : [String:AnyObject]
            
            params = ["comment_id": "\(iDeleteId)" as AnyObject]
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
    
    //MARK: Button Actions
    @IBAction func btnCreateImagePostClicked(sender: UIButton)
    {
        vwPostView.isHidden = true
        /*
         let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
         postVC.isImageUploaded = true
         self.navigationController?.pushViewController(postVC, animated: true)*/
        
        
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: GameTimeLinePostVC = cameraStoryboard.instantiateViewController(withIdentifier: "GameTimeLinePostVC") as! GameTimeLinePostVC
        postVC.selectedGame = currentGameObject
        postVC.isImageUploaded = true
        postVC.bolyGallery = true
        self.navigationController?.pushViewController(postVC, animated: true)
        //postVC.isImageUploaded = true
    }
    
    @IBAction func btnCreateVideoPostClicked(sender: UIButton)
    {
        vwPostView.isHidden = true
        //        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        //        postVC.isVideoUploaded = true
        //        self.navigationController?.pushViewController(postVC, animated: true)
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: GameTimeLinePostVC = cameraStoryboard.instantiateViewController(withIdentifier: "GameTimeLinePostVC") as! GameTimeLinePostVC
        postVC.selectedGame = currentGameObject
        postVC.isVideoUploaded = true
        self.navigationController?.pushViewController(postVC, animated: true)
        
    }
    @IBAction func btnCreateCameraPostClicked(sender: UIButton)
    {
        vwPostView.isHidden = true
        
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        postVC.bonlyCamera = true
        postVC.isImageUploaded = true
        postVC.selectedGame = currentGameObject
        self.navigationController?.pushViewController(postVC, animated: true)
    }

    @IBAction func btnClosePostView(_ :UIButton)
    {
        
        UIView.animate(withDuration: 0.3, animations: {
            
        }, completion: {
            (value: Bool) in
            
            self.vwPostView.isHidden = true
        })
    }
    
    @IBAction func btnCreateNewPostClicked(sender: UIButton)
    {
        self.view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.vwPostView.isHidden = false
    }
    //MARK: Play Clicked
    func btnPlayClicked(sender:UIButton)
    {
        let dic : NSDictionary = arrTimelineData.object(at: sender.tag) as! NSDictionary
        //This is video
        let strVideoLink : String = dic.value(forKey: "video") as! String
        
        bfromVideoPlayer = true
        let videoURL = URL(string: strVideoLink)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
        /*
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let videoVC = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
         videoVC.strLink = strVideoLink
         self.navigationController?.pushViewController(videoVC, animated: true)*/
    }
    
}

extension ShotsVC: UITableViewDataSource,UITableViewDelegate
{
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
        
        
        let strImg = dict.value(forKey: "image") as! NSString
        let strvideo = dict.value(forKey: "video") as! String
        let strVideoThumbUrl = dict.value(forKey: "videoImg") as! String
        
        if strImg == ""  && strvideo == "" && strVideoThumbUrl == ""
        {
            cell.heightLayout.constant = 0
            cell.btnPlay?.isHidden = true
        }
        else
        {
            if strImg.length > 0
            {
                cell.btnPlay?.isHidden = true
            }
            else
            {
                cell.btnPlay?.isHidden = false
            }
            
            cell.heightLayout.constant = screenWidth
            //cell.imgPost.layer.cornerRadius = 10.0
            //cell.imgPost.clipsToBounds = true
            cell.imgPost.tag = section
            let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.imgTapped(sender:)))
            cell.imgPost.addGestureRecognizer(gesture)
            
            cell.btnPlay?.tag = section
            cell.btnPlay?.addTarget(self, action: #selector(self.btnPlayClicked(sender:)), for: .touchUpInside)
            
            
            
            var strURL = String("")!
            //Video thumbnai is to be displayed
            if strImg == ""
            {
                strURL = strVideoThumbUrl.replacingOccurrences(of: " ", with: "%20")
                /*let imgVw : UIImageView = UIImageView(frame: CGRect(x: (screenWidth - 50)/2, y: (screenWidth - 50)/2, width: 50, height: 50))
                 imgVw.image = UIImage(named: "nogameIcon")
                 
                 cell.imgPost.addSubview(imgVw)*/
                
            }
            else
            {
                strURL = strImg.replacingOccurrences(of: " ", with: "%20")
            }
            
            cell.imgPost.contentMode = .scaleAspectFit
            cell.imgPost.clipsToBounds = true

            //let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
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
                //cell.lblName.text = (dictUser as! NSDictionary).value(forKey: "name") as! String?
                cell.lblName.text = (dictUser as! NSDictionary).value(forKey: "username") as! String?
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
                    cell.btnDelete?.setTitle("Delete", for: .normal)
                    
                }
                else
                {
                    cell.btnDeleteWidthLayout?.constant = 0
                    cell.btnDelete?.setTitle("Report", for: .normal)
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
            
            
            let strImg = dict.value(forKey: "image") as! NSString
            let strvideo = dict.value(forKey: "video") as! String
            let strVideoThumbUrl = dict.value(forKey: "videoImg") as! String
            
            if strImg == ""  && strvideo == "" && strVideoThumbUrl == ""
            {
                cell.heightLayout.constant = 0
                cell.btnPlay?.isHidden = true
            }
            else
            {
                if strImg.length > 0
                {
                    cell.btnPlay?.isHidden = true
                }
                else
                {
                    cell.btnPlay?.isHidden = false
                }
                
                cell.heightLayout.constant = screenWidth
                //cell.imgPost.layer.cornerRadius = 10.0
                //cell.imgPost.clipsToBounds = true
                cell.imgPost.tag = indexPath.section
                let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.imgTapped(sender:)))
                cell.imgPost.addGestureRecognizer(gesture)
                
                cell.btnPlay?.tag = indexPath.section
                cell.btnPlay?.addTarget(self, action: #selector(self.btnPlayClicked(sender:)), for: .touchUpInside)
                
                
                
                var strURL = String("")!
                //Video thumbnai is to be displayed
                if strImg == ""
                {
                    strURL = strVideoThumbUrl.replacingOccurrences(of: " ", with: "%20")
                    /*let imgVw : UIImageView = UIImageView(frame: CGRect(x: (screenWidth - 50)/2, y: (screenWidth - 50)/2, width: 50, height: 50))
                     imgVw.image = UIImage(named: "nogameIcon")
                     
                     cell.imgPost.addSubview(imgVw)*/
                    
                }
                else
                {
                    strURL = strImg.replacingOccurrences(of: " ", with: "%20")
                }
                
                cell.imgPost.contentMode = .scaleAspectFit
                cell.imgPost.clipsToBounds = true
                //let strURL : String = strImg.replacingOccurrences(of: " ", with: "%20")
                let url2 = URL(string: strURL)
                if url2 != nil {
                    cell.imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
                }
            }
            
            /*
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
             }*/
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
            
            
            //Delete Comment
            if let canD = dictComment.value(forKey: "can_delete") {
                
                if "\(canD)" == "0" {
                    cell.btnDelete?.isHidden = true
                }
                else {
                    cell.btnDelete?.isHidden = false
                    cell.btnDelete?.tag = Int("\(dictComment.value(forKey: "commentId")!)")!
                    cell.btnDelete?.addTarget(self, action: #selector(self.btnDeleteComment(sender:)), for: .touchUpInside)
                }
            }
            
            //GIF Integration
            if let iImageGIF = dictComment.value(forKey: "is_image")
            {
                if iImageGIF as! Int == 1
                {
                    cell.imgGIFheightLayout?.constant = 200
                    cell.imgGIFWidthLayout?.constant = 200
                    
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
extension ShotsVC: UICollectionViewDelegate, UICollectionViewDataSource
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
