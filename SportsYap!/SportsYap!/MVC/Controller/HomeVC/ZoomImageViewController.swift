//
//  ZoomImageViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 08/08/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController,UIScrollViewDelegate {
    //@IBOutlet weak var imgVw: UIImageView!
    
    @IBOutlet weak var webVw: UIWebView!
    var imgVw = UIImageView()
    @IBOutlet weak var vwBg: UIView!
    @IBOutlet weak var scrollvw: UIScrollView!
    var strLink = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        webVw.loadRequest(URLRequest(url: URL(string: strLink)!))
        // Do any additional setup after loading the view.
        //let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.vwTapped(sender:)))
        //self.vwBg.addGestureRecognizer(gesture)
        
        /*
        let vWidth = self.view.frame.width
        let vHeight = self.view.frame.height
        
        let scrollImg: UIScrollView = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 0, y: 64, width: vWidth, height: vHeight-64)
        //scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollImg.backgroundColor = UIColor.clear
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 10.0
        
        self.view.addSubview(scrollImg)
        imgVw.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight - 64)
        imgVw.layer.cornerRadius = 11.0
        imgVw.backgroundColor = UIColor.clear
        imgVw.contentMode = .scaleAspectFit
        imgVw.clipsToBounds = false
        scrollImg.addSubview(imgVw)
        
        //imgVw.downloadImage(from: strLink)
        
        let strURL : String = strLink.replacingOccurrences(of: " ", with: "%20")
        let url2 = URL(string: strURL)
        if url2 != nil {
            imgVw.sd_setImage(with: url2, placeholderImage: UIImage(named: "TimeLinePlaceholder"))
        }*/
    }
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgVw
    }

    @IBAction func btnActionBackClicked(sender : UIButton) {
       // _ = self.navigationController?.popViewController(animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }, completion: {
            (value: Bool) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
    }
    func vwTapped(sender : UITapGestureRecognizer) {
        // Do what you want
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
        }, completion: {
            (value: Bool) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
    }
    
    override func didReceiveMemoryWarning() {
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
