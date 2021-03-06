//
//  MoreVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 31/05/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class MoreVC: UIViewController {
    
    @IBOutlet private var viewMain: UIView!
    @IBOutlet private var btnAddShots: UIButton!
    @IBOutlet private var btnTimeline: UIButton!
    
    @IBOutlet private var viewOptions: UIView!
    var currentGame = GameClass()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showViewWithAnimation()
        
        setCornurRedius(idObject: viewMain, radius: 10.0)
        
        setCornurRedius(idObject: self.btnAddShots, radius: 3)
        setCornurRedius(idObject: self.btnTimeline, radius: 3)
        self.btnAddShots.layer.borderWidth = 0.7
        self.btnAddShots.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
        
        self.btnTimeline.layer.borderWidth = 0.7
        self.btnTimeline.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Animation Method
    
    private func showViewWithAnimation() {
        
        self.view.alpha = 0
        self.viewMain.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3) {
            self.viewMain.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1
        }
        
    }
    
    func hideViewWithAnimation() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewMain.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
    }
    
    
    //MARK:- IBAction Methods
    
    @IBAction func btnBackPressed(btnSender: UIButton) {
        self.hideViewWithAnimation()
    }
    
    @IBAction func btnAddShotClicked(btnSender: UIButton) {
        viewOptions.isHidden = false
    }
    
    @IBAction func btnChallengeTimeline(btnSender: UIButton) {
        viewOptions.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewMain.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let postVC: ChallengePostListViewController = cameraStoryboard.instantiateViewController(withIdentifier: "ChallengePostListViewController") as! ChallengePostListViewController
            postVC.currentGameObject = self.currentGame
            //postVC.strMatchId = self.currentGame.strMatchId
            self.navigationController?.pushViewController(postVC, animated: true)
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
    }
    
    @IBAction func btnImageClicked(btnSender: UIButton) {
        /*
        viewOptions.isHidden = true
        self.hideViewWithAnimation()
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        postVC.isImageUploaded = true
        postVC.selectedGame = currentGame
        postVC.isCreateFanChallengeScreen = true
        self.navigationController?.pushViewController(postVC, animated: true)
        */
        
        viewOptions.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewMain.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
            postVC.isImageUploaded = true
            postVC.selectedGame = self.currentGame
            postVC.isCreateFanChallengeScreen = true
            self.navigationController?.pushViewController(postVC, animated: true)
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
        
        
        
        
    }
    
    @IBAction func btnVideoClicked(btnSender: UIButton) {
        //self.hideViewWithAnimation()
        viewOptions.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            
            self.viewMain.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
            postVC.isVideoUploaded = true
            postVC.isCreateFanChallengeScreen = true
            postVC.selectedGame = self.currentGame
            self.navigationController?.pushViewController(postVC, animated: true)
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
    }
    
    @IBAction func btnClosedClicked(btnSender: UIButton) {
        //self.hideViewWithAnimation()
        viewOptions.isHidden = true
    }
}
