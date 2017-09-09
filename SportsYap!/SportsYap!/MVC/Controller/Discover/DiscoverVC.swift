//
//  DiscoverVC.swift
//  SportsYap!
//
//  Created by Ketan Patel on 24/04/17.
//  Copyright © 2017 Ketan Patel. All rights reserved.
//

import UIKit



class SportsTypeDiscoverCell: UICollectionViewCell {
    @IBOutlet weak var btnGame: UIButton!
    
    override func awakeFromNib() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.btnGame.layer.cornerRadius = self.btnGame.frame.size.height/2
            self.btnGame.layer.masksToBounds = true
            self.btnGame.layer.borderColor = UIColor.black.cgColor
        }
    }
    
}







class DiscoverVC: UIViewController {
    
    @IBOutlet weak var cvMatchList: UICollectionView!
    var selectedIndex: Int!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        selectedIndex = 0
        
        cvMatchList.register(UINib(nibName: "MatchCCell", bundle: nil), forCellWithReuseIdentifier: "MatchCCell")
        cvMatchList.register(UINib(nibName: "MatchSmallCCell", bundle: nil), forCellWithReuseIdentifier: "MatchSmallCCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnSearchPressed(_ : UIButton) {
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let discoverUserVC = homeStoryboard.instantiateViewController(withIdentifier: "DiscoverUserVC")
        self.navigationController?.pushViewController(discoverUserVC, animated: true)
    }
    
}

extension DiscoverVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView.tag == 0) {
            return 5
        }
        else {
            return 50
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        if(collectionView.tag == 0) {
            return CGSize(width: 55, height: 55)
        }
        else {
            if(indexPath.row == 0) {
                return CGSize(width: (screenWidth*304)/320, height: (screenHeight*130)/568)
            }
            else {
                return CGSize(width: (((screenWidth*300)/320)/2)-5, height: (screenHeight*115)/568)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView.tag == 0) {
            let cell: SportsTypeDiscoverCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportsTypeDiscoverCell", for: indexPath) as! SportsTypeDiscoverCell
            
            if(indexPath.row == selectedIndex) {
                cell.btnGame.setImage(UIImage(named: "sball\(indexPath.row)"), for: .normal)
            }
            else {
                cell.btnGame.setImage(UIImage(named: "usball\(indexPath.row)"), for: .normal)
            }
            
            return cell
            
        }
        else {
            
            if(indexPath.row == 0) {
                
                let cell: MatchCCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCCell", for: indexPath) as! MatchCCell
                
                var index = indexPath.row
                
                if(index >= 5) {
                    index = indexPath.row % 5
                }
                
                cell.ivImage.image = UIImage(named: "Game_image\(index)")
                
                return cell
                
            }
            else {
                let cell: MatchSmallCCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchSmallCCell", for: indexPath) as! MatchSmallCCell
                
                var index = indexPath.row
                
                if(index >= 5) {
                    index = indexPath.row % 5
                }
                
                cell.ivImage.image = UIImage(named: "Game_image\(index)_p")
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView.tag != 0) {//Matches Selection
            
        }
        else {//Game Selection
            
            var cell: SportsTypeDiscoverCell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0)) as! SportsTypeDiscoverCell
            cell.btnGame.setImage(UIImage(named: "usball\(selectedIndex!)"), for: .normal)
            
            
            selectedIndex = indexPath.row
            cell = collectionView.cellForItem(at: indexPath) as! SportsTypeDiscoverCell
            cell.btnGame.setImage(UIImage(named: "sball\(indexPath.row)"), for: .normal)
            
        }
    }
}

