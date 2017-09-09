//
//  TagGameCellTableViewCell.swift
//  SportsYap!
//
//  Created by Ravi Panicker on 12/07/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit

class TagGameCellTableViewCell: UITableViewCell {
    var tagGame : TagGameVC?
    
    @IBOutlet weak var lblFirstName1: UILabel!
    @IBOutlet weak var lblLastName1: UILabel!
    @IBOutlet weak var lblScore1: UILabel!
    @IBOutlet weak var btnBg1: UIButton!
    
    @IBOutlet weak var lblFirstName2: UILabel!
    @IBOutlet weak var lblLastName2: UILabel!
    @IBOutlet weak var lblScore2: UILabel!
    @IBOutlet weak var btnBg2: UIButton!
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    
    @IBAction func btnBgActionClicked(sender : UIButton) {
        
        tagGame?.btnAdd.isHidden = false
        
        let buttonPosition = sender.convert(CGPoint.zero, to: tagGame?.tblTagGame)
        let indexPath = tagGame?.tblTagGame.indexPathForRow(at: buttonPosition)
        
        if sender.tag == 101 {
            //Btn First Clicked
            
            tagGame?.intSelectedValue = ((indexPath?.row)!,0)
        }
        else if sender.tag == 102 {
            //Btn Second Clicked
            tagGame?.intSelectedValue = ((indexPath?.row)!,1)
        }
        
        tagGame?.changeButtonTitle()
        tagGame?.tblTagGame.reloadData()
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
