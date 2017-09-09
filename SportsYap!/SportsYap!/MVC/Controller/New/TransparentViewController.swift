//
//  TransparentViewController.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 07/08/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class TransparentViewController: UIViewController {

    @IBOutlet weak var btnCreateFanChallenge: UIButton!
    @IBOutlet weak var btnPostToTimeLine: UIButton!
    @IBOutlet weak var btnPostToGame: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var vwBg: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        btnCreateFanChallenge.setRoundedCorner(radius: nil)
        btnPostToGame.setRoundedCorner(radius: nil)
        btnPostToTimeLine.setRoundedCorner(radius: nil)
        btnClose.setRoundedCorner(radius: nil)
        
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.vwTapped(sender:)))
        self.vwBg.addGestureRecognizer(gesture)
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- View Clicked Event
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

    @IBAction private func btnCloseView(_ :UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
        
    }
    
    @IBAction func btnCreatePostClicked(sender: UIButton) {
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: NewVC = cameraStoryboard.instantiateViewController(withIdentifier: "NewVC") as! NewVC
        self.navigationController?.pushViewController(postVC, animated: true)
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    @IBAction func btnCreateFanChallengeClicked(sender: UIButton) {
        
    }
    
    @IBAction func btnCreatePostToGameClicked(sender: UIButton) {
        
        /*
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: PostToGameViewController = cameraStoryboard.instantiateViewController(withIdentifier: "PostToGameViewController") as! PostToGameViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        */
        let cameraStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postVC: GameListingViewController = cameraStoryboard.instantiateViewController(withIdentifier: "GameListingViewController") as! GameListingViewController
        self.navigationController?.pushViewController(postVC, animated: true)
        
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
}
