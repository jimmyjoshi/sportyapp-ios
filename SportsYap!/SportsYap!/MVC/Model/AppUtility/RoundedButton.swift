//
//  RoundedButton.swift
//  SportsYap!
//
//  Created by Ketan Patel on 16/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.layer.cornerRadius = self.bounds.size.height / 2.0
            self.clipsToBounds = true
        }
    }
}
