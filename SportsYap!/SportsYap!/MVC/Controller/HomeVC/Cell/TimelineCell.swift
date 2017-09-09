//
//  TimelineCell.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 22/07/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class TimelineCell: UICollectionViewCell {
    @IBOutlet weak var imgGameType: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblVenue: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var vwPerson: UIView!
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    override func awakeFromNib() {
        btnLike.layer.cornerRadius = 5
        btnLike.layer.borderWidth = 1
        btnLike.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
        btnComment.layer.cornerRadius = 5
        btnComment.layer.borderWidth = 1
        btnComment.layer.borderColor = #colorLiteral(red: 0.1251283586, green: 0.6060261726, blue: 1, alpha: 1).cgColor
        /*
        for view in vwPerson.subviews{
            view.removeFromSuperview()
        }*/
        
    }
}
