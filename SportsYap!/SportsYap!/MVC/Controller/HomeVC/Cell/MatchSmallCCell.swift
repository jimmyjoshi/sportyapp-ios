//
//  MatchSmallCCell.swift
//  SportsYap!
//
//  Created by Ketan Patel on 23/05/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class MatchSmallCCell: UICollectionViewCell {

    @IBOutlet weak var ivImage: UIImageView!
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 5
    }

}
