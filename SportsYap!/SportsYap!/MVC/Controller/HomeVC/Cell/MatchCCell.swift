//
//  MatchCCell.swift
//  SportsYap!
//
//  Created by Ketan Patel on 23/05/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class MatchCCell: UICollectionViewCell {

    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var ivChallenge: UIImageView!
    @IBOutlet weak var lblScore2: UILabel!
    @IBOutlet weak var lblScore1: UILabel!
    @IBOutlet weak var lblStatusIcon: UILabel!
    
    @IBOutlet weak var lblFirstNameTeam1: UILabel!
    @IBOutlet weak var lblLastNameTeam1: UILabel!
    @IBOutlet weak var lblFirstNameTeam2: UILabel!
    @IBOutlet weak var lblLastNameTeam2: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 5
        setCornurRedius(idObject: lblStatusIcon, radius: lblStatusIcon.frame.size.height/2)
    }

    
}
