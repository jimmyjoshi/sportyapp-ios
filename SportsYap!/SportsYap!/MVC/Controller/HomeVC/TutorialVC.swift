//
//  TutorialVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 20/05/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class TutorialVC: UIViewController {

    @IBOutlet private weak var viewInner: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewInner.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBAction Methods
    
    @IBAction private func btnStartupCliecked(_ :UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.alpha = 0
            
        }, completion: {
            (value: Bool) in

            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        })
        
    }
    
}
