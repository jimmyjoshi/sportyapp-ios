//
//  ZoomImageViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 08/08/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController,UIScrollViewDelegate, MWPhotoBrowserDelegate
{
    //@IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var webVw: UIWebView!
    var imgVw = UIImageView()
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var scrollvw: UIScrollView!
    var strLink = String()
    @IBOutlet weak var lblScreenTitle: UILabel!
    var strScreenTitle = String()
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtVenue: UITextView?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPost: UIImageView!
    var dictofPost = NSDictionary()
    var browser:MWPhotoBrowser? // declared outside functions
    var photos = NSMutableArray()
    let windowButton: UIButton = UIButton(type: UIButtonType.custom)

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        webVw.isHidden = true
//        lblScreenTitle.text = strScreenTitle
        
        imgPost.contentMode = .scaleAspectFit
        imgPost.clipsToBounds = true

        let strURL : String = strLink.replacingOccurrences(of: " ", with: "%20")
        let url2 = URL(string: strURL)
        if url2 != nil {
            imgPost.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
        }
        
        if let dictUser = dictofPost.value(forKey: "postCreator")
        {
            lblName.text = (dictUser as! NSDictionary).value(forKey: "username") as! String?
            if let userImage = (dictUser as! NSDictionary).value(forKey: "image")
            {
                setImage(img: imgUser, strUrl: "\(userImage)")
            }
        }
        txtVenue?.text = dictofPost.value(forKey: "description") as? String

        
       /* var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(strLink)
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        self.view.addSubview(browser.view)*/
        
//        webVw.loadRequest(URLRequest(url: URL(string: strLink)!))
        // Do any additional setup after loading the view.
        //let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.vwTapped(sender:)))
        //self.vwBg.addGestureRecognizer(gesture)
        
       /*
        let scrollImg: UIScrollView = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight-64)
        scrollImg.backgroundColor = UIColor.clear
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = false
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 8.0
        
        self.view.addSubview(scrollImg)
        imgVw.frame = CGRect(x: 0, y: 0, width: screenWidth, height: scrollImg.frame.size.height)
        imgVw.backgroundColor = UIColor.clear
        imgVw.contentMode = .scaleToFill
        scrollImg.addSubview(imgVw)
        
        let strURL : String = strLink.replacingOccurrences(of: " ", with: "%20")
        let url2 = URL(string: strURL)
        if url2 != nil {
            imgVw.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
        }*/
    }
    
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

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imgVw
    }

    @IBAction func btnActionBackClicked(sender : UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.alpha = 0
//        }, completion: {
//            (value: Bool) in
//            
//            self.removeFromParentViewController()
//            self.view.removeFromSuperview()
//        })
    }
    func vwTapped(sender : UITapGestureRecognizer)
    {
        // Do what you want
//        UIView.animate(withDuration: 0.3, animations: {
//            self.view.alpha = 0
//        }, completion: {
//            (value: Bool) in
//            
//            self.removeFromParentViewController()
//            self.view.removeFromSuperview()
//        })
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnopenBigImage(sender: UIButton)
    {
        let photo:MWPhoto = MWPhoto(url: URL(string:strLink))
        photo.caption = dictofPost.value(forKey: "description") as? String
        self.photos = [photo]
        
        browser = MWPhotoBrowser(delegate: self)
        
        browser?.displayActionButton = true
        browser?.displayNavArrows = true
        browser?.displaySelectionButtons = false
        browser?.zoomPhotosToFill = true
        browser?.alwaysShowControls = true
        browser?.enableGrid = false
        browser?.startOnGrid = false
        browser?.enableSwipeToDismiss = false
        browser?.setCurrentPhotoIndex(0)
        
        self.present(browser!, animated: true, completion: {
            self.windowButton.frame = CGRect(x: 10, y: 20, width: 44, height: 44)
            self.windowButton.setImage(UIImage(named: "backIcon"), for: .normal)
            self.windowButton.addTarget(self, action: #selector(self.dismissFunc), for: UIControlEvents.touchDown)
            if let window:UIWindow = (UIApplication.shared.delegate?.window)! {
                window.addSubview(self.windowButton)
            }
        })
    }
    func dismissFunc()
    {
        self.windowButton.removeFromSuperview()
        self.browser?.dismiss(animated: true, completion: {
        })
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

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
