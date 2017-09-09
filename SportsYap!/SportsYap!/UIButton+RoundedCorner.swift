//
//  UIButton+RoundedCorner.swift
//  Navigation
//
//
import Foundation
import UIKit
/* Usage :- This extension can be directly used with UIButton object by cornerRadius of image which needs to be downloaded.
   If we are not passing any value then it will make border of circle circular
 Example :- let btnSubmit = UIButton()
 btnSubmit.setRoundedCorner(radius: nil)
 OR
 btnSubmit.setRoundedCorner(radius: 15.0)
 */
extension UIButton {
    func setRoundedCorner(radius: CGFloat?){
        if radius == nil {
            self.layer.cornerRadius = self.frame.size.height/2
        }
        else
        {
            self.layer.cornerRadius = radius!
        }
        self.clipsToBounds = true
    }
}
